class Picture {
  String fileName;
  String imageLink;
  List<String> tags;

  Picture({
    required this.fileName,
    required this.imageLink,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'file_name': fileName,
      'image_link': imageLink,
      'tags': tags,
    };
  }

  static Picture fromMap(Map<String, dynamic> map) {
    return Picture(
      fileName: map['file_name'],
      imageLink: map['image_link'],
      tags: map['tags'],
    );
  }
}
