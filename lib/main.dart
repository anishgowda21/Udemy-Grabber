import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/basic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main()
{
  runApp(
      MaterialApp(
          home:HomePage()
      )
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data;
  List userData;

  Future getData() async{
    http.Response response = await http.get("https://anishgowda.vercel.app/udemy");
    data = json.decode(response.body);
    return data;
    }
  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Udemy Paid Course Grabber"),
          backgroundColor: Colors.purpleAccent,
        ),
        body: Container(
          child: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Center(
                  child: new Text("Loading",
                  style:TextStyle(
                    color: Colors.white
                  )),
                );
              }
              else
                {
                  print(snapshot.data);
                  return ListView.builder(
                      itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                      itemBuilder: (BuildContext context,int index){
                        return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.all(5.0),
                            child: new InkWell(
                              onTap: () => launch(snapshot.data[index]["link"]),
                              child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: <Widget>[
                                      Image(
                                        image: NetworkImage(snapshot.data[index]["image"]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text("${snapshot.data[index]["title"]}""\n\n\n""${snapshot.data[index]["description"]}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            )
                        );
                      }
                  );
                }
            }
          ),
        )
    );
  }
}

