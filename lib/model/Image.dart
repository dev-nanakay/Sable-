class DBImage {
  DBImage({
    required this.createdAt,
    required this.id,
    required this.imageId,
  });

  DateTime createdAt;
  String id;
  String imageId;

  factory DBImage.fromJson(Map<String, dynamic> json) => DBImage(
        createdAt: DateTime.parse(json["createdAt"]),
        id: json["_id"],
        imageId: json["imageId"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "_id": id,
        "imageId": imageId,
      };
}
