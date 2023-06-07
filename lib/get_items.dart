
import 'package:flutter/material.dart';

class GetItems {



  List<Widget> getPosts() {
    List<Widget> postLists = [];
    for(int i=0; i<100; i++) {
      postLists.add(
        Container(
          padding: EdgeInsets.only(top: 40.0),
          child: Text(' Hello number is ${i}'),
        ),
      );
    }
    return postLists;
  }


}



