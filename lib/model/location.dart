class MyLocation {
  MyLocation({
    required this.coordinates,
    this.id = '',
    this.type = '',
  });

  List<double> coordinates;
  String id;
  String type;

  factory MyLocation.fromJson(Map<String, dynamic> json) => MyLocation(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        id: json["_id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "_id": id,
    "type": type,
  };
}