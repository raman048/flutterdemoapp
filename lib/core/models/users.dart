class Users {
  int _id;
  String _f_name;
  String _l_name;
  String _email_id;
  String _password;
  String _gender;
  String _date_of_birth;
  String _user_image;

  Users(this._id, this._f_name, this._l_name, this._email_id, this._password,
      this._gender, this._date_of_birth, this._user_image);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'f_name': _f_name,
      'l_name': _l_name,
      'email_id': _email_id,
      'u_password': _password,
      'gender': _gender,
      'date_of_birth': _date_of_birth,
      'user_image': _user_image
    };
  }

  Users.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _f_name = map['f_name'];
    _l_name = map['l_name'];
    _email_id = map['email_id'];
    _password = map['u_password'];
    _gender = map['gender'];
    _date_of_birth = map['date_of_birth'];
    _user_image = map['user_image'];
  }

  String get f_name => _f_name;

  set f_name(String value) {
    _f_name = value;
  }

  String get l_name => _l_name;

  set l_name(String value) {
    _l_name = value;
  }

  String get email_id => _email_id;

  set email_id(String value) {
    _email_id = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
  }

  String get date_of_birth => _date_of_birth;

  set date_of_birth(String value) {
    _date_of_birth = value;
  }

  String get user_image => _user_image;

  set user_image(String value) {
    _user_image = value;
  }
}
