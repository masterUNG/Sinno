import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {

  String _urlImage = 'https://pea23.com/assets/img/logo%20app.png';

  Future<Null> launchURL() async {
    const url =
        'https://www.youtube.com/watch?v=mtIKFc54fUk&list=PLHk7DPiGKGNAYSLQY3GJmE12FusvR75RK';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ช่วยเหลือ'),
      ),
        body: Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('คู่มือ'),
                Chip(
                  padding: EdgeInsets.all(0),
                  label: Text(' xx รายการ'),
                )
              ],
            ),
          ),
          Expanded(
              child: ResponsiveGridList(
            desiredItemWidth: 150,
            minSpacing: 10,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: launchURL,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        imageUrl: _urlImage,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ทดสอบ',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'ทดสอบ',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ],
          ))
        ],
      ),
    ));
  }
}
