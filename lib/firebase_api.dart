import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  //create instance
  final _firebaseMessaging =FirebaseMessaging.instance;

  //create function to initialize notifications
  Future<void> initNotification() async{

    //req persmisssion
    await _firebaseMessaging.requestPermission();
    //fetch the FCM token for this device
    final fCMToken =await _firebaseMessaging.getToken();
    //print the token
    print('token $fCMToken');

  }
  //handle recieved messages

  //initialize foreground and background settings
}