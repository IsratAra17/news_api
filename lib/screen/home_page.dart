import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
  String sortBy="publishedAt";

  int pageNo=1;

  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);
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
              Container(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: (){
                      if(pageNo>1){
                        setState(() {
                          pageNo-=1;
                        });
                      }
                    }, child:Text("Prev")),
                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            setState(() {
                              pageNo=index+1;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            color:   pageNo==index+1? Colors.red :Colors.blue,
                            padding: EdgeInsets.all(12),
                            child: Text("${index+1}",style: TextStyle(color: Colors.white),),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(onPressed: (){
                      if(pageNo<5){
                        setState(() {
                          pageNo+=1;
                        });
                      }
                    }, child:Text("Next")),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: DropdownButton(
                  value: sortBy,
                  items: [
                    DropdownMenuItem(child: Text("publishedAt"),value: "publishedAt"),
                    DropdownMenuItem(child: Text("popularity"),value:"popularity" ,),
                    DropdownMenuItem(child: Text("relevancy"),value: "relevancy",),


                  ],
                  onChanged: (value){
                    setState(() {
                      sortBy=value!;
                    });
                  },
                ),
              ),
              FutureBuilder<NewsModel>(
                future: newsProvider.getNewsData(pageNo,sortBy),
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
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewsDetails(
                            articles: snapshot.data!.articles![index],
                          )));
                        },
                        child: Container(
                          color: Colors.white,
                          height: 130,
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                color: Colors.blueGrey,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(14),
                                margin: EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          "${snapshot.data!.articles![index].urlToImage}",
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.network(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s"),
                                        ),
                                        //Image(image: NetworkImage("${snapshot.data!.articles![index].urlToImage}",))
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        flex: 10,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${snapshot.data!.articles![index].title}",
                                              maxLines: 2,
                                            ),
                                            Text(
                                                "${snapshot.data!.articles![index].publishedAt}")
                                          ],
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
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
