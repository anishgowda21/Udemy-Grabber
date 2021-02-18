import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List data;

  Future getCourses() async {
    http.Response response =
        await http.get("https://anishgowda.vercel.app/udemy");
    data = json.decode(response.body);
    return data;
  }

  AnimationController animationController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text("Udemy Course Grabber"),
          backgroundColor: Colors.grey[900],
        ),
        body: Container(
          child: FutureBuilder(
              future: getCourses(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: new CircularProgressIndicator(
                    valueColor: animationController.drive(
                        ColorTween(begin: Colors.blueAccent, end: Colors.red)),
                  ));
                } else {
                  return ListView.builder(
                      itemCount:
                          snapshot.data == null ? 0 : snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            color: Colors.grey[800],
                            margin: const EdgeInsets.all(08.0),
                            child: new InkWell(
                              onTap: () => launch(snapshot.data[index]["link"]),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Image(
                                        image: NetworkImage(
                                            snapshot.data[index]["image"]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "${snapshot.data[index]["title"]}",
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 5.0),
                                        child: Text(
                                          "${snapshot.data[index]["description"]}",
                                          style: GoogleFonts.raleway(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )),
                            ));
                      });
                }
              }),
        ));
  }
}
