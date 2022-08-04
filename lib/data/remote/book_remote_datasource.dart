// import 'package:fl_cicd/config/config.dart';
// import 'package:fl_cicd/data/remote/book_remote_datasource_interface.dart';
// import 'package:fl_cicd/service/api_service.dart';
// import 'package:fl_cicd/usecase/model/book.dart';
// import 'package:http/http.dart';

// class BookRemoteDatasourceImpl implements BookRemoteDatasource {
//   final ApiService apiService;

//   BookRemoteDatasourceImpl(this.apiService);

//   @override
//   Future<List<Book>> getHome() async {
//     final response = await apiService.get(url: Urls.home);

//     if(response.statusCode == 200) {
//       return
//     }
//   }
// }

// T responseHandler<T>({
//   required Response response,
//   required Function(Map<String, dynamic> data) serielizer,
// }) {
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     final resJson = json.decode(response.body);

//     if (resJson["success"] == true) {
//       return serielizer(resJson) as T;
//     } else {
//       throw ServerFailure(resJson["error"]["message"] ?? "Server Failure");
//     }
//   } else {
//     Log.error(response.body);
//     throw ServerFailure(
//       json.decode(response.body)["message"] ?? "Server Failure",
//     );
//   }
// }