class MobileNoModel {
  int _id;
  int _userId;
  String _mobileNo;

  MobileNoModel(this._id, this._userId, this._mobileNo);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    return {'m_id': _id, 'user_id': _userId, 'mobile_no': _mobileNo};
  }

  MobileNoModel.fromMap(Map<String, dynamic> map) {
    _id = map['m_id'];
    _userId = map['user_id'];
    _mobileNo = map['mobile_no'];
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  String get mobileNo => _mobileNo;

  set mobileNo(String value) {
    _mobileNo = value;
  }
}
