package com.example.onetapgodot;

import android.app.Activity
import android.content.Intent
import android.content.IntentSender
import android.view.View
import androidx.collection.ArraySet
import androidx.core.app.ActivityCompat.startIntentSenderForResult
import com.google.android.gms.auth.api.identity.BeginSignInRequest
import com.google.android.gms.auth.api.identity.Identity
import com.google.android.gms.auth.api.identity.SignInClient
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.CommonStatusCodes
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo

private lateinit var oneTapClient: SignInClient
private lateinit var signInRequest: BeginSignInRequest
private var webClientID:String = ""
private const val REQ_ONE_TAP = 2
private const val TAG = "godot"

class Main(activity: Godot) : GodotPlugin(activity) {

    override fun onMainCreate(activity: Activity): View? {
        oneTapClient = Identity.getSignInClient(activity)
        return super.onMainCreate(activity)
    }

    override fun onMainActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        when (requestCode) {
            REQ_ONE_TAP -> {
                try {
                    val credential = oneTapClient.getSignInCredentialFromIntent(data)

                    val signInCredentialDict = Dictionary()
                    signInCredentialDict["id"] = credential.id
                    signInCredentialDict["displayName"] = credential.displayName
                    signInCredentialDict["givenName"] = credential.givenName
                    signInCredentialDict["familyName"] = credential.familyName
                    signInCredentialDict["profilePictureUri"] = credential.profilePictureUri.toString()
                    signInCredentialDict["password"] = credential.password
                    signInCredentialDict["googleIdToken"] = credential.googleIdToken
                    signInCredentialDict["phoneNumber"] = credential.phoneNumber

                    emitSignal("on_success", signInCredentialDict)

                } catch (e: ApiException) {
                    e.message?.let { emitError( it, CommonStatusCodes.getStatusCodeString(e.statusCode)) }
                }
            }
        }
    }

    override fun getPluginName(): String {
        return "one-tap-android-godot"
    }

    override fun getPluginSignals(): Set<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo("on_success", Dictionary::class.java))
        signals.add(SignalInfo("on_error", Dictionary::class.java))

        return signals
    }

    override fun getPluginMethods(): List<String> {
        return listOf("signIn","signOut","setWebClientID")
    }

    fun setWebClientID(ID:String) {
        webClientID = ID
    }

    fun signOut() {
        oneTapClient.signOut()
    }

    fun signIn(authorizedAccounts: Boolean, autoSelect: Boolean) {
        signInRequest = BeginSignInRequest.builder()
            .setPasswordRequestOptions(
                BeginSignInRequest.PasswordRequestOptions.builder()
                    .setSupported(true)
                    .build()
            )
            .setGoogleIdTokenRequestOptions(
                BeginSignInRequest.GoogleIdTokenRequestOptions.builder()
                    .setSupported(true)
                    .setServerClientId(webClientID)
                    .setFilterByAuthorizedAccounts(authorizedAccounts)
                    .build()
            )
            .setAutoSelectEnabled(autoSelect)
            .build()

        oneTapClient.beginSignIn(signInRequest)
            .addOnSuccessListener(activity!!) { result ->
                try {
                    startIntentSenderForResult(
                        activity!!,
                        result.pendingIntent.intentSender, REQ_ONE_TAP,
                        null, 0, 0, 0, null
                    )
                } catch (e: IntentSender.SendIntentException) {
                    e.message?.let { emitError(it) }
                }
            }
            .addOnFailureListener(activity!!) { e ->
                e.message?.let {
                    if (e is ApiException) {
                        emitError( it, CommonStatusCodes.getStatusCodeString(e.statusCode))
                    } else {
                        emitError(it)
                    }
                }
            }
    }

    private fun emitError(errorMessage:String, errorCode:String ="") {
        val errorDict = Dictionary()
        errorDict["message"] = errorMessage
        errorDict["code"] = errorCode
        emitSignal("on_error", errorDict)
    }
}