class NetworkResponse<T> {
  final String? errorMessage;
  final bool status;
  final T? data;

  NetworkResponse({this.errorMessage, this.data, required this.status});

  factory NetworkResponse.fromJson(Map<String, dynamic> json) {
    return NetworkResponse(
      errorMessage: json["message"] ?? "Data fetched successfully!",
      status: false,
    );
  }
}
