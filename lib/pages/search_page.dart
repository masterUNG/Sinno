import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/data_location_model.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<DataLocationModel> dataLocationModels = [];
  List<DataLocationModel> filterDataLocationModels = List();

  String search;
  String nodata = 'กรุณากรอก ca ที่ต้องการค้นหา';

  @override
  void initState() {
    super.initState();
  }

  Future<Null> readAllData() async {
    if (dataLocationModels.length != 0) {
      dataLocationModels.clear();
    }
    String url =
        'https://pea23.com/apipsinsx/getAllDataLocationWhereCa.php?isAdd=true&ca=$search';

    var response = await Dio().get(url);

    print('response ===>>> $response');

    if (response.toString() == 'null') {
      setState(() {
        nodata = 'ไม่พบข้อมูฃ CA: $search';
      });
    } else {
      var result = json.decode(response.data);
      print('result ====>>> $result');
      for (var map in result) {
        DataLocationModel dataLocationModel = DataLocationModel.fromJson(map);
        print('name ====>>> ${dataLocationModel.ca}');
        setState(() {
          dataLocationModels.add(dataLocationModel);
        });
      }
    }
  }

  Future<Null> launchURL() async {
    var url = 'https://www.google.co.th/maps';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        searchText(),
        dataLocationModels.length == 0
            ? Center(
                child: Text(
                nodata,
                style: TextStyle(
                  fontSize: 14,
                ),
              ))
            : showListView(),
      ],
    ));
  }

  Widget searchText() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: TextField(
              decoration: InputDecoration(hintText: 'กรอก ca'),
              onChanged: (value) => search = value.trim(),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.search,
                size: 40,
              ),
              onPressed: () {
                if (search?.isEmpty ?? true) {
                  normalDialog(context, 'ห้ามมีช่องว่าง');
                } else {
                  readAllData();
                }
              }),
        ],
      ),
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
          itemCount: dataLocationModels.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                print('${dataLocationModels[index].ptcInsx}');

                String url = dataLocationModels[index].ptcInsx;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'ไม่พบ $url';
                }
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text(dataLocationModels[index].ca),
                  subtitle: Text(
                    dataLocationModels[index].cusName,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
