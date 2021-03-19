class AddressModel {
  int _id;
  int _userId;
  String _address;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  AddressModel(this._id, this._userId, this._address);

  Map<String, dynamic> toMap() {
    return {'a_id': _id, 'user_id': _userId, 'address_detail': _address};
  }

  AddressModel.fromMap(Map<String, dynamic> map) {
    _id = map['a_id'];
    _userId = map['user_id'];
    _address = map['address_detail'];
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }
}
