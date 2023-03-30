import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_api/model/news_model.dart';

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {

  String url="https://newsapi.org/v2/everything?q=bitcoin&sortBy=relevency&pageSize=5andpage=1&apiKey=0ca84d47b3184231ad3ab2c9c2cf033b";

  //create an obj
  NewsModel ?newsModel;


  fetchHomeData()async{
    var response=await http.get(Uri.parse(url));//api hit korlam "response" a raklam
     var data=jsonDecode((response.body));
     print("our response is ${data}");
//model class a data pass kore dibo
     newsModel=NewsModel.fromJson(data);
     setState(() {

     });
  }
  @override
  void initState() {
    // TODO: implement initState

    fetchHomeData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
