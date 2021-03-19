import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/address.dart';
import 'package:flutter_app/core/models/mobileno.dart';
import 'package:flutter_app/core/models/users.dart';
import 'package:flutter_app/core/utils/database_helper.dart';
import 'package:flutter_app/views/widgets/bezierContainer.dart';
import 'package:flutter_app/views/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/views/camera.dart';
import 'dart:io' as Io;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

enum Gender { Male, Female }

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dynamicTextController;
  static List<String> phoneNoList = [null];
  static List<String> addressList = [null];
  dynamic _image;
  DataBaseHelper dbHelper;
  Users users;
  Gender _gender = Gender.Male;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  DateTime date;
  String strDate;

  @override
  void initState() {
    super.initState();
    _dynamicTextController = TextEditingController();
    dbHelper = DataBaseHelper();
  }

  @override
  void dispose() {
    phoneNoList = [null];
    addressList = [null];
    _dynamicTextController.dispose();
    super.dispose();
  }



  /// get phone number text-fields
  List<Widget> _getPhoneNumber() {
    List<Widget> phoneNoTextFields = [];
    for (int i = 0; i < phoneNoList.length; i++) {
      phoneNoTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Expanded(child: DynamicTextFields(i, 'Enter Your Mobile Number')),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == phoneNoList.length - 1, i, phoneNoList),
          ],
        ),
      ));
    }

    return phoneNoTextFields;
  }

  /// get phone number text-fields
  List<Widget> _getAddress() {
    List<Widget> addressTextFields = [];
    for (int i = 0; i < addressList.length; i++) {
      addressTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Expanded(child: AddressDynamicTextFields(i, 'Enter your address')),
            SizedBox(
              width: 16,
            ),
            _addRemoveButton(i == addressList.length - 1, i, addressList),
          ],
        ),
      ));
    }
    //addressTextFieldsList = List.castFrom(addressTextFields);
    return addressTextFields;
  }

  Widget _addRemoveButton(bool add, int index, List<String> list) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          list.insert(0, null);
        } else
          list.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _userImageView() {
    return InkWell(
      onTap: () {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: new Text('Camera'),
                        onTap: () => openCamera(context),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      GestureDetector(
                        child: new Text('Open Gallery'),
                        onTap: () => openGallery(context),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: _image != null
              ? ClipOval(
                  child: Image.file(File(_image),
                      width: 100.0, height: 100.0, fit: BoxFit.cover),
                )
              : ClipOval(
                  child: Image.asset('assets/images/user.jpg',
                      width: 110.0, height: 110.0),
                ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 5, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left,
                  color: Colors.black, size: 50.0),
            ),
            Text('',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }



  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date ?? now,
        firstDate: now,
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      print('hello $picked');
      setState(() {
        date = picked;
      });
    }
  }

  Widget buildDateField() {
    return TextFormField(
      controller: _dateOfBirthController,
      onTap: () async {
        // Below line stops keyboard from appearing
        FocusScope.of(context).requestFocus(new FocusNode());
        // Show Date Picker Here
        await _selectDate(context);
        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(date);
        //setState(() {});
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Date of birth',
        contentPadding: EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 12.0,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty) {
          final fname = _firstNameController.text;
          final lname = _lastNameController.text;
          final gender =
              _gender.toString().substring(_gender.toString().indexOf('.') + 1);
          final email_id = _emailIdController.text;
          final password = _passwordController.text;
          final user_image = _image;
          final dateOfBirth = _dateOfBirthController.text;
          bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email_id);
          if(emailValid){
            int insertedId = await dbHelper.insertUserNode(Users(null, fname,
                lname, email_id, password, gender, dateOfBirth, user_image));
            List<MobileNoModel> mobileNoList = [];
            for (int i = 0; i < phoneNoList.length; i++) {
              if (phoneNoList[i] != '') {
                MobileNoModel mobileNo =
                new MobileNoModel(null, insertedId, phoneNoList[i]);
                mobileNoList.add(mobileNo);
              }
            }

            List<AddressModel> addressListModel = [];
            for (int i = 0; i < addressList.length; i++) {
              if (addressList[i] != '') {
                AddressModel address =
                new AddressModel(null, insertedId, addressList[i]);
                addressListModel.add(address);
              }
            }
            await dbHelper.insertMobileNoNode(mobileNoList);
            await dbHelper.insertAddressNode(addressListModel);
            showToast("Registration Successfully");
            Navigator.pop(context);
          }else{
            showToast("Please enter correct email id");
          }

        }else{
          showToast("Please enter detail.");
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffE84D1C), Color(0xfff7892b)])),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryPhoneNumberAddressLabel(String name) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(
            width: 1500,
          ),
        ],
      ),
    );
  }

  Widget _phoneNumberAddressLabel(String name) {
    return Column(
      children: <Widget>[_entryPhoneNumberAddressLabel(name)],
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Nano',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffE84D1C),
          ),
          children: [
            TextSpan(
              text: ' Health ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Suite',
              style: TextStyle(color: Color(0xffE84D1C), fontSize: 30),
            ),
          ]),
    );
  }

  // Widget _emailPasswordWidget() {
  //   return Column(
  //     children: <Widget>[
  //       _entryField("First Name"),
  //       _entryField("Last Name"),
  //       _entryField("Email id"),
  //       _entryField("Password", isPassword: true),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(0),
          color: Colors.white10,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .3,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .08),
                    _title(),
                    SizedBox(
                      height: 30,
                    ),
                    _userImageView(),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailIdController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email id',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ..._getPhoneNumber(),
                    ..._getAddress(),
                    SizedBox(
                      height: 15,
                    ),
                    buildDateField(),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: const Text('Male'),
                      leading: Radio(
                        value: Gender.Male,
                        groupValue: _gender,
                        onChanged: (Gender value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Female'),
                      leading: Radio(
                        value: Gender.Female,
                        groupValue: _gender,
                        onChanged: (Gender value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .03),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
  void openCamera(context) async {
    var status = await Permission.storage.status;
    if (status == PermissionStatus.granted) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      final image = await CustomCamera.openCamera();

      setState(() {
        _image = image;
      });
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      statuses[Permission.storage];
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Color(0xfff7892b),
        fontSize: 16.0);
  }

  void openGallery(context) async {
    var status = await Permission.storage.status;
    if (status == PermissionStatus.granted) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      final image = await CustomCamera.openGallery();

      setState(() {
        _image = image;
      });
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      statuses[Permission.storage];
    }
  }
}

class DynamicTextFields extends StatefulWidget {
  final int index;
  final String textBoxText;

  DynamicTextFields(this.index, this.textBoxText);

  @override
  _DynamicTextFieldsState createState() => _DynamicTextFieldsState();
}

class _DynamicTextFieldsState extends State<DynamicTextFields> {
  TextEditingController _dynamicTextController;

  @override
  void initState() {
    super.initState();
    _dynamicTextController = TextEditingController();
  }

  @override
  void dispose() {
    _dynamicTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _dynamicTextController.text =
          _SignUpPageState.phoneNoList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _dynamicTextController,
      keyboardType: TextInputType.number,
      onChanged: (v) => _SignUpPageState.phoneNoList[widget.index] = v,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Mobile No',
          contentPadding: EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 12.0,
          )),
    );
  }
}

class AddressDynamicTextFields extends StatefulWidget {
  final int index;
  final String textBoxText;

  AddressDynamicTextFields(this.index, this.textBoxText);

  @override
  _AddressDynamicTextFieldsState createState() =>
      _AddressDynamicTextFieldsState();
}

class _AddressDynamicTextFieldsState extends State<AddressDynamicTextFields> {
  TextEditingController _addressDynamicTextController;

  @override
  void initState() {
    super.initState();
    _addressDynamicTextController = TextEditingController();
  }

  @override
  void dispose() {
    _addressDynamicTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addressDynamicTextController.text =
          _SignUpPageState.addressList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _addressDynamicTextController,
      onChanged: (v) => _SignUpPageState.addressList[widget.index] = v,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Address',
          contentPadding: EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 12.0,
          )),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
