import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/api/api_service.dart';
import 'package:story_app_flutter_intermediate/data/model/story.dart';

enum ResultState { initial, loading, noData, hasData, error }

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final String token;

  StoryProvider({required this.apiService, required this.token}) {
    if (token.isNotEmpty) {
      _fetchAllStories();
    }
  }

  // State for list of stories
  ResultState _state = ResultState.initial;
  ResultState get state => _state;
  String _message = '';
  String get message => _message;
  List<Story> _stories = [];
  List<Story> get stories => _stories;

  // State for detail of a story
  ResultState _detailState = ResultState.initial;
  ResultState get detailState => _detailState;
  String _detailMessage = '';
  String get detailMessage => _detailMessage;
  Story? _detailStory;
  Story? get detailStory => _detailStory;

  Future<void> _fetchAllStories() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final response = await apiService.getAllStories(token);
      if (response['error'] == false) {
        final List<dynamic> storyList = response['listStory'];
        if (storyList.isEmpty) {
          _state = ResultState.noData;
          _message = 'No stories found.';
        } else {
          _state = ResultState.hasData;
          _stories = storyList.map((json) => Story.fromJson(json)).toList();
        }
      } else {
        _state = ResultState.error;
        _message = response['message'];
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load stories. Please check your connection.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchDetailStory(String id) async {
    try {
      _detailState = ResultState.loading;
      notifyListeners();

      final response = await apiService.getDetailStory(token, id);
      if (response['error'] == false) {
        _detailState = ResultState.hasData;
        _detailStory = Story.fromJson(response['story']);
      } else {
        _detailState = ResultState.error;
        _detailMessage = response['message'];
      }
    } catch (e) {
      _detailState = ResultState.error;
      _detailMessage = 'Failed to load story detail.';
    } finally {
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addNewStory(
      String description, List<int> bytes, String fileName) async {
    try {
      final response = await apiService.addNewStory(token, description, bytes, fileName);
      if (response['error'] == false) {
        await _fetchAllStories();
      }
      return response;
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }
}
