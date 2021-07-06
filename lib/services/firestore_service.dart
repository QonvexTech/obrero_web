import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  FirestoreService._private();
  static final FirestoreService _service = FirestoreService._private();
  static FirestoreService get instance => _service;
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();
  static final CollectionReference _collectionReference =
  _fireStore.collection('obrero-location-collection');

  FirebaseFirestore get fireStore => _fireStore;
  Future<FirebaseApp> get firebaseInit => _firebaseInit;
  CollectionReference  get collectionReference => _collectionReference;
}
