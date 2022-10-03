import 'package:cloud_firestore/cloud_firestore.dart';
import 'history.dart';
import 'package:flutter/material.dart';

class HistoryModel extends ChangeNotifier {
  List<History> historys = [];

  Future fetchHistory() async {
    final doc = await FirebaseFirestore.instance.collection('QR').get();

    final historys =
        doc.docs.map((doc) => History(doc['title'], doc['url'])).toList();

    this.historys = historys;
    notifyListeners();
  }
}
