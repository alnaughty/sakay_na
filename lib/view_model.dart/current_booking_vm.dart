import 'package:rxdart/rxdart.dart';
import 'package:sakayna/models/booking_data_model.dart';

class CurrentBookingVm {
  CurrentBookingVm._singleton();
  static final CurrentBookingVm _INSTANCE = CurrentBookingVm._singleton();
  static CurrentBookingVm get instance => _INSTANCE;

  BehaviorSubject<BookingDataModel?> _subject =
      BehaviorSubject<BookingDataModel?>();
  Stream<BookingDataModel?> get stream$ => _subject.stream;
  BookingDataModel? get current => _subject.value;

  void populate(BookingDataModel? booking) {
    print("POPULATING DATA : $booking");
    _subject.add(booking);
  }
}
