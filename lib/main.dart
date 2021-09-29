import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:howmanypeopleareinspacerightnow/model/peoples_repo.dart';
import 'package:howmanypeopleareinspacerightnow/model/dailyphoto_repo.dart';
import 'package:howmanypeopleareinspacerightnow/model/news_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


String pageTitle = '#HowManyPeopleAreInSpaceRightNow?';
void main() {

  runApp(HomePage());
}


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }
  static const List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    NewsPage(),
    PhotosPage(),

  ];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex==0) {
        pageTitle='#HowManyPeopleInSpaceRightNow?';
      } else if (_selectedIndex==1) {
        pageTitle='#NewsFromSpace';
      } else if (_selectedIndex==2) {
        pageTitle='#PhotosFromSpace';
      }
    });
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
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: ExactAssetImage("images/bg.jpg"),
    fit: BoxFit.cover
    ),),
      child: Scaffold(
        backgroundColor: const Color(0xD173B),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0x14FDFCFC),
            title:  Text(
                pageTitle,
                style: TextStyle(color: Colors.white,fontSize: 20))
        ),
        body: Center (
            child: _widgetOptions.elementAt(_selectedIndex)

          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0x32FDFCFC),
            selectedItemColor: const Color(0xFFFFFFFF),
            unselectedItemColor: const Color(0xB5FDFDFD),
      unselectedFontSize: 10,
      selectedFontSize: 20,
      items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
          icon: Icon(Icons.airplane_ticket),
      label: 'How Many People Are in Space Right now?',

    ),
      BottomNavigationBarItem(
        icon: Icon(Icons.label_important),
        label: 'News',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.image),
        label: 'Photos',
      ),
      ],
    currentIndex: _selectedIndex,

      onTap: _onItemTapped,
    ),
    ),
    ),

    );

  }
}




class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);


  @override
  _MainPageState createState() => _MainPageState();
}



class _MainPageState extends State<MainPage> {
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
    return Container(
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

                      child: ListView.builder(
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
                    ),

                  ]);

            }
            else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Text("Loading...",
                style: TextStyle(fontSize:25,color: Colors.white));
          },
        ),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<NewsRepo>>  futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();

  }

  Future<List<NewsRepo>> fetchNews() async {
    final response = await http
        .get(Uri.parse('http://api.spaceflightnewsapi.net/v3/articles'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body.toString());
      return List<NewsRepo>.from(jsonDecode(response.body).map((e) => NewsRepo.fromJson(e)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load peoples');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<NewsRepo>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(

                    child: ListView.builder(

                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text( snapshot.data![index].title.toString(),
                              style: TextStyle(fontSize:20,color: Colors.white),
                              textAlign: TextAlign.center),
                              subtitle: Text(
                                snapshot.data![index].summary.toString() + '\n' + snapshot.data![index].publishedAt.toString(),
                                  style: TextStyle(fontSize:10,color: Colors.white),
                                  textAlign: TextAlign.center),
                            leading:  CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data![index].imageUrl.toString()),),
                            onTap: () => _launchURL(snapshot.data![index].url.toString())
                          );

                        }),
                  );


          }
          else if (snapshot.hasError) {
            return Text('${snapshot.error}',
                style: TextStyle(fontSize:20,color: Colors.white));
          }
          // By default, show a loading spinner.
          return const Text("Loading...",
              style: TextStyle(fontSize:25,color: Colors.white));
        },
      ),
    );
  }
}


void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class PhotosPage extends StatefulWidget {
  const PhotosPage({Key? key}) : super(key: key);

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  late Future<List<DailyPhoto>>  futurePhoto;

  @override
  void initState() {
    super.initState();
    futurePhoto = fetchDailyPhoto();

  }

  Future<List<DailyPhoto>> fetchDailyPhoto() async {
    final response = await http
        .get(Uri.parse('https://api.nasa.gov/planetary/apod?api_key=0GSLqn8x8fOhlf16nQ9WO2p93qfIyfRpgGDKYzp4&count=1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body.toString());
      return List<DailyPhoto>.from(jsonDecode(response.body).map((e) => DailyPhoto.fromJson(e)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load peoples');
    }
  }


  @override
  Widget build(BuildContext context) {
    var titleStyles =  TextStyle(fontSize:25,color: Colors.white);
    var subtitle =  TextStyle(fontSize:15,color: Colors.white);
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: FutureBuilder<List<DailyPhoto>>(
        future: futurePhoto,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(1),
              child: Column(


                  children: [

              Text(snapshot.data![0].title.toString(),
              style: titleStyles,),

                    Text('\n Date:' + snapshot.data![0].date.toString(),
                    style: subtitle),



          FadeInImage.assetNetwork(
            placeholder: 'images/loading.gif',
           image:snapshot.data![0].url,
          ),



          Text(snapshot.data![0].explanation.toString(),
          style: subtitle,textAlign: TextAlign.center,),


          ] ));



          }
          else if (snapshot.hasError) {
            return Text('${snapshot.error}',
                style: TextStyle(fontSize:20,color: Colors.white));
          }
          // By default, show a loading spinner.
          return const Text("Loading...",
              style: TextStyle(fontSize:25,color: Colors.white));
        },
      ),
    );
  }
}

