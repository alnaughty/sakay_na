import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakayna/models/firebase_account_info_model.dart';
import 'package:sakayna/view_model.dart/firebase_driver_info_vm.dart';

class FirestoreAccountDetailsService {
  final FirestoreAccountInfoVM _infoVm = FirestoreAccountInfoVM.instance;
  FirestoreAccountDetailsService._singleton();
  static final FirestoreAccountDetailsService _instance =
      FirestoreAccountDetailsService._singleton();
  static FirestoreAccountDetailsService get instance => _instance;
  late StreamSubscription subscription;
  CollectionReference<FirestoreAccountInfoModel> sportReference =
      FirebaseFirestore.instance
          .collection('account_geo_loc')
          .withConverter<FirestoreAccountInfoModel>(
            fromFirestore: (snapshot, _) =>
                FirestoreAccountInfoModel.fromJson(snapshot.data()!),
            toFirestore: (sport, _) => sport.toJSON(),
          );
  Stream<QuerySnapshot<FirestoreAccountInfoModel>> subscriptionlisten() =>
      sportReference.snapshots();

  StreamSubscription subscribe() => subscriptionlisten()
          .listen((QuerySnapshot<FirestoreAccountInfoModel>? event) {
        List<FirestoreAccountInfoModel> data = event!.docs
            .map((e) => FirestoreAccountInfoModel(
                  name: e.get('name'),
                  location: LatLng(
                    double.parse(e.get('latitude').toString()),
                    double.parse(
                      e.get('longitude').toString(),
                    ),
                  ),
                  firebaseId: e.id,
                  id: int.parse(e.get('id').toString()),
                  accountType: int.parse(e.get("account_type").toString()),
                ))
            .toList();
        _infoVm.populate(data);
      });
}
