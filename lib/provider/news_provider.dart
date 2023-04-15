import 'package:flutter/material.dart';
import 'package:news_api/http/custom_http.dart';

import 'package:provider/provider.dart';



import '../model/news_model.dart';

class NewsProvider with ChangeNotifier{

  NewsModel? newsModel;
  Future<NewsModel> getNewsData(int pageNo,String sortBy)async{
    newsModel=await CustomeHttpRequest.fetchHomeData(pageNo,sortBy);
    return newsModel!;
  }

}

