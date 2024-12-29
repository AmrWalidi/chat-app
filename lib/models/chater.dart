class Chater {
  final String id;
  final String email;

  Chater({required this.id, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email
    };
  }
}