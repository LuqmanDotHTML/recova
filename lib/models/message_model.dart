class Message {
  final String id;
  final String reportId;
  final String senderId;
  final String receiverId;
  final String content;
  final bool isRead;
  final String? senderName;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.reportId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.isRead = false,
    this.senderName,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>?;
    return Message(
      id: json['id'] as String,
      reportId: json['report_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      content: json['content'] as String,
      isRead: json['is_read'] as bool? ?? false,
      senderName: sender?['full_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
