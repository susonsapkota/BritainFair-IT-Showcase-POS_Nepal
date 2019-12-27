import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List data;

  dynamic icons = [
    "img/icons/1.png",
    "img/icons/2.png",
    "img/icons/3.png",
    "img/icons/4.png",
    "img/icons/5.png",
    "img/icons/6.png",
    "img/icons/7.png",
    "img/icons/8.png"
  ];
  Random rnd;

  Widget buildImage(BuildContext context) {
    int min = 0;
    int max = icons.length - 1;
    rnd = new Random();
    int r = min + rnd.nextInt(max - min);
    String image_name = icons[r].toString();
    return Image.asset(image_name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: new IconThemeData(color: Colors.black),
        title: Text(
          'POS Nepal',
          style: TextStyle(fontSize: 22.0, color: Colors.black),
        ),
      ),
      body: Container(
        child: new Center(
          child: new FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('jsons/transactions.json'),
            builder: (context, snapshot) {
              var mydata = json.decode(snapshot.data.toString());
              return new ListView.builder(
                  itemCount: mydata == null ? 0 : mydata.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 210,
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.white,
                        elevation: 20,
                        margin: EdgeInsets.all(10.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new ListTile(
                              leading: mydata[index]['type'] == 'cash'
                                  ? Container(
                                      child: Icon(
                                        FontAwesomeIcons.moneyBill,
                                        color: Colors.lightGreen,
                                        size: 30.0,
                                      ),
                                      alignment: Alignment.bottomLeft,
                                      width: 50)
                                  : Container(
                                      child: Icon(
                                        FontAwesomeIcons.creditCard,
                                        color: Colors.redAccent,
                                        size: 30.0,
                                      ),
                                      alignment: Alignment.bottomLeft,
                                      height: 100,
                                      width: 50),
                              title: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Padding(
                                  child: Text(
                                    mydata[index]['from'] +
                                        " to " +
                                        mydata[index]['to'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pinkAccent),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 15),
                                ),
                              ),
                              isThreeLine: true,
                              subtitle: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 7),
                                    child: Container(
                                      child: new Column(
                                        children: <Widget>[
                                          new Text(
                                              "Date : " + mydata[index]['date'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          new Text(
                                              "Time : " + mydata[index]['time'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          new Text(
                                              "Route No : " +
                                                  mydata[index]['route'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          new Text(
                                              "Bus No : " +
                                                  mydata[index]['bus'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          new Text(
                                              "Fare : " + mydata[index]['fare'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          new Text(
                                              "Payment Type : " +
                                                  mydata[index]['type'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          new Text(
                                              "Remarks : " +
                                                  mydata[index]['remarks'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
//
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
