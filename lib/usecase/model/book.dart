class Book {
  Book({
    required this.bookId,
    required this.title,
    required this.author,
    required this.illustrator,
    required this.publisherId,
    required this.synopsis,
    required this.tags,
    required this.width,
    required this.height,
    required this.totalPage,
    required this.minPage,
    required this.totalDuration,
    required this.year,
    required this.expiredAt,
    required this.minDuration,
    required this.pageDuration,
    required this.isFree,
    required this.isbn,
    required this.coverPath,
    required this.orientation,
    required this.status,
    required this.themeIds,
    required this.ageIds,
    required this.formatIds,
    required this.levelIds,
    required this.level,
    required this.themes,
    required this.ages,
    required this.formats,
    required this.imageUrl,
    required this.isFavorite,
    required this.collectionIds,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.publisher,
  });

  final int bookId;
  final String title;
  final String author;
  final String illustrator;
  final int publisherId;
  final String synopsis;
  final String tags;
  final int width;
  final int height;
  final int totalPage;
  final int minPage;
  final int totalDuration;
  final int year;
  final DateTime expiredAt;
  final int minDuration;
  final int pageDuration;
  final bool isFree;
  final String isbn;
  final String coverPath;
  final int orientation;
  final int status;
  final String themeIds;
  final String ageIds;
  final String formatIds;
  final String levelIds;
  final dynamic level;
  final dynamic themes;
  final dynamic ages;
  final dynamic formats;
  final String imageUrl;
  final bool isFavorite;
  final String collectionIds;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final dynamic publisher;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        bookId: json["bookId"],
        title: json["title"],
        author: json["author"],
        illustrator: json["illustrator"],
        publisherId: json["publisherId"],
        synopsis: json["synopsis"],
        tags: json["tags"],
        width: json["width"],
        height: json["height"],
        totalPage: json["totalPage"],
        minPage: json["minPage"],
        totalDuration: json["totalDuration"],
        year: json["year"],
        expiredAt: json["expiredAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["expiredAt"]),
        minDuration: json["minDuration"],
        pageDuration: json["pageDuration"],
        isFree: json["isFree"],
        isbn: json["isbn"],
        coverPath: json["coverPath"],
        orientation: json["orientation"],
        status: json["status"],
        themeIds: json["themeIds"],
        ageIds: json["ageIds"],
        formatIds: json["formatIds"],
        levelIds: json["levelIds"],
        level: json["level"],
        themes: json["themes"],
        ages: json["ages"],
        formats: json["formats"],
        imageUrl: json["imageUrl"],
        isFavorite: json["isFavorite"],
        collectionIds: json["collectionIds"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        publisher: json["publisher"],
      );

  Map<String, dynamic> toJson() => {
        "bookId": bookId,
        "title": title,
        "author": author,
        "illustrator": illustrator,
        "publisherId": publisherId,
        "synopsis": synopsis,
        "tags": tags,
        "width": width,
        "height": height,
        "totalPage": totalPage,
        "minPage": minPage,
        "totalDuration": totalDuration,
        "year": year,
        "expiredAt": expiredAt.toIso8601String(),
        "minDuration": minDuration,
        "pageDuration": pageDuration,
        "isFree": isFree,
        "isbn": isbn,
        "coverPath": coverPath,
        "orientation": orientation,
        "status": status,
        "themeIds": themeIds,
        "ageIds": ageIds,
        "formatIds": formatIds,
        "levelIds": levelIds,
        "level": level,
        "themes": themes,
        "ages": ages,
        "formats": formats,
        "imageUrl": imageUrl,
        "isFavorite": isFavorite,
        "collectionIds": collectionIds,
        "publishedAt": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "publisher": publisher,
      };
}
