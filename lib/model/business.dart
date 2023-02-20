// To parse this JSON data, do
//
//     final business = businessFromJson(jsonString);

import 'dart:convert';

import 'package:sac_wallet/model/Image.dart';

import 'addresses.dart';
import 'location.dart';

Business businessFromJson(String str) => Business.fromJson(json.decode(str));

String businessToJson(Business data) => json.encode(data.toJson());

class Business {
  Business({
    this.verification = '',
    this.id = '',
    this.name = '',
    this.userId = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = null,
    this.category = '',
    this.websiteUrl = '',
    this.twitterUrl = '',
    this.instagramUrl = '',
    this.facebookUrl = '',
    this.description = '',
    this.foundationYear = '',
    this.location = null,
    this.images = const [],
    this.createdAt = null,
    this.updatedAt = null,
  });

  String verification;
  String id;
  String name;
  String userId;
  String email;
  String phoneNumber;
  Address? address;
  String category;
  String websiteUrl;
  String twitterUrl;
  String instagramUrl;
  String facebookUrl;
  String description;
  String foundationYear;
  MyLocation? location;
  List<DBImage> images;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        verification: json["verification"],
        id: json["_id"],
        name: json["name"],
        userId: json["userId"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        address: Address.fromJson(json["address"]),
        category: json["category"],
        websiteUrl: json["websiteUrl"],
        twitterUrl: json["twitterUrl"],
        instagramUrl: json["instagramUrl"],
        facebookUrl: json["facebookUrl"],
        description: json["description"],
        foundationYear: json["foundationYear"],
        location: MyLocation.fromJson(json["location"]),
        images:
            List<DBImage>.from(json["images"].map((x) => DBImage.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "verification": verification,
        "_id": id,
        "name": name,
        "userId": userId,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address!.toJson(),
        "category": category,
        "websiteUrl": websiteUrl,
        "twitterUrl": twitterUrl,
        "instagramUrl": instagramUrl,
        "facebookUrl": facebookUrl,
        "description": description,
        "foundationYear": foundationYear,
        "location": location!.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
