# Existing media 
resource "matrix_content" "catpic" {
  # Your MXC URI must fit the following format/example: 
  #   Format:   mxc://origin/media_id
  #   Example:  mxc://matrix.org/SomeGeneratedId
  origin   = "matrix.org"
  media_id = "SomeGeneratedId"
}

# New media (upload)
resource "matrix_content" "catpic" {
  file_path = "/path/to/cat_pic.png"
  file_name = "cat_pic.png"
  file_type = "image/png"
}

# Username/password user
resource "matrix_user" "foouser" {
  username = "foouser"
  password = "hunter2"

  # These properties are optional, and will update the user's profile
  # We're using a reference to the Media used in an earlier example
  display_name = "My Cool User"
  avatar_mxc   = matrix_content.catpic.id
}


# Access token user
resource "matrix_user" "baruser" {
  access_token = "MDAxOtherCharactersHere"

  # These properties are optional, and will update the user's profile
  # We're using a reference to the Media used in an earlier example
  display_name = "My Cool User"
  avatar_mxc   = matrix_content.catpic.id
}

# Already existing room
resource "matrix_room" "fooroom" {
  room_id             = "!somewhere:domain.com"
  member_access_token = matrix_user.foouser.access_token
}

# New room
resource "matrix_room" "barroom" {
  creator_user_id     = matrix_user.foouser.id
  member_access_token = matrix_user.foouser.access_token

  # The rest is optional
  name                  = "My Room"
  avatar_mxc            = matrix_content.catpic.id
  topic                 = "For testing only please"
  preset                = "public_chat"
  guests_allowed        = true
  invite_user_ids       = ["${matrix_user.baruser.id}"]
  local_alias_localpart = "myroom"
}
