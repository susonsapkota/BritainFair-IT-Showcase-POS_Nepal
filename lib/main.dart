import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_nepal/DataSearch.dart';
import 'package:pos_nepal/PaymentScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Transactions.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

//API Key : AIzaSyDxlMn6PQJunaDFgpeRUYiIagOcOEarzMk

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controllerFrom = new TextEditingController();
  TextEditingController controllerTo = new TextEditingController();
  TextEditingController controllerRate = new TextEditingController();

  void Popupdata(String cashOrCard) {
    AlertDialog alertDialog = new AlertDialog(
      content: new Container(
        height: 200.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("From : ${controllerFrom.text} "),
            new Text("To : ${controllerTo.text} "),
            new Text("Total Fare : Rs.${controllerRate.text}"),
            new SizedBox(height: 20),
            new RaisedButton(
              child: new Text("Proceed To Pay"),
              onPressed: () {
                if (cashOrCard == 'card') {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new PaymentScreen(
                              to: controllerTo.text,
                              from: controllerFrom.text,
                              fare: controllerRate.text,
                              type: 'card',
                            )),
                  );
                } else if (cashOrCard == 'cash') {
                  Alert(
                    context: context,
                    type: AlertType.success,
                    title: "Fare Paid",
                    desc: "Rs." +
                        controllerRate.text +
                        " fare has been successfully paid by cash.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Proceed",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Printing.layoutPdf(
                            onLayout: buildPdf,
                          );
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new Home()));
                        },
                        width: 120,
                      )
                    ],
                  ).show();
                }
              },
            )
          ],
        ),
      ),
    );
    showDialog(context: context, child: alertDialog);
  }

  String _lastTextSelected;

  List<int> buildPdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    var now = new DateTime.now();
    String formattedDate = DateFormat('kk:mm d MMM').format(now);

    doc.addPage(
      pdf.Page(
        pageFormat: format,
        build: (pdf.Context context) {
          return pdf.ConstrainedBox(
            constraints: const pdf.BoxConstraints.expand(),
            child: pdf.FittedBox(
              child: pdf.Column(
                mainAxisAlignment: pdf.MainAxisAlignment.start,
                crossAxisAlignment: pdf.CrossAxisAlignment.start,
                children: <pdf.Widget>[
                  pdf.Column(children: <pdf.Widget>[
                    pdf.Text('POS Nepal'),
                    pdf.Text(formattedDate),
                  ]),
                  pdf.Text('~~~~~~~~~~~~~~'),
                  pdf.Text('From:' + controllerFrom.text),
                  pdf.Text('To:' + controllerTo.text),
                  pdf.Text('Fare:' + controllerRate.text),
                  pdf.Text('Payment Type: Cash'),
                ],
              ),
            ),
          );
        },
      ),
    );
    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 1,
            ),
            ListTile(
              title: Text("Transactions"),
              trailing: Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 25,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Transactions()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: new IconThemeData(color: Colors.black),
        title: Text(
          'POS Nepal',
          style: TextStyle(fontSize: 22.0, color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.38,
                child: FlareActor("animation/Bus.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "bus_animate"),
              ),
              new Container(
                color: Colors.white,
                padding: new EdgeInsets.symmetric(horizontal: 10),
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(bottom: 5.0),
                    ),
                    new TextField(
                      controller: controllerFrom,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        final String selected = await showSearch(
                            context: context, delegate: DataSearch());

                        setState(() {
                          controllerFrom.text = selStr;
                          if (controllerTo.text.isNotEmpty &&
                              controllerFrom.text.isNotEmpty) {
//                            getsomePoints();
                            final rnd = new Random();
                            controllerRate.text =
                                (15 + rnd.nextInt(35 - 15)).toString();
                          }
                        });
                      },
                      decoration: new InputDecoration(
                          hintText: "Origin",
                          labelText: "From",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0))),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 10.0),
                    ),
                    new TextField(
                      controller: controllerTo,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        final String selected = await showSearch(
                            context: context, delegate: DataSearch());

                        setState(() {
                          controllerTo.text = selStr;
                          if (controllerTo.text.isNotEmpty &&
                              controllerFrom.text.isNotEmpty) {
//                            getsomePoints();
                            final rnd = new Random();
                            controllerRate.text =
                                (15 + rnd.nextInt(35 - 15)).toString();
                          }
                        });
                      },
                      decoration: new InputDecoration(
                          hintText: "Destination",
                          labelText: "To",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0))),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 10.0),
                    ),
                    new TextField(
                      controller: controllerRate,
                      decoration: new InputDecoration(
                          hintText: "Fare",
                          labelText: "Fare Amount",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0))),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        NiceButton(
                          width: 130,
                          elevation: 8.0,
                          radius: 52.0,
                          text: "💸 Cash",
                          background: Colors.lightBlueAccent,
                          onPressed: () {
                            if (controllerTo.text.isNotEmpty &&
                                controllerFrom.text.isNotEmpty) {
                              Popupdata('cash');
                            }
                          },
                        ),
                        NiceButton(
                          width: 130,
                          elevation: 8.0,
                          radius: 52.0,
                          text: "💳 Card",
                          background: Colors.lightBlueAccent,
                          onPressed: () {
                            if (controllerTo.text.isNotEmpty &&
                                controllerFrom.text.isNotEmpty) {
                              Popupdata('card');
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
