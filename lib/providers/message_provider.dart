import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageProvider extends ChangeNotifier {
  Message _message = Message("Hello World!");

  Message get message => _message;

  void updateMessage(String newText) {
    _message = Message(newText);
    notifyListeners(); // Cập nhật UI
  }
}
