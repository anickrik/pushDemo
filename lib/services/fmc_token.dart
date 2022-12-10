
import 'package:firebase_messaging/firebase_messaging.dart';

class FMCTokenService {

Future<void> getToken() async{
final fcmToken = await FirebaseMessaging.instance.getToken().then((value) => print(value));
return fcmToken;

}

}