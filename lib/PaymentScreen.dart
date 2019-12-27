import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:pos_nepal/Transactions.dart';
import 'package:pos_nepal/main.dart';
import 'package:printing/printing.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  String to;
  String from;
  String fare;
  String type;

  PaymentScreen({this.to, this.from, this.fare, this.type});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
                children: <pdf.Widget>[
                  pdf.Center(child: new pdf.Text('POS Nepal')),
                  pdf.Text(formattedDate),
                  pdf.Text('~~~~~~~~~~~~~~'),
                  pdf.Text('From:' + widget.from),
                  pdf.Text('To:' + widget.to),
                  pdf.Text('Fare:' + widget.fare),
                  pdf.Text('Payment Type:' + widget.type),
                ],
              ),
            ),
          );
        },
      ),
    );
    return doc.save();
  }

  void writeToJson() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("jsons/transactions.json");
    var jsonResult = json.decode(data);
    print(jsonResult.length);
    jsonResult.add({
      'data': "24-12-2019",
      "time": "08:10",
      "route": "22",
      "bus": "11",
      "from": "Kamalpokhari",
      "to": "RNAC",
      "fare": "15",
      "type": "card",
      "remarks": "manually paid"
    });
    var contents = json.encode(jsonResult);

//    getApplicationDocumentsDirectory().then((Directory directory) async {
//      var dir = directory;
//      var jsonFile = new File(dir.path + "/jsons/transactions.json");
//      jsonFile.writeAsStringSync(contents);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Transactions"),
                trailing: Icon(Icons.arrow_forward),
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
        backgroundColor: Colors.white,
        body: new ListView(children: <Widget>[
          GestureDetector(
            child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(children: <Widget>[
                  Container(
                    child: Center(
                      child: FlareActor("animation/nfc_search.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: "record"),
                    ),
                    height: MediaQuery.of(context).size.height * 0.8,
                  ),
                ])),
            onTap: () {
//              writeToJson();

              Alert(
                context: context,
                type: AlertType.success,
                title: "Fare Paid",
                desc: "Rs." +
                    widget.fare +
                    " fare has been successfully paid by card.",
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
            },
          )
        ]));
  }
}
