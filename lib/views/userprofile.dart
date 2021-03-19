import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/address.dart';
import 'package:flutter_app/core/models/mobileno.dart';
import 'package:flutter_app/core/models/users.dart';
import 'package:flutter_app/core/utils/database_helper.dart';
import 'package:flutter_app/views/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/bezierContainer.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfile> {
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  DataBaseHelper dbHelper;
  int id;
  String f_name;
  String l_name;
  String email_id;
  String u_password;
  String gender;
  String date_of_birth;
  String user_image;
  Future<List<MobileNoModel>> mobileNoList;
  Future<List<AddressModel>> addressList;
  @override
  void initState() {
    super.initState();
    dbHelper = DataBaseHelper();

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
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery
        .of(context)
        .size
        .height;
    final Users users = ModalRoute
        .of(context)
        .settings
        .arguments;
    id = users.id;
    f_name = users.f_name;
    l_name = users.l_name;
    email_id = users.email_id;
    u_password = users.password;
    gender = users.gender;
    date_of_birth = users.date_of_birth;
    user_image = users.user_image;

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
                top: -MediaQuery
                    .of(context)
                    .size
                    .height * .3,
                right: -MediaQuery
                    .of(context)
                    .size
                    .width * .4,
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
                        child: user_image != null
                            ? ClipOval(
                          child: Image.file(File(user_image), width: 100.0, height: 100.0, fit: BoxFit.cover),
                        )
                            : ClipOval(
                          child: Image.asset('assets/images/user.jpg',
                              width: 110.0, height: 110.0),
                        ),
                      ),
                      Text(f_name, textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500,)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(l_name, textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500,)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(email_id, textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500,)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(u_password, textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500,)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(gender, textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500,)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(date_of_birth, textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500,)),
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
                              if (snapshot.data == null || snapshot.data.length == 0) {
                                return Text('No Data Found');
                              }
                              return CircularProgressIndicator();
                            },
                          )

                      ),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: FutureBuilder(
                            future: addressList,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return generateAddressList(snapshot.data);
                              }
                              if (snapshot.data == null || snapshot.data.length == 0) {
                                return Text('No Data Found');
                              }
                              return CircularProgressIndicator();
                            },
                          )

                      ),
                      SizedBox(height: height * .1),


                    ],

                  ),
                ),

              ),

              Positioned(top: 40, left: 0, child: _backButton()),
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

  SingleChildScrollView generateAddressList(List<AddressModel> addressModelList) {

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
