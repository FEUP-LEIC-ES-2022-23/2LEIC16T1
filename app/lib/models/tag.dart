class Tag {
  final String name;
  final int weight;

  Tag({
    required this.name,
    required this.weight
  });

  static Tag fromJson(String name, Map<String, dynamic> json) => Tag(
    name: name,
    weight: json['weight']
  );
}