import 'dart:async';
import 'dart:convert';

import 'package:docs_sync/domain/app_domain.dart';
import 'package:docs_sync/core/app_core.dart';
import 'package:docs_sync/repository/app_repository.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));


class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  Future<NetworkResponse<Document>> createDocument(String token) async {
    NetworkResponse<Document> data = NetworkResponse(
        status: false, data: null, errorMessage: "Unexpected Error occurred");

    try {
      var response = await _client.post(
        Uri.parse("$host/api/v1/docs/create"),
        body: jsonEncode({
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        }),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );

      switch (response.statusCode) {
        case 201:
          final body = jsonDecode(response.body);
          final documentJson = body["data"]["document"];
          final document = Document.fromJson(documentJson);
          data = NetworkResponse(data: document, status: true);
      }
    } catch (e) {
      data = NetworkResponse(
          status: false, data: null, errorMessage: e.toString());
      throw (e.toString());
    }
    return data;
  }

  Future<NetworkResponse<List<Document>>> getUserDocuments(String token) async {
    NetworkResponse<List<Document>> data = NetworkResponse(
        status: false, data: null, errorMessage: "Unexpected Error occurred");

    try {
      var response = await _client.get(
        Uri.parse("$host/api/v1/docs/me"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("The connection has timed out!");
      });

      switch (response.statusCode) {
        case 200:
          final body = jsonDecode(response.body);
          final int length = body["results"];
          final documentJson = body["data"]["document"];
          List<Document> documents = [];
          for (int i = 0; i < length; i++) {
            documents.add(Document.fromJson(documentJson[i]));
          }
          data = NetworkResponse(data: documents, status: true);
      }
    } catch (e) {
      data = NetworkResponse(
          status: false, data: null, errorMessage: e.toString());
      throw (e.toString());
    }
    return data;
  }

  void updateDocumentTitle(
      {required String token,
      required String id,
      required String title}) async {
    NetworkResponse<Document> data = NetworkResponse(
        status: false, data: null, errorMessage: "Unexpected Error occurred");

    try {
      var response = await _client.patch(
        Uri.parse("$host/api/v1/docs/updateTitle"),
        body: jsonEncode({
          "title": title,
          "id": id,
        }),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );

      switch (response.statusCode) {
        case 200:
          final body = jsonDecode(response.body);
          final documentJson = body["data"]["document"];
          final document = Document.fromJson(documentJson);
          data = NetworkResponse(data: document, status: true);
      }
    } catch (e) {
      data = NetworkResponse(
          status: false, data: null, errorMessage: e.toString());
      throw (e.toString());
    }
  }

  Future<NetworkResponse<Document>> getDocumentById(
      String token, String id) async {
    NetworkResponse<Document> data = NetworkResponse(
        status: false, data: null, errorMessage: "Unexpected Error occurred");

    try {
      var response = await _client.get(
        Uri.parse("$host/api/v1/docs/$id"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );

      switch (response.statusCode) {
        case 200:
          final body = jsonDecode(response.body);
          final documentJson = body["data"]["document"];
          final document = Document.fromJson(documentJson);
          data = NetworkResponse(data: document, status: true);
      }
    } catch (e) {
      data = NetworkResponse(
          status: false, data: null, errorMessage: e.toString());
      throw (e.toString());
    }
    return data;
  }
}
