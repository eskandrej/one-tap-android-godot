extends Control

var one_tap_plugin: JNISingleton
@onready var error_dialog:AcceptDialog = %ErrorDialog
@onready var profile:PanelContainer = $Profile
@onready var sign_in_btn:Button = $SignInBtn
@onready var sign_out_btn:Button = $SignOutBtn

func _ready() -> void:
	if Engine.has_singleton("one-tap-android-godot"):
		one_tap_plugin = Engine.get_singleton("one-tap-android-godot")
		one_tap_plugin.setWebClientID("PLACE YOUR WEBCLIENT ID HERE")
	else:
		error_dialog.dialog_text = "Plugin not loaded! Check if it's enabled in Android export"
		error_dialog.popup_centered()
		
	if one_tap_plugin:
		one_tap_plugin.connect("on_success",Callable(self,"_one_tap_on_success"))
		one_tap_plugin.connect("on_error",Callable(self,"_one_tap_on_error"))

func _on_SignOutBtn_pressed() -> void:
	one_tap_plugin.signOut()
	profile.hide()
	sign_in_btn.show()
	sign_out_btn.hide()

func _on_SignInBtn_pressed() -> void:
	if one_tap_plugin: 
		# authorizedAccounts: Boolean, autoSelect: Boolean
		one_tap_plugin.signIn(false, true)

func _one_tap_on_success(data: Dictionary) -> void:
	profile.data = data
	profile.show()
	sign_in_btn.hide()
	sign_out_btn.show()

func _one_tap_on_error(error: Dictionary) -> void:
	if error.message.find("Missing Feature") > -1:
		error.message = "Not supported!!!"
#    Error codes: https://developers.google.com/android/reference/com/google/android/gms/common/api/CommonStatusCodes
	error_dialog.dialog_text = "Error code: %s \nError message: %s" % [error.code, error.message]
	error_dialog.popup_centered()
