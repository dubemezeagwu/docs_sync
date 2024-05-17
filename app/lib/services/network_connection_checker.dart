import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// final internetStatusProvider = StreamProvider<bool>((ref) async* {
//   final checker = NetworkConnectionChecker();
//   checker.initialize();
//   Map source = {InternetStatus.disconnected: false};
//   bool isConnected = false;

//   NetworkConnectionChecker().myStream.listen(
//     (event) {
//       source = event;
//       switch (source.keys.toList()[0]) {
//         case InternetStatus.connected:
//           isConnected = true;
//           print("Internet: Connected");
//           break;
//         case InternetStatus.disconnected:
//           isConnected = false;
//           print("Internet: Disconnected");
//           break;
//       }
//     },
//   );
//   yield checker.isConnected;
// });

class NetworkConnectionChecker {
  static final NetworkConnectionChecker _instance =
      NetworkConnectionChecker._internal();

  factory NetworkConnectionChecker() {
    return _instance;
  }

  NetworkConnectionChecker._internal();

  final _networkConnectivity = InternetConnection();
  bool isConnected = false;

  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialize() async {
    _networkConnectivity.onStatusChange.listen((event) {
      _checkStatus(event);
    });
  }

  void _checkStatus(InternetStatus result) async {
    try {
      final result = await InternetAddress.lookup("example.com");
      isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isConnected = false;
    }
    print("Bool: $isConnected");
    _controller.sink.add({result: isConnected});
  }

  void disposeStream() => _controller.close();
}

// class NetworkConnectivity {
//   NetworkConnectivity._();

//   static final _instance = NetworkConnectivity._();
//   static NetworkConnectivity get instance => _instance;
//   final _networkConnectivity = InternetConnectionChecker();
//   bool isConnected = false;

//   final _controller = StreamController.broadcast();
//   Stream get myStream => _controller.stream;

//   void initialise() async {
//     _networkConnectivity.onStatusChange.listen((event) {
//       _checkStatus(event);
//     });
//   }

//   void _checkStatus(InternetConnectionStatus result) async {
//     try {
//       final result = await InternetAddress.lookup("example.com");
//       isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       isConnected = false;
//     }
//     _controller.sink.add({result: isConnected});
//   }

//   void disposeStream() => _controller.close();
// }
