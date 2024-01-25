import 'package:flutter/material.dart';
import 'package:sprit/apis/services/record.dart';

class SelectedRecordInfoState extends ChangeNotifier {
  RecordInfo _selectedRecord = const RecordInfo(
    recordUuid: '',
    bookUuid: '',
    userUuid: '',
    goalType: '',
    goalScale: 0,
    pageStart: 0,
    pageEnd: 0,
    start: '',
    end: '',
    goalAchieved: false,
    createdAt: '',
  );

  RecordInfo get getSelectedRecordInfo => _selectedRecord;

  void updateSelectedRecord(RecordInfo record) {
    _selectedRecord = record;
    notifyListeners();
  }

  void removeSelectedRecord() {
    _selectedRecord = const RecordInfo(
      recordUuid: '',
      bookUuid: '',
      userUuid: '',
      goalType: '',
      goalScale: 0,
      pageStart: 0,
      pageEnd: 0,
      start: '',
      end: '',
      goalAchieved: false,
      createdAt: '',
    );
    notifyListeners();
  }
}
