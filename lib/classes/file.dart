class File {
  String fileName;
  String imageLink;
  String fileType;
  List<String> tags;

  File({
    required this.fileName,
    required this.imageLink,
    required this.fileType,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'file_name': fileName,
      'image_link': imageLink,
      'file_type' : fileType,
      'tags': tags,
    };
  }

  static File fromMap(Map<String, dynamic> map) {
    return File(
      fileName: map['file_name'],
      imageLink: map['image_link'],
      fileType: map['file_type'],
      tags: map['tags'],
    );
  }
}
