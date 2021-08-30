import 'package:dima_colombo_ghiazzi/Model/user.dart';
import 'package:dima_colombo_ghiazzi/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileBody extends StatelessWidget {
  final User user;

  UserProfileBody({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // background image and bottom contents
        Column(
          children: <Widget>[
            Container(
              height: 165.0,
              color: kPrimaryColor,
            ),
            SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: size.width / 10, right: size.width / 10),
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: kPrimaryLightColor,
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                              child: Text(
                                            user.name.toUpperCase() +
                                                " " +
                                                user.surname.toUpperCase(),
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ))
                                        ]))),
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: size.height * 0.05,
                                ),
                                Image.asset(
                                  "assets/icons/small_logo.png",
                                  height: size.height * 0.1,
                                ),
                                user.getData()['profilePhoto'] != null
                                    ? Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: kPrimaryColor,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                          ),
                                          Text(user.getData()['phoneNumber'],
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.mail,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.05,
                                    ),
                                    Flexible(
                                      child: Text(user.email,
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 15,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.lock,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.05,
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        child: Text(
                                          "Reset password",
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onTap: () {
                                          //authViewModel.resetPassword(user.email);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                user.getData()['profilePhoto'] != null
                                    ? Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.house,
                                            color: kPrimaryColor,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                          ),
                                          Flexible(
                                            child: GestureDetector(
                                              child: Text(
                                                  user.getData()['address'],
                                                  style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onTap: () {
                                                openMaps();
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: size.height * 0.06,
                                ),
                                Divider(
                                  color: kPrimaryColor,
                                  height: 1.5,
                                ),
                                SizedBox(
                                  height: size.height * 0.06,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )))
          ],
        ),
        // Profile image
        Positioned(
          child: Column(
            children: <Widget>[
              Center(
                child: InkWell(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                    height: size.height * 0.05,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    //authViewModel.logOut();
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Center(
                child: InkWell(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                    height: size.height * 0.05,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Delete account",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    //authViewModel.deleteAccount();
                  },
                ),
              ),
            ],
          ),
          bottom: 50,
        ),
        Positioned(
          top: 100.0, // (background container size) - (circle height / 2)
          child: user.getData()['profilePhoto'] != null
              ? CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.network(
                      user.getData()['profilePhoto'],
                      fit: BoxFit.cover,
                      width: 120.0,
                      height: 120.0,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 120.0,
                          height: 120.0,
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                            value: loadingProgress.expectedTotalBytes != null &&
                                    loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Text(
                              "${user.name[0]}",
                              style:
                                  TextStyle(color: kPrimaryColor, fontSize: 30),
                            ));
                      },
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: kPrimaryColor,
                  )),
        ),
        Positioned(
          top: 60,
          left: 25,
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              Navigator.pop(context);
            },
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.transparent,
            child: const Icon(Icons.arrow_back, size: 40.0),
          ),
        ),
      ],
    );
  }

  void openMaps() async {
    var lat = user.getData()['latLng'].latitude;
    var lng = user.getData()['latLng'].longitude;
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
