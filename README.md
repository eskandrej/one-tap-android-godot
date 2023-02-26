# one-tap-android-godot

Android plugin for Godot that uses One Tap API for login.

![anim](https://user-images.githubusercontent.com/122531384/221402464-915101ef-5edd-4f86-985c-0f028fc3b573.gif)

# Compile Plugin

1. Download AAR library for Android [https://godotengine.org/download](https://godotengine.org/download)
2. Rename AAR library to godot-lib.release.aar and place it in Plugin-source/app/libs
3. Open Plugin-source folder in Android Studio
4. Click on Build -> Make Project

Compiled plugin will be in Plugin folder and also copied in Demo project.

# Running Demo

1. [Compile Plugin](https://github.com/eskandrej/one-tap-android-godot/new/main?readme=1#compile-plugin)
2. Open Demo/project.godot in Godot 4
3. Create web client id following [Set up your Google APIs console project](https://developers.google.com/identity/one-tap/android/get-started#api-console) 
    <br>**note:**  App's package name is **org.godotengine.onetapdemo**
5. Set your web client id in [Main.gd](https://github.com/eskandrej/one-tap-android-godot/blob/main/Demo/Main.gd#L12)
6. Download and install Android Build Template from Project menu

# Usage

## functions:
<dl>
  <dt>setWebClientID(webClientId: String)</dt>
  <dd>Set this function before calling any other. For web client ID follow https://developers.google.com/identity/one-tap/android/get-started#api-console</dd>

  <dt>signIn(authorizedAccounts: Boolean, autoSelect: Boolean)</dt>
  <dd>authorizedAccounts:</dd>
  <dd>Sets whether to only allow the user to select from Google accounts that are already authorized to sign in to your application.
If true, the user will not be able to select any Google account that would otherwise require explicit authorization to share basic profile/email data with your application. This may reduce some friction in the sign-in user journey, and guarantees that the returned credential is for a "returning user", but limits the user's freedom to choose among all the Google accounts on the device</dd>
  <dd>autoSelect:</dd>
  <dd>Sets the auto-select behavior in the request.
For users who opt-in, Auto Select allows a credential to be selected automatically without waiting for a user action (such as tapping on the "continue" button). A credential can be auto selected if 1) only one credential can be used for sign-in; and 2) no further actions need to be taken for this credential (for example, data sharing permissions are already collected for a Google account).</dd>
  
  <dt>signOut()</dt>
  <dd>Signs out</dd>
</dl>

## signals:

<dl>
  <dt>on_success(data:Dictionary)</dt>
  <dd>When the login succeeds, it returns dictionary data(fields could be null):<br>
    <br>data.id
    <br>data.displayName
    <br>data.givenName
    <br>data.familyName
    <br>data.profilePictureUri
    <br>data.password
    <br>data.googleIdToken
    <br>data.phoneNumber
  </dd>

  <dt>on_error(error:Dictionary)</dt>
  <dd>Returns <a href="https://developers.google.com/android/reference/com/google/android/gms/common/api/CommonStatusCodes">error code</a> and message.<br>
    <br>error.code
    <br>error.message
  </dd>
</dl>
