import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  int _upCounter = 0;
  int _downCounter = 0;
  var _newdata;
  var myDatabase = Firestore.instance;

  void _putdata() {
    var myDatabase = Firestore.instance;
    myDatabase.collection('data').document("outsideData$_upCounter").setData(
      {
        "data": "Uploaded outsider data $_upCounter",
      },
    );
    _upCounter++;
  }

  @override
  Widget build(BuildContext context) {
    _putdata();
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebse Listview'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyList()),
              );
            },
            icon: Icon(Icons.multiline_chart),
          )
        ],
      ),
      // body: Center(
      //   child: Text(
      //       "Cloud Firestore contains this sentence:\nFetch Attemp: $_downCounter\nData: $_datafromfirestore"),
      // ),
      body: StreamBuilder(
        stream: myDatabase.collection('data').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Center(
              child: Text("\nCaught an error in the firebase thingie... :| "),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("\nHang On, We are building your app !"),
            );
          } else {
            var mydata = snapshot.data;
            print("hello ${mydata.documents[0]["age"]}");
            _newdata = mydata.documents[0]["age"];
            return Center(
              child: Text(
                  "Cloud Firestore contains this sentence:\nFetch Attempt: 1 \nData: $_newdata"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _downCounter++;
          });
        },
        child: Icon(Icons.cloud_download),
        tooltip: 'Download Data',
      ),
    );
  }
}

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListView Firestore"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("data").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
           print("Hello123 ${snapshot.data}");
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {

            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              if (!snapshot.hasData) return Text('No data finded!');
              print("Hello1233434 ${snapshot.data.documents[0]['name']}");
              return Card(
                child: SingleChildScrollView(
                  child: Column(
                      children:
                      snapshot.data.documents.map((document){
                        print("Gautam ${document['data']}");
                        return new Text(document['data']);
                      }).toList()
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}