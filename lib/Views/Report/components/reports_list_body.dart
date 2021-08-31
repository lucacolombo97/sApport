import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_colombo_ghiazzi/Router/app_router_delegate.dart';
import 'package:dima_colombo_ghiazzi/ViewModel/BaseUser/report_view_model.dart';
import 'package:dima_colombo_ghiazzi/Views/Chat/components/top_bar.dart';
import 'package:dima_colombo_ghiazzi/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReportsListBody extends StatefulWidget {
  final ReportViewModel reportViewModel;

  ReportsListBody({Key key, @required this.reportViewModel}) : super(key: key);

  @override
  _ReportsListBodyState createState() => _ReportsListBodyState();
}

class _ReportsListBodyState extends State<ReportsListBody> {
  final ScrollController listScrollController = ScrollController();
  AppRouterDelegate routerDelegate;
  Alert alert;
  bool isLoading = false;
  int _limitIncrement = 20;

  @override
  void initState() {
    listScrollController.addListener(scrollListener);
    routerDelegate = Provider.of<AppRouterDelegate>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TopBar(
              text: 'Old reports',
              button: InkWell(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kPrimaryLightColor,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: kPrimaryColor,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Add New",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  routerDelegate.pop();
                },
              ),
            ),
            StreamBuilder(
              stream: widget.reportViewModel.loadReports(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data?.docs[index]),
                    itemCount: snapshot.data.docs.length,
                    controller: listScrollController,
                    shrinkWrap: true,
                  );
                } else
                  return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot doc) {
    // This size provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;
    String date =
        DateFormat('yyyy-MM-dd kk:mm').format(doc.get('date').toDate());
    if (doc != null) {
      return Container(
        child: TextButton(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 25.0,
                      child: Image.asset(
                        "assets/icons/logo.png",
                        height: size.height * 0.05,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      doc.get('category'),
                      style: TextStyle(color: kPrimaryColor, fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(date.split(' ')[0],
                        style: TextStyle(color: kPrimaryColor, fontSize: 10)),
                    Text(
                        date.split(' ')[1].split('.')[0].split(':')[0] +
                            ":" +
                            date.split(' ')[1].split('.')[0].split(':')[1],
                        style: TextStyle(color: kPrimaryColor, fontSize: 10))
                  ],
                )
              ]),
          onPressed: () {
            alert = createAlert(doc.get('category'), doc.get('description'));
            alert.show();
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(kPrimaryLightColor),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limitIncrement += _limitIncrement;
      });
    }
  }

  Alert createAlert(String title, String description) {
    return Alert(
        context: context,
        title: title,
        desc: description,
        image: Image.asset("assets/icons/small_logo.png"),
        closeIcon: Icon(
          Icons.close,
          color: kPrimaryColor,
        ),
        buttons: [
          DialogButton(
            child: Text(
              "CLOSE",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            color: Colors.transparent,
            onPressed: () => alert.dismiss(),
          )
        ]);
  }
}