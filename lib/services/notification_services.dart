import 'package:rxdart/rxdart.dart';

class NotificationServices {
  var _newMessage = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get streamNewMessage$ => _newMessage.stream;

  bool get newMessage => _newMessage.value!;

  void openMessage() {
    _newMessage.add(false);
  }

  void updateMessage() {
    _newMessage.add(true);
  }
}

NotificationServices rxNotificationService = NotificationServices();
