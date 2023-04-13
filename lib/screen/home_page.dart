import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_api/model/news_model.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {

  String url="https://newsapi.org/v2/everything?q=bitcoin&sortBy=relevency&pageSize=5andpage=1&apiKey=0ca84d47b3184231ad3ab2c9c2cf033b";

  //create an obj
  NewsModel ?newsModel;



 Future<NewsModel>fetchHomeData()async{
    var response=await http.get(Uri.parse(url));//api hit korlam "response" a raklam
     var data=jsonDecode((response.body));
     print("our response is ${data}");
//model class a data pass kore dibo
     newsModel=NewsModel.fromJson(data);
     return newsModel!;
     // setState(() {
     //
     // });
  }
  @override
  void initState() {
    // TODO: implement initState

    fetchHomeData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("news App"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Container(
          padding: EdgeInsets.all(12),
          width: double.infinity,
          child: ListView(
            children: [
              FutureBuilder(
                future: fetchHomeData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Something is wrong");
                  } else if (snapshot.data == null) {
                    return Text("snapshot data are null");
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.white,
                        height: 130,
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              height: 60,width: 60,
                              color: Colors.blueGrey,
                            ),
                            Positioned(
                              right: 0,bottom: 0,
                              child: Container(
                                height: 50,width: 50,
                                color: Colors.blueGrey,
                              ),),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(14),
                              margin: EdgeInsets.all(14),
                              child: Row(

                                children: [
                                  Expanded(
                                    flex:3,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child:CachedNetworkImage(
                                        imageUrl: "${snapshot.data!.articles![index].urlToImage}",
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s"),
                                      ),
                                      //Image(image: NetworkImage("${snapshot.data!.articles![index].urlToImage}",))
                                    ),
                                  ),
                                  SizedBox(width: 8,),
                                  Expanded(
                                      flex: 10,
                                      child:Column(
                                        children: [
                                          Text(
                                            "${snapshot.data!.articles![index].title}",maxLines: 2,),

                                          Text(
                                              "${snapshot.data!.articles![index].publishedAt}")
                                        ],
                                      )
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          )),
    );
  }
}
