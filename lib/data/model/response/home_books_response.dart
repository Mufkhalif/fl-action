import 'package:fl_cicd/usecase/model/book.dart';

class HomeBooksResponse {
  HomeBooksResponse({
    required this.success,
    required this.data,
    required this.errors,
    required this.paging,
  });

  final bool success;
  final List<Datum> data;
  final dynamic errors;
  final Paging paging;

  factory HomeBooksResponse.fromJson(Map<String, dynamic> json) =>
      HomeBooksResponse(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        errors: json["errors"],
        paging: Paging.fromJson(json["paging"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "errors": errors,
        "paging": paging.toJson(),
      };
}

class Datum {
  Datum({
    required this.title,
    required this.books,
  });

  final String title;
  final List<Book> books;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"],
        books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "books": List<dynamic>.from(books.map((x) => x.toJson())),
      };
}

class Paging {
  Paging({
    required this.hasNext,
    required this.currentPage,
    required this.totalPages,
    required this.totalData,
    required this.limit,
  });

  final bool hasNext;
  final int currentPage;
  final int totalPages;
  final int totalData;
  final int limit;

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        hasNext: json["hasNext"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalData: json["totalData"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "hasNext": hasNext,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalData": totalData,
        "limit": limit,
      };
}
