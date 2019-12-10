import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class questionsList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return questions();
  }



}

class questions extends State<questionsList>{
  TextEditingController name = TextEditingController();
  TextEditingController problems = TextEditingController();
  final appTitle = 'Solar';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    name.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    name.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${name.text}");
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    TextStyle style = Theme
        .of(context)
        .textTheme
        .title;
    return Scaffold(
      appBar: AppBar(
          title:Text(appTitle)),

      body: Builder(builder: (context) =>
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                StreamBuilder(
                  stream: Firestore.instance.collection('data').snapshots(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData) return const Text("Loading...");
                        return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context,index)=> ListTile(
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      snapshot.data.documents[0]["age"],
                                    ),
                                  )
                                ],
                              ),
                            ));
                  },
                ),



                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                      }
                      return showDialog(context: context,
                        builder: (context){
                          return AlertDialog(
                            content: Text(name.text),
                          );
                        },
                      );
                    },
                    child: Text('Submit'),

                  ),
                ),

              ],

            ),
          ),
      ),
    );
  }

}