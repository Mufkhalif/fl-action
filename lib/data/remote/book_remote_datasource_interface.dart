import 'package:fl_cicd/usecase/model/book.dart';

abstract class BookRemoteDatasource {
  Future<List<Book>> getHome();
}
