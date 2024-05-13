import 'package:docs_sync/repository/app_repository.dart';

class SocketRepository {
  static final SocketRepository _instance = SocketRepository._internal();

  factory SocketRepository() {
    return _instance;
  }

  SocketRepository._internal();

  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void joinRoom(String documentId) {
    _socketClient.emit("join", documentId);
  }

  void autoSave(Map<String, dynamic> data) {
    _socketClient.emit("save", data);
  }

  void typing(Map<String, dynamic> data) {
    _socketClient.emit("typing", data);
  }

  void onChangedListener(Function(Map<String, dynamic>) func) {
    _socketClient.on("changes", (data) => func(data));
  }
}

