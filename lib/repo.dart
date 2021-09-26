// To parse this JSON data, do
//
//     final repo = repoFromJson(jsonString);

import 'dart:convert';

Repo repoFromJson(String str) => Repo.fromJson(json.decode(str));

String repoToJson(Repo data) => json.encode(data.toJson());

class Repo {
  Repo({
    required this.people,
    required this.number,
    required this.message,
  });

  List<Person> people;
  int number;
  String message;

  factory Repo.fromJson(Map<String, dynamic> json) => Repo(
    people: List<Person>.from(json["people"].map((x) => Person.fromJson(x))),
    number: json["number"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "people": List<dynamic>.from(people.map((x) => x.toJson())),
    "number": number,
    "message": message,
  };
}

class Person {
  Person({
    required this.craft,
    required this.name,
  });

  String craft;
  String name;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    craft: json["craft"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "craft": craft,
    "name": name,
  };
}
