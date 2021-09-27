import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howmanypeopleareimspace/Repo.dart';

import 'package:http/http.dart' as http;


void main() {
  runApp(HomePage());
}


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late Future<Repo> futurePeoples;
  @override
  void initState() {
    super.initState();
    futurePeoples = fetchPeoples();

  }



  Future<Repo> fetchPeoples() async {
    final response = await http
        .get(Uri.parse('http://api.open-notify.org/astros.json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Repo.fromJson(jsonDecode(response.body));


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load peoples');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'people',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green
      ),
    home: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: ExactAssetImage("images/bg.jpg"),
    fit: BoxFit.cover
    ),),
      child: Scaffold(
        backgroundColor: const Color(0xD173B),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF132255),
            title: Text(
                '#HowManyPeopleAreInSpaceRightNow?'
            )),
        body: Center  (

            child: FutureBuilder<Repo>(
              future: futurePeoples,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                 return Column(
                      children: [

                      Container(
                        padding: EdgeInsets.all(100),
                        child: Text(snapshot.data!.number.toString(),
                          style: TextStyle(fontSize:100,color: Colors.white)),
                      ),
                       
                Expanded(
                  
                child:
                 ListView.builder(

                      scrollDirection: Axis.vertical,
                        shrinkWrap: true,

                  itemCount: snapshot.data!.people.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          subtitle: Text(
                            snapshot.data!.people[index].name +
                                ' (' +
                                snapshot.data!.people[index].craft +  ')',
                            style: TextStyle(fontSize:20,color: Colors.white),
                            textAlign: TextAlign.center,),
                        );
                      }),
                  )]);

                }
                   else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return Text("Yüklenemedi.",
                  style: TextStyle(fontSize:25,color: Colors.white));
              },
            ))
        ),
      ));
      }
}