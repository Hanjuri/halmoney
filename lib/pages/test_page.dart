import 'package:flutter/material.dart';
import 'package:huggingface_dart/huggingface_dart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class TestPage extends StatefulWidget {
  TestPage({super.key});

  @override
  _TestPage createState() => _TestPage();
}

class _TestPage extends State<TestPage> {

  @override
  void initState(){
    super.initState();
    NERTest();
  }

  Future<void> NERTest() async{
    HfInference hfInference = HfInference('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');

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.blue[800],
      ),
    );
  }
}