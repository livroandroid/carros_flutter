

import 'package:flutter/material.dart';

push(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return page;
  }));
}

pushReplacement(BuildContext context, Widget page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
    return page;
  }));
}

pop(BuildContext context) {
  Navigator.pop(context);
}