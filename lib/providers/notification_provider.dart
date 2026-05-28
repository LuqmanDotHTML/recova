import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<AppNotification> _notifications = [];
  int _unreadCount = 0;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  Future<void> loadNotifications() async {
    try {
      _notifications = await _service.getNotifications();
      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    await _service.markAsRead(id);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await _service.markAllAsRead();
    await loadNotifications();
  }
}
