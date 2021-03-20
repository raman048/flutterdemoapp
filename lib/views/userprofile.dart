import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/address.dart';
import 'package:flutter_app/core/models/mobileno.dart';
import 'package:flutter_app/core/models/users.dart';
import 'package:flutter_app/core/utils/database_helper.dart';
import 'widgets/bezierContainer.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfile> {
  DataBaseHelper dbHelper;
  int id;
  String _fName;
  String _lName;
  String _emailId;
  String _password;
  String _gender;
  String _dateOfBirth;
  String _userImage;
  Future<List<MobileNoModel>> mobileNoList;
  Future<List<AddressModel>> addressList;

  @override
  void initState() {
    super.initState();
    dbHelper = DataBaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final Users users = ModalRoute.of(context).settings.arguments;
    id = users.id;
    _fName = users.f_name;
    _lName = users.l_name;
    _emailId = users.email_id;
    _password = users.password;
    _gender = users.gender;
    _dateOfBirth = users.date_of_birth;
    _userImage = users.user_image;

    setState(() {
      mobileNoList = dbHelper.getMobileNoList(id);
      addressList = dbHelper.getAddressList(id);
    });
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  ClipOval(
                    child: _userImage != null
                        ? ClipOval(
                            child: Image.file(File(_userImage),
                                width: 100.0, height: 100.0, fit: BoxFit.cover),
                          )
                        : ClipOval(
                            child: Image.asset('assets/images/user.jpg',
                                width: 110.0, height: 110.0),
                          ),
                  ),
                  Text(_fName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_lName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_emailId,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_password,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_gender,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_dateOfBirth,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: FutureBuilder(
                        future: mobileNoList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return generateList(snapshot.data);
                          }
                          if (snapshot.data == null ||
                              snapshot.data.length == 0) {
                            return Text('No Data Found');
                          }
                          return CircularProgressIndicator();
                        },
                      )),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: FutureBuilder(
                        future: addressList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return generateAddressList(snapshot.data);
                          }
                          if (snapshot.data == null ||
                              snapshot.data.length == 0) {
                            return Text('No Data Found');
                          }
                          return CircularProgressIndicator();
                        },
                      )),
                  SizedBox(height: height * .1),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  SingleChildScrollView generateList(List<MobileNoModel> mobileModelList) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text('Mobile No'),
                ),
              ],
              rows: mobileModelList
                  .map(
                    (mobileModel) => DataRow(
                      cells: [
                        DataCell(
                          Text(mobileModel.mobileNo),
                        )
                      ],
                    ),
                  )
                  .toList(),
            )));
  }

  SingleChildScrollView generateAddressList(
      List<AddressModel> addressModelList) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text('Address'),
                ),
              ],
              rows: addressModelList
                  .map(
                    (addressModel) => DataRow(
                      cells: [
                        DataCell(
                          Text(addressModel.address),
                        )
                      ],
                    ),
                  )
                  .toList(),
            )));
  }
}
