import 'package:firebase_ml_text_recognition/widget/text_recognition_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Text Recognition';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isUploaded = false;
  @override
  void initState() {
    super.initState();

    upload();
  }

  Future upload() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Upload document to firestore
    final refUser = FirebaseFirestore.instance.collection('user').doc();
    await refUser.set({'username' : 'Javed'});

    // Upload file to firebase storage
    final response = await http.get('https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png');
    final imageBytes = response.bodyBytes;

    final refImage = FirebaseStorage().ref().child('images/example.png');
    final uploadTask = refImage.putData(imageBytes);
    await uploadTask.onComplete;

    setState((){
      isUploaded = true;
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 25),
              TextRecognitionWidget(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      );
}
