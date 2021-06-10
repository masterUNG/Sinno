import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/insx_model.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:psinsx/widgets/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DmsxPage extends StatefulWidget {
  DmsxPage({Key key}) : super(key: key);

  @override
  _DmsxPageState createState() => _DmsxPageState();
}

class _DmsxPageState extends State<DmsxPage> {
  bool loadStatus = true; //โหลด
  bool status = true; //มีข้อมูล
  List<InsxModel> insxModels = List();

  @override
  void initState() {
    super.initState();
    readInsx();
  }

  Future<Null> readInsx() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');
    //print('workername === $workername');

    String url =
        'https://pea23.com/apipsinsx/getInsxWhereUser.php?isAdd=true&worker_name=$workername';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        print('value ====>>> $value');

        var result = json.decode(value.data);

        print('result ===>>> $result');

        for (var map in result) {
          InsxModel insxModel = InsxModel.fromJson(map);
          setState(() {
            insxModels.add(insxModel);
            print('map $map');
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text('จำนวน : ? รายการ'),
                trailing: Icon(Icons.map),
                onTap: null,
              ),
            ),
            loadStatus ? MyStyle().showProgress() : showContent(),
          ],
        ));
  }

  Widget showContent() {
    return status
        ? showListInsx()
        : Center(
            child: Text('No Data'),
          );
  }

  Widget showListInsx() => Text('มีข้อมูล');
}
