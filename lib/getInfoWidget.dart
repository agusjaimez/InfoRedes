import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class getInfoWidget extends StatefulWidget{
  @override
  getInfoWidgetState createState() => getInfoWidgetState();
}

class getInfoWidgetState extends State<getInfoWidget> {
  //GPS
  Position position;
  String latitude;
  String longitude;
  bool isLocationServiceEnabled;
  LocationPermission permission;
  final Telephony telephony = Telephony.instance;
  //Network
  NetworkType type;
  String tipo;
  bool isNetworkRoaming;
  List<SignalStrength> strenghts;
  String simOperatorName;
  String signalStrength;
  String textFromFile;
  int currentIndex=0;

  Future<void> _getLocation() async {
    isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (isLocationServiceEnabled==true){
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude= position.latitude.toString();
      longitude= position.longitude.toString();
      setState(() {
      });
    }else{
      permission = await Geolocator.requestPermission();
    }
  }

  Future<void> _getNetworkData() async{
    type = await telephony.dataNetworkType;
    tipo=type.toString();
    tipo=tipo.replaceAll("NetworkType.", "");
    isNetworkRoaming = await telephony.isNetworkRoaming;
    strenghts = await telephony.signalStrengths;
    signalStrength=strenghts.first.toString();
    signalStrength=signalStrength.replaceAll("SignalStrength.", "");
    simOperatorName = await telephony.simOperatorName;
    setState(() {
    });
  }

  //Pop-up window
  TextEditingController customController=TextEditingController();
  _createAlertDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Set the file name"),
        content: TextField(
          controller: customController,

        ),

        actions: [
          ElevatedButton(
              child: Text("Save"),
              onPressed: (){
                save(customController.text.toString());
                Navigator.of(context).pop();
              }
          )
        ],
      );
    });
  }

  //Get File
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final name= '2.txt';
    return File('$path/$name');
  }

//Write to the file
  Future<File> writeFile(String text) async {
    final file = await _localFile;
    // Write the file.
    return file.writeAsString('$text',mode: FileMode.append);
  }

  void save(text){
    String textToWrite= "$text:{\nGPS Data:{\nLatitude:$latitude,\nLongitude:$longitude\n}\nNetwork Data:{\nNetwork_Type:$tipo,\nNetworkRoaming:$isNetworkRoaming,\nServiceProvider:$simOperatorName,\nSignal_Strength:$signalStrength}\n}\n------------------------\n";
    writeFile(textToWrite);
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //GPS
            ElevatedButton(
              onPressed: _getLocation,
              child:Text('Get Location'),
            ),
            Text(
              'GPS Coordinates:',
            ),
            Text(
              'Latitude: ',
            ),
            Text(
              '$latitude',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Longitude: ',
            ),
            Text(
              '$longitude',
              style: Theme.of(context).textTheme.headline6,
            ),
            //MOBILE NETWORK
            ElevatedButton(
              onPressed: _getNetworkData,
              child:Text('Get Mobile Network Data'),
            ),
            Text(
              'Mobile Data Network properties:',
            ),
            Text(
              'Type: ',
            ),
            Text(
              '$tipo',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Roaming: ',
            ),
            Text(
              '$isNetworkRoaming',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Service Provider Name:',
            ),
            Text(
              '$simOperatorName',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Signal Strength: ',
            ),
            Text(
              '$signalStrength',
              style: Theme.of(context).textTheme.headline6,
            ),
            //WIFI NETWORK
            ElevatedButton(
              onPressed: () => _createAlertDialog(context),
              child:Text('Save'),
            ),
          ],

    );
  }
}