extends PanelContainer

@onready var profile_picture_trect:TextureRect = $VBoxContainer/ProfilePictureTRect
@onready var id_val_lbl:Label = %IdValLbl
@onready var display_name_val_lbl:Label = %DisplayNameValLbl
@onready var given_name_val_lbl:Label = %GivenNameValLbl
@onready var family_name_val_lbl:Label = %FamilyNameValLbl
@onready var profile_picture_uri_val_lbl:Label = %ProfilePictureUriValLbl
@onready var password_val_lbl:Label = %PasswordValLbl
@onready var google_id_token_val_lbl:Label = %GoogleIdTokenValLbl
@onready var phone_number_val_lbl:Label = %PhoneNumberValLbl

var data: Dictionary : set = _set_data

func _set_data(new_data:Dictionary) -> void:
	clear()
	data = new_data
	if data.id: id_val_lbl.text = data.id
	if data.displayName: display_name_val_lbl.text = data.displayName
	if data.givenName: given_name_val_lbl.text = data.givenName
	if data.familyName: family_name_val_lbl.text = data.familyName
	if data.password: password_val_lbl.text = data.password
	if data.googleIdToken: google_id_token_val_lbl.text = data.googleIdToken
	if data.phoneNumber: phone_number_val_lbl.text = data.phoneNumber
	if data.profilePictureUri: 
		profile_picture_uri_val_lbl.text = data.profilePictureUri
		donwload_profile_picture(data.profilePictureUri)

func donwload_profile_picture(url:String) -> void:
	var http_request = HTTPRequest.new()
	
	add_child(http_request)
	http_request.request_completed.connect(
		func(result, response_code, headers, body):
			if result != HTTPRequest.RESULT_SUCCESS:
				push_error("Image couldn't be downloaded. Try a different image.")

			var image = Image.new()
			var error = image.load_png_from_buffer(body)
			if error != OK:
				push_error("Couldn't load the image.")

			var texture = ImageTexture.create_from_image(image)
			profile_picture_trect.texture = texture
			http_request.queue_free()
	)
	
	var error = http_request.request(url)
	if error != OK: push_error("An error occurred in the HTTP request.")
	
func clear() -> void:
	id_val_lbl.text = ""
	display_name_val_lbl.text = ""
	given_name_val_lbl.text = ""
	family_name_val_lbl.text = ""
	password_val_lbl.text = ""
	google_id_token_val_lbl.text = ""
	phone_number_val_lbl.text = ""
	profile_picture_uri_val_lbl.text = ""
	profile_picture_trect.texture = null
