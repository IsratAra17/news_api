import 'package:flutter/cupertino.dart';
import 'package:news_api/model/news_model.dart';
import 'package:provider/provider.dart';

import '../http/custom_http.dart';
class NewsProvider with ChangeNotifier{
  NewsModel? newsModel;
  Future<NewsModel> getNewsData(int pageNo,String sortBy)async{
    newsModel=await CustomeHttpRequest.fetchHomeData(pageNo,sortBy);
    return newsModel!;
  }

}
