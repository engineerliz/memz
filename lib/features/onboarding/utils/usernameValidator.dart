String? validateUsername(String username) {
  final usernameValidChars = RegExp(r'^[a-zA-Z0-9_\.]+$');
  final alphanumeric = RegExp(r'^[a-zA-Z0-9&%=]+$');

  if (username.length < 3) {
    return 'Username must be at least 3 letters.';
  }
  if (username.length > 20) {
    return 'Username must be under 20 letters.';
  }
  if (usernameValidChars.hasMatch(username) == false) {
    return 'Username cannot have spaces or special characters other than . and _';
  }
  if (alphanumeric.hasMatch(username[0]) == false) {
    return 'Username cannot start with a special character.';
  }
  if (alphanumeric.hasMatch(username[username.length - 1]) == false) {
    return 'Username cannot end with a special character.';
  }
  return null;
}
