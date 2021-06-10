import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/pages/home_page.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:flutter/services.dart';
import 'package:psinsx/utility/sqlite_helper.dart';

class InsxEdit extends StatefulWidget {
  final InsxModel2 insxModel2;
  final bool fromMap;
  InsxEdit({Key key, this.insxModel2, this.fromMap}) : super(key: key);

  @override
  _InsxEditState createState() => _InsxEditState();
}

class _InsxEditState extends State<InsxEdit> {
  InsxModel2 insxModel2;
  File file;
  String urlImage;
  Location location = Location();
  double lat, lng;
  bool fromMap;

  @override
  void initState() {
    insxModel2 = widget.insxModel2;
    fromMap = widget.fromMap;
    findLatLng();

    // location.onLocationChanged.listen((event) {
    //   setState(() {
    //     lat = event.latitude;
    //     lng = event.longitude;
    //     //print('lat=== $lat, lng == $lng');
    //   });
    // });
  }

  Future<Null> findLatLng() async {
    Position position = await findPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100,
          title: Center(
            child: Text('แก้ไขข้อมูล'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            nameCus(),
            ca(),
            peaNo(),
            writeId(),
            address(),
            showLocation(),
            SizedBox(height: 30),
            groupImage(),
            SizedBox(height: 20),
          
          ],
        ),
      ),
    );
  }

  Widget showLocation() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                'พิกัดผู้ใช้ไฟ:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 14),
            child: Row(
              children: [
                Text(
                  '${insxModel2.lat}, ${insxModel2.lng}',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
                IconButton(icon: Icon(Icons.map), onPressed: () {})
              ],
            ),
          ),
        ],
      );

  Widget nameCus() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                'ชื่อ-สกุล:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                '${insxModel2.cus_name}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      );

  Widget ca() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'CA:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.ca}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget peaNo() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'PEA:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${insxModel2.pea_no}',
                  style: TextStyle(fontSize: 14),
                ),
                IconButton(
                  icon: Icon(Icons.copy_outlined),
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: "GIS ${insxModel2.pea_no}"));
                    print(insxModel2.pea_no);
                  },
                )
              ],
            ),
          ),
        ],
      );

  Widget writeId() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'สายจดหน่วย:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.write_id}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget address() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'ที่อยู่:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              child: Text(
                '${insxModel2.address}',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      );

  Widget groupImage() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 30,
            ),
            onPressed: () => chooseCamera(ImageSource.camera),
          ),
          Container(
            width: 160,
            height: 160,
            child: file == null
                ? Image.asset(
                    'assets/images/meter.png',
                    fit: BoxFit.cover,
                  )
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(
              Icons.no_photography,
              size: 30,
            ),
            onPressed: () => confirmDialog(),
            //editDataInsx(insxModel2),
          ),
        ],
      );

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คุณแน่ใจหรือว่า จะส่งมอบงานโดยไม่ถ่ายภาพมิเตอร์',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'หากพิกัดไม่เกิน 300 เมตร ไม่ต้องถ่ายภาพ กด แน่ใจ',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ไม่แน่ใจ',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      editDataInsx(insxModel2);
                    },
                    child: Text(
                      'แน่ใจ',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> chooseCamera(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        file = File(object.path);
        uploadImage();
      });
    } catch (e) {}
  }

  Future<Null> uploadImage() async {
    String apiSaveFile = '${MyConstant().domain}/apipsinsx/saveFile.php';
    String fileName = 'insx${Random().nextInt(1000000)}${insxModel2.ca}.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: fileName);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveFile, data: data).then((value) {
        urlImage = '${MyConstant().domain}/apipsinsx/upload/$fileName';
        print('=== usrlImage == $urlImage');
        editDataInsx(insxModel2);
      });
    } catch (e) {}
  }

  Future<Null> editDataInsx(InsxModel2 insxModel2) async {
    print('####>>>>>> ${insxModel2.id}');

    await SQLiteHelper()
        .editValueWhereId(int.parse(insxModel2.id))
        .then((value) => Navigator.pop(context));
  }


}
