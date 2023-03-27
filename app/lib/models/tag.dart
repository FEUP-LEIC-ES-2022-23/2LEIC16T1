class Tag {
  final String name;
  final int weight;

  Tag({
    required this.name,
    required this.weight
  });

  static Tag fromJson(Map<String, dynamic> json) => Tag(
    name: json['name'],
    weight: json['weight']
  );
}