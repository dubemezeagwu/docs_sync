import 'dart:convert';

import 'package:docs_sync/core/constants/api_constants.dart';
import 'package:docs_sync/domain/app_domain.dart';
import 'package:docs_sync/domain/models/document_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  Future<NetworkResponse> createDocument(String token) async {
    NetworkResponse data = NetworkResponse(
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
          final documentJson = jsonEncode(body["data"]["document"]);
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
