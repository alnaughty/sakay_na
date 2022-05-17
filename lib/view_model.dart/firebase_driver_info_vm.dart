import 'package:rxdart/rxdart.dart';
import 'package:sakayna/models/firebase_account_info_model.dart';

class FirestoreAccountInfoVM {
  FirestoreAccountInfoVM._singleton();
  static final FirestoreAccountInfoVM _instance =
      FirestoreAccountInfoVM._singleton();
  static FirestoreAccountInfoVM get instance => _instance;
  BehaviorSubject<List<FirestoreAccountInfoModel>>? _subject =
      BehaviorSubject();
  Stream<List<FirestoreAccountInfoModel>>? get stream$ => _subject!.stream;
  List<FirestoreAccountInfoModel>? get current => _subject!.value;
  void populate(List<FirestoreAccountInfoModel> data) {
    _subject!.add(data);
    List<FirestoreAccountInfoModel> currentData = List.from(current!);
    List<FirestoreAccountInfoModel> _data = [];
    currentData.forEach((element) {
      _data.removeWhere((e) => e.id == element.id);
      _data.add(element);
    });
    _subject!.add(_data);
  }

  void append(FirestoreAccountInfoModel data) {
    current!.add(data);
    _subject!.add(current!);
  }
}
