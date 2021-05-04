import 'package:rxdart/rxdart.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/date_sorter.dart';
import 'package:uitemplate/view_model/logs/log_api_call.dart';

class LogService {
  LogApiCall apiCall = LogApiCall.instance;
  LogService._privateConstructor();
  static final LogService _instance = LogService._privateConstructor();
  static LogService get instance => _instance;

  BehaviorSubject<List<LogModel>> _logs = new BehaviorSubject.seeded([]);
  Stream<List<LogModel>> get stream$ => _logs.stream;
  List<LogModel>? get current => _logs.value;

  void populate({required List<LogModel> data}) {
    this._logs.add(data);
  }

  void append({required LogModel data}) {
    this.current!.add(data);
    this.current!.sort((a, b) =>
        DateTime.parse(b.created_at!).compareTo(DateTime.parse(a.created_at!)));
    this._logs.add(this.current!);
  }
}

LogService logService = LogService.instance;
