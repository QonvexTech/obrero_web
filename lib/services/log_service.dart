import 'package:rxdart/rxdart.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/view_model/logs/log_api_call.dart';

import 'notification_services.dart';

class LogService {
  LogApiCall apiCall = LogApiCall.instance;
  LogService._privateConstructor();
  static final LogService _instance = LogService._privateConstructor();
  static LogService get instance => _instance;

  BehaviorSubject<List<LogModel>> _logs = new BehaviorSubject.seeded([]);

  Stream<List<LogModel>> get stream$ => _logs.stream;

  List<LogModel>? get current => _logs.value;

  //first fetch
  void populate({required List<LogModel> data}) {
    this._logs.add(data);
  }

  //update from firebase
  void append({required LogModel data}) {
    this.current!.add(data);
    this.current!.sort((a, b) =>
        DateTime.parse(b.created_at!).compareTo(DateTime.parse(a.created_at!)));
    this._logs.add(this.current!);
    rxNotificationService.updateMessage();
  }

  // var _newMessage = BehaviorSubject<bool>.seeded(false);
  // Stream<bool> get $streamNewMessage => _newMessage.stream;

  // bool get newMessage => _newMessage.value!;

  // void openMessage() {
  //   _newMessage.add(false);
  // }

  // void upDateMessage() {
  //   _newMessage.add(true);
  // }
}

LogService logService = LogService.instance;
