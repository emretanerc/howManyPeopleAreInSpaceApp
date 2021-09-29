class NewsRepo {
  const NewsRepo({
    this.id,
    this.title,
    this.url,
    this.imageUrl,
    this.newsSite,
    this.summary,
    this.publishedAt,
    this.updatedAt,
    this.featured,
    this.launches,
    this.events,
  });

  final int? id;
  final String? title;
  final String? url;
  final String? imageUrl;
  final String? newsSite;
  final String? summary;
  final DateTime? publishedAt;
  final DateTime? updatedAt;
  final bool? featured;
  final List<Launch>? launches;
  final List<Event>? events;

  factory NewsRepo.fromJson(Map<String, dynamic> json) => NewsRepo(
    id: json["id"],
    title: json["title"],
    url: json["url"],
    imageUrl: json["imageUrl"],
    newsSite: json["newsSite"],
    summary: json["summary"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    featured: json["featured"],
    launches:
    List<Launch>.from(json["launches"].map((x) => Launch.fromJson(x))),
    events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "url": url,
    "imageUrl": imageUrl,
    "newsSite": newsSite,
    "summary": summary,
    "publishedAt": publishedAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "featured": featured,
    "launches": List<dynamic>.from(launches!.map((x) => x.toJson())),
    "events": List<dynamic>.from(events!.map((x) => x.toJson())),
  };
}

class Event {
  const Event({
    this.id,
    this.provider,
  });

  final int? id;
  final String? provider;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    provider: json["provider"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider": provider,
  };
}

class Launch {
  const Launch({
    this.id,
    this.provider,
  });

  final String? id;
  final String? provider;

  factory Launch.fromJson(Map<String, dynamic> json) => Launch(
    id: json["id"],
    provider: json["provider"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider": provider,
  };
}
