/// Model data post dari endpoint `/posts`.
class Post {
  /// ID pengguna pembuat post.
  final int userId;

  /// ID unik post.
  final int id;

  /// Judul post.
  final String title;

  /// Isi post.
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  /// Membuat [Post] dari JSON; field yang kosong diberi nilai bawaan.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] ?? 0,
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}
