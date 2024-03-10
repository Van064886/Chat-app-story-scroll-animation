import 'package:telegram_story_scroll_animation/models/user.dart';

class Message {
  int? id;
  User? sender;
  String? message;
  String? sentAt;

  Message({required this.sender, required this.message, required this.sentAt});
}
