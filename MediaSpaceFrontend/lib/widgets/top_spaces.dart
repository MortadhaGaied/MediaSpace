import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopSpaces extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Top Spaces',style:TextStyle(fontSize: 22.0,fontWeight:FontWeight.bold,letterSpacing: 1.5 )),
              GestureDetector(
                onTap: ()=>print('see all'),
                child: Text('See All',style:TextStyle(color:Colors.lightBlue,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0)),
              )
            ],),
        )
      ],
    );
  }
}
