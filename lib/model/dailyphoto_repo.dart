// To parse this JSON data, do
//
//     final dailyPhoto = dailyPhotoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<DailyPhoto> dailyPhotoFromJson(String str) => List<DailyPhoto>.from(json.decode(str).map((x) => DailyPhoto.fromJson(x)));

String dailyPhotoToJson(List<DailyPhoto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyPhoto {
  DailyPhoto({
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
  });

  DateTime date;
  String explanation;
  String hdurl;
  String mediaType;
  String serviceVersion;
  String title;
  String url;

  factory DailyPhoto.fromJson(Map<String, dynamic> json) => DailyPhoto(
    date: DateTime.parse(json["date"]),
    explanation: json["explanation"],
    hdurl: json["hdurl"],
    mediaType: json["media_type"],
    serviceVersion: json["service_version"],
    title: json["title"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "explanation": explanation,
    "hdurl": hdurl,
    "media_type": mediaType,
    "service_version": serviceVersion,
    "title": title,
    "url": url,
  };
}
