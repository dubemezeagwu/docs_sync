import 'dart:async';

import 'package:docs_sync/domain/app_domain.dart';
import 'package:docs_sync/repository/app_repository.dart';

final documentsNotifier =
    AutoDisposeAsyncNotifierProvider<DocumentViewModel, List<Document>?>(
        DocumentViewModel.new);

class DocumentViewModel extends AutoDisposeAsyncNotifier<List<Document>?> {
  @override
  Future<List<Document>?> build() async {
    state = const AsyncLoading();
    String? token = await ref.read(localStorageProvider).getToken();
    final docs = await ref
        .read(documentRepositoryProvider)
        .getUserDocuments(token ?? "");
    state = AsyncData(docs.data);
    return docs.data;
  }

  Future<Document> createDocument([bool? isPublic]) async {
    String? token = await ref.read(localStorageProvider).getToken();
    final doc = await ref
        .read(documentRepositoryProvider)
        .createDocument(token ?? "", isPublic ?? false);
    refresh();
    return doc.data!;
  }

  Future<Document> getDocumentById(String id) async {
    String? token = await ref.read(localStorageProvider).getToken();
    final doc = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(token ?? "", id);
    return doc.data!;
  }

  Future<void> deleteDocument(String id) async {
    String? token = await ref.read(localStorageProvider).getToken();
    await ref.read(documentRepositoryProvider).deleteDocument(token ?? "", id);
    refresh();
  }

  Future<void> updateDocumentTitle(
      {required String id, required String title}) async {
    String? token = await ref.read(localStorageProvider).getToken();
    ref
        .read(documentRepositoryProvider)
        .updateDocumentTitle(token: token ?? "", id: id, title: title);
    Future.delayed(const Duration(seconds: 1), () {
      refresh();
    });
  }

  Future<void> addCollaborators(
      {required String docId, required Map <String, dynamic> data}) async {
    String? token = await ref.read(localStorageProvider).getToken();
    ref
        .read(documentRepositoryProvider)
        .addCollaborator(token: token ?? "", docId: docId, collaborator: data);
    Future.delayed(const Duration(seconds: 1), () {
      refresh();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading(); // Initialize state as loading
    try {
      final documents = await build();
      state =
          AsyncValue.data(documents); // Update state with the result of build()
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current); // Handle any errors
    }
  }
}
