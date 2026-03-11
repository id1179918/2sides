class Event {
  Event(
      {required this.name,
      required this.location,
      required this.style,
      required this.description,
      required this.price,
      required this.date,
      required this.isSoldOut,
      required this.id});

  factory Event.fromJson(Map<String, Object?> json) {
    return Event(
      name: json['name']! as String,
      location: json['location']! as String,
      style: json['style']! as String,
      description: json['description']! as String,
      price: json['price']! as int,
      date: json['date']! as DateTime,
      isSoldOut: json['isSoldOut']! as bool,
      id: json['id']! as int,
    );
  }

  final String name;
  final String location;
  final String style;
  final String description;
  final int price;
  final DateTime date;
  final bool isSoldOut;
  final int id;
}
