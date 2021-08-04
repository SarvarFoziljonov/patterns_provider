
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:patterns_provider/models/post_model.dart';
import 'package:patterns_provider/pages/creat_page.dart';
import 'package:patterns_provider/pages/update_page.dart';

import '../http_request.dart';

class HomeViewModel extends ChangeNotifier {


  List <Post> items = [];
  bool isLoading = false;

  Future apiPostList () async {
    isLoading = true;
    notifyListeners();
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    if (response != null ) {
      items = Network.parsePostList(response);
    } else {
      print ("No info");
    }
    isLoading = false;
    notifyListeners();
  }
  Future <bool> apiPostDelete(Post post) async {
    isLoading = true;
    notifyListeners();
    var response = await Network.DEL(Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    isLoading = false;
    notifyListeners();

    return response != null;
  }



  Future <void> apiCreatePost(BuildContext context) async{
    String result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatPage()));
    if (items != null) items.add(Network.parsePost(result));
    notifyListeners();
  }

  Future <void> apiUpdatePost(BuildContext context, Post post) async{
    String result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdatePage(post: post,)));
    if (result != null) {
      Post post2 = Network.parsePost(result);
      items[items.indexWhere((element) => element.id == post2.id)] = post2;

    }
    notifyListeners();
  }




}