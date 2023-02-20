class Address {
  Address({
    required this.id,
    required this.houseNumber,
    required this.streetName,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
  });

  String id;
  String houseNumber;
  String streetName;
  String city;
  String state;
  String country;
  String zipCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["_id"],
    houseNumber: json["houseNumber"],
    streetName: json["streetName"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipCode: json["zipCode"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "houseNumber": houseNumber,
    "streetName": streetName,
    "city": city,
    "state": state,
    "country": country,
    "zipCode": zipCode,
  };
}