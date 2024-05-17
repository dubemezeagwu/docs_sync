import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final internetStatusProvider = StreamProvider<bool>((ref) async* {
  final checker = NetworkConnectionChecker();
  checker.initialize();
  yield* checker.myStream;
});

class NetworkConnectionChecker {
  static final NetworkConnectionChecker _instance =
      NetworkConnectionChecker._internal();

  factory NetworkConnectionChecker() {
    return _instance;
  }

  NetworkConnectionChecker._internal();

  final _networkConnectivity = InternetConnection();
  bool isConnected = false;

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get myStream => _controller.stream;

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
    _controller.sink.add(isConnected);
  }

  void disposeStream() => _controller.close();
}