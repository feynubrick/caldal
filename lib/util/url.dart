import 'dart:io';

String getLocalHostName() {
  return Platform.isAndroid ? '10.0.2.2' : 'localhost';
}
