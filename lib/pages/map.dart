import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/models/insx_sqlite_model.dart';
import 'package:psinsx/pages/insx_edit.dart';
import 'package:psinsx/pages/insx_page.dart';
import 'package:psinsx/utility/custom_dialog.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:psinsx/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  double lat, lng;
  LatLng startMapLatLng;
  List<InsxModel2> insxModel2s = [];
  bool statusSQLite;

  @override
  void initState() {
    super.initState();
    checkSQLit();

    //checkSQLit();
  }

  bool checkSQLite2() {
    print('########### statusSQLite ######### $statusSQLite');
    return statusSQLite;
  }

  Future<Null> checkSQLit() async {
    List<InsxSQLiteModel> insxSQLiteModels = await SQLiteHelper().readSQLite();
    if (insxSQLiteModels.length == 0) {
      // read from api
      statusSQLite = true;
      findLatLng();
    } else {
      statusSQLite = false;
      findLatLng();
    }
  }

  Future<Null> readSQLiteData() async {
    print('>>>>>>>>>>>>>>>>>> reade word ############');
    insxModel2s.clear();
    insxModelForEdits.clear();

    await SQLiteHelper().readSQLite().then((value) {
      List<InsxSQLiteModel> insxSQLiteModels = value;

      for (var model2 in insxSQLiteModels) {
        InsxModel2 insxModel2 = InsxModel2(
          id: model2.id.toString(),
          ca: model2.ca,
          pea_no: model2.pea_no,
          cus_name: model2.cus_name,
          cus_id: model2.cus_id,
          invoice_no: model2.invoice_no,
          bill_date: model2.bill_date,
          bp_no: model2.bp_no,
          write_id: model2.write_id,
          portion: model2.portion,
          ptc_no: model2.ptc_no,
          address: model2.address,
          new_period_date: model2.new_period_date,
          write_date: model2.write_date,
          lat: model2.lat,
          lng: model2.lng,
          invoice_status: model2.invoice_status,
          noti_date: model2.noti_date,
          update_date: model2.update_date,
          timestamp: model2.timestamp,
          workImage: model2.workImage,
          worker_code: model2.worker_code,
          worker_name: model2.worker_name,
        );

        if (insxModel2.invoice_status != MyConstant.valueInvoiceStatus) {
          setState(() {
            insxModel2s.add(insxModel2);
            myAllMarker();
          });
        } else {
          insxModelForEdits.add(insxModel2);
        }
      }
    });
  }

  List<InsxModel2> insxModelForEdits = [];

  Future<Null> myReadAPI() async {
    print('>>>>>>>>>>>>>>>>>>My Read API Workd');

    insxModel2s.clear();
    insxModelForEdits.clear();
    await SQLiteHelper().deleteAllData();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');

    String url =
        'https://pea23.com/apipsinsx/getInsxWhereUser.php?isAdd=true&worker_name=$workername';

    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          InsxModel2 model2 = InsxModel2.fromMap(item);
          insxModel2s.add(model2);

          // InsxSQLiteModel insxSQLiteModel = InsxSQLiteModel.fromMap(item);
          InsxSQLiteModel insxSQLiteModel = InsxSQLiteModel(
            ca: model2.ca,
            pea_no: model2.pea_no,
            cus_name: model2.cus_name,
            cus_id: model2.cus_id,
            invoice_no: model2.invoice_no,
            bill_date: model2.bill_date,
            bp_no: model2.bp_no,
            write_id: model2.write_id,
            portion: model2.portion,
            ptc_no: model2.ptc_no,
            address: model2.address,
            new_period_date: model2.new_period_date,
            write_date: model2.write_date,
            lat: model2.lat,
            lng: model2.lng,
            invoice_status: model2.invoice_status,
            noti_date: model2.noti_date,
            update_date: model2.update_date,
            timestamp: model2.timestamp,
            workImage: model2.workImage,
            worker_code: model2.worker_code,
            worker_name: model2.worker_name,
          );

          await SQLiteHelper().insertValueToSQLite(insxSQLiteModel);
        }
        setState(() {
          myAllMarker();
        });
      } else {
        setState(() {});
      }
    });
  }

  Set<Marker> myAllMarker() {
    List<Marker> markers = [];
    List<double> hues = [80.0, 60.0, 150.0, 20.0];

    Marker userMarker = Marker(
        markerId: MarkerId('idUser'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: 'คุณอยู่ที่นี่'),
        icon: BitmapDescriptor.defaultMarkerWithHue(300));

    //markers.add(userMarker);

    for (var item in insxModel2s) {
      Marker marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
            calculageHues(item.noti_date)),
        markerId: MarkerId('id${item.id}'),
        position: LatLng(double.parse(item.lat), double.parse(item.lng)),
        infoWindow: InfoWindow(
          title: item.cus_name,
          snippet: '${item.write_id} PEA:${item.pea_no}',
          onTap: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => InsxEdit(
                insxModel2: item,
                fromMap: true,
              ),
            );
            Navigator.push(context, route).then(
              (value) {
                print('#######   Back Form insx_edit ##########');
                readSQLiteData();
                // if (checkSQLite2()) {
                //   myReadAPI();
                // } else {
                //   readSQLiteData();
                // }
              },
            );
          },
        ),
      );
      markers.add(marker);
    }
    return markers.toSet();
  }

  double calculageHues(String notidate) {
    List<double> hues = [80.0, 60.0, 200.0, 20.0];
    List<String> strings = notidate.split(" ");
    List<String> dateTimeInts = strings[0].split('-');
    DateTime notiDateTime = DateTime(
      int.parse(dateTimeInts[0]),
      int.parse(dateTimeInts[1]),
      int.parse(dateTimeInts[2]),
    );

    DateTime currentDateTime = DateTime.now();
    int diferDate = currentDateTime.difference(notiDateTime).inDays;
    double result = hues[0];

    if (diferDate >= 7) {
      result = hues[3];
    } else if (diferDate >= 4) {
      result = hues[2];
    } else if (diferDate >= 2) {
      result = hues[1];
    }
    return result;
  }

  Future<Null> findLatLng() async {
    bool enableServiceLocation = await Geolocator.isLocationServiceEnabled();

    if (enableServiceLocation) {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          lat = 16.753188;
          lng = 101.203616;
          startMapLatLng = LatLng(16.753188, 101.203616);
          if (checkSQLite2()) {
            myReadAPI();
          } else {
            readSQLiteData();
          }
        });
      } else if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission().then((value) async {
          if (value == LocationPermission.deniedForever) {
            setState(() {
              lat = 16.753188;
              lng = 101.203616;
              startMapLatLng = LatLng(16.753188, 101.203616);
              if (checkSQLite2()) {
                myReadAPI();
              } else {
                readSQLiteData();
              }
            });
          } else {
            // find Lat, lng
            var position = await findPosition();
            setState(() {
              lat = position.latitude;
              lng = position.longitude;
              startMapLatLng = LatLng(lat, lng);
              if (checkSQLite2()) {
                myReadAPI();
              } else {
                readSQLiteData();
              }
            });
          }
        });
      } else {
        // find Lat, lng
        var position = await findPosition();
        setState(() {
          lat = position.latitude;
          lng = position.longitude;
          startMapLatLng = LatLng(lat, lng);
          if (checkSQLite2()) {
            myReadAPI();
          } else {
            readSQLiteData();
          }
        });
      }
    } else {
      normalDialog(context, 'โปรดให้สิทธิแผนที่ก่อน');
      setState(() {
        lat = 16.753188;
        lng = 101.203616;
        startMapLatLng = LatLng(16.753188, 101.203616);
        if (checkSQLite2()) {
          myReadAPI();
        } else {
          readSQLiteData();
        }
      });
    }
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lat == null ? MyStyle().showProgress() : buildGoogleMap(),
    );
  }

  Future<Null> editAndRefresh() async {
    if (insxModelForEdits.length != 0) {
      for (var item in insxModelForEdits) {
        CustomDialog().loadingDilog(context);
        editDataInsx2(item).then((value) {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: 'Edit Finish',
            gravity: ToastGravity.CENTER,
          );
        });
      }
    } else {
      normalDialog(context, 'No Data for Edit');
    }
  }

  Future<Null> editDataInsx2(InsxModel2 insxModel2) async {
    String url =
        'https://pea23.com/apipsinsx/editDataWhereInvoiceNo.php?isAdd=true&invoice_no=${insxModel2.invoice_no}';

    print('##### url edit ==>> $url');

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        myReadAPI();
      } else {
        normalDialog(context, 'ผิดพลาด กรุณาลองใหม่');
      }
    });
  }

  Widget pinGreen() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/insxPage')
          .then((value) => readSQLiteData()),
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pin_drop,
                size: 30,
                color: Colors.green,
              ),
              Text(
                '${insxModel2s.length}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          color: Colors.red[100]),
    );
  }

  Widget pinYellow() {
    return GestureDetector(
      // onTap: () => Navigator.pushNamed(context, '/insxPage')
      //     .then((value) => readSQLiteData()),
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pin_drop,
                size: 30,
                color: Colors.yellow,
              ),
              Text(
                '${insxModel2s.length}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          color: Colors.red[100]),
    );
  }

  Widget buildGoogleMap() {
    return Scaffold(
      body: Stack(
        children: [
          insxModel2s.length == 0 ? buildSecondMap() : buildMainMap(),
          Positioned(
            top: 8,
            left: 10,
            child: pinGreen(),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              CustomDialog().loadingDilog(context);
              myReadAPI().then((value) => Navigator.pop(context));
            },
            child: Icon(Icons.refresh),
          ),
          SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            onPressed: () {
              editAndRefresh();
            },
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined),
                Text('${insxModelForEdits.length}'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: new BottomAppBar(
        color: Colors.white,
        child: new Row(),
      ),
    );
  }

  Widget workDay() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InsxPage()));
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pin_drop_outlined,
                size: 40,
                color: Colors.red,
              ),
              Text(
                insxModel2s.length == 0 ? '?' : '${insxModel2s.length}',
                style: TextStyle(fontSize: 10, color: Colors.grey[900]),
              )
            ],
          ),
          color: Colors.red[100]),
    );
  }

  GoogleMap buildMainMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: startMapLatLng,
        zoom: 8,
      ),
      onMapCreated: (controller) {},
      markers: myAllMarker(),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }

  GoogleMap buildSecondMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: startMapLatLng,
        zoom: 16,
      ),
      onMapCreated: (controller) {},
      markers: myAllMarker(),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }
}
