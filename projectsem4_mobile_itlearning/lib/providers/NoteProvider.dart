import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectsem4_mobile_itlearning/constants/urlAPI.dart';
import 'dart:convert';
import '../constants/AuthenticatedHttpClient.dart';
import '../models/ApiResponse.dart';
import '../models/Lesson/ItemOfLesson/Video/NoteInDurationDTO.dart';
import '../models/Lesson/ItemOfLesson/Video/NoteInVideoDTO.dart';
import '../widgets/ExampleSnackbar.dart';


class NoteProvider extends ChangeNotifier {
  AuthenticatedHttpClient _httpClient;
  NoteProvider(this._httpClient);
  List<NoteInVideoDTO> listNote = [];



  Future<void> createNoteInDuration(NoteInDurationDTO note, BuildContext context) async {
    final response = await _httpClient.post(
      Uri.parse(domain + 'api/note-in-duration/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(note.toJson()),
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    final apiResponse = ApiResponse.fromJson(responseData);
    if (response.statusCode == 200) {
      await getNote(note.videoCourseId, context);
      SnackBarShowSuccess(context, apiResponse.message);
    } else {

      SnackBarShowError(context, apiResponse.message);
    }
  }
  Future<List<NoteInVideoDTO>> getNote(int videoCourseId, BuildContext context) async {
    final response = await _httpClient.get(
      Uri.parse(domain + 'api/note-in-duration/listByStudent/$videoCourseId'),
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    final apiResponse = ApiResponse.fromJson(responseData);
    if (response.statusCode == 200) {
      List<NoteInVideoDTO> notes = (apiResponse.data as List).map((item) => NoteInVideoDTO.fromJson(item)).toList();
      listNote = notes ;
      notifyListeners();
      return listNote;
    } else {
      SnackBarShowError(context, apiResponse.message);
      return listNote;
    }
  }
  Future<void> deleteNote(int noteId, BuildContext context) async {
    final response = await _httpClient.delete(
      Uri.parse(domain + 'api/note-in-duration/delete/$noteId'),
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    final apiResponse = ApiResponse.fromJson(responseData);
    SnackBarShowSuccess(context, apiResponse.message);
  }
}