
class Comment {
  final int commentId;
  final String userId;
  final String userName;
  final String commentText;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['CommentId'],
      userId: json['UserId'],
      userName: json['UserName'],
      commentText: json['CommentText'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}


