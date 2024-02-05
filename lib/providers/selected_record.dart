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
    totalTime: 0,
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

  void updateIsAchieved(bool isAchieved) {
    _selectedRecord = RecordInfo(
      recordUuid: _selectedRecord.recordUuid,
      bookUuid: _selectedRecord.bookUuid,
      userUuid: _selectedRecord.userUuid,
      goalType: _selectedRecord.goalType,
      goalScale: _selectedRecord.goalScale,
      pageStart: _selectedRecord.pageStart,
      pageEnd: _selectedRecord.pageEnd,
      totalTime: _selectedRecord.totalTime,
      start: _selectedRecord.start,
      end: _selectedRecord.end,
      goalAchieved: isAchieved,
      createdAt: _selectedRecord.createdAt,
    );
    notifyListeners();
  }

  void updateEndPage(int endPage) {
    _selectedRecord = RecordInfo(
      recordUuid: _selectedRecord.recordUuid,
      bookUuid: _selectedRecord.bookUuid,
      userUuid: _selectedRecord.userUuid,
      goalType: _selectedRecord.goalType,
      goalScale: _selectedRecord.goalScale,
      pageStart: _selectedRecord.pageStart,
      pageEnd: endPage,
      totalTime: _selectedRecord.totalTime,
      start: _selectedRecord.start,
      end: _selectedRecord.end,
      goalAchieved: _selectedRecord.goalAchieved,
      createdAt: _selectedRecord.createdAt,
    );
    notifyListeners();
  }

  void updateTotalTime(int totalTime) {
    _selectedRecord = RecordInfo(
      recordUuid: _selectedRecord.recordUuid,
      bookUuid: _selectedRecord.bookUuid,
      userUuid: _selectedRecord.userUuid,
      goalType: _selectedRecord.goalType,
      goalScale: _selectedRecord.goalScale,
      pageStart: _selectedRecord.pageStart,
      pageEnd: _selectedRecord.pageEnd,
      totalTime: totalTime,
      start: _selectedRecord.start,
      end: _selectedRecord.end,
      goalAchieved: _selectedRecord.goalAchieved,
      createdAt: _selectedRecord.createdAt,
    );
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
      totalTime: 0,
      start: '',
      end: '',
      goalAchieved: false,
      createdAt: '',
    );
    notifyListeners();
  }
}
