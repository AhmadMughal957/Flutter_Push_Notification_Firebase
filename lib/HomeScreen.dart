import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'Notification_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(onPressed: (){

          // send notification from one device to another
          notificationServices.getDeviceToken().then((value)async{

            var data = {
              'to' : value.toString(),
              'notification' : {
                'title' : 'Asif' ,
                'body' : 'Subscribe to my channel' ,
              },
              'android': {
                'notification': {
                  'notification_count': 23,
                },
              },
              'data' : {
                'foo' : 'bar' ,
              }
            };

            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: jsonEncode(data) ,
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization' : 'key=AAAAp9pXDFM:APA91bGhBeMCUABE2PXjl9UqodAZ2WdV_UI6PoiwdCzYaT8KeZmBKZszc01CD1GgN0OAJ1w3sNw9IVISyKhrrxQLASHizenGJUr2hjzoPjbjFu0HAx1CTk0l8Ut95ZENAQyRKm6hrltV'
                }
            ).then((value){

            }).onError((error, stackTrace){
              print(error);
            });
          });
        },
            child: Text('Send Notifications')),
      ),
    );
  }
}