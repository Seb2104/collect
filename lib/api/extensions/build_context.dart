part of '../../collect.dart';

extension NotificationExtension on BuildContext {
  void notify(String message, {Duration? duration}) {
    NotificationManager().show(
      context: this,
      message: message,
      type: NotificationType.info,
      duration: duration,
    );
  }

  void warn(String message, {Duration? duration}) {
    NotificationManager().show(
      context: this,
      message: message,
      type: NotificationType.warning,
      duration: duration,
    );
  }

  void fail(String message, {Duration? duration}) {
    NotificationManager().show(
      context: this,
      message: message,
      type: NotificationType.error,
      duration: duration,
    );
  }
}
