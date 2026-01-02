import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/api/api_service.dart';
import 'package:story_app_flutter_intermediate/data/model/story.dart';

enum ResultState { initial, loading, noData, hasData, error }

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final String token;

  StoryProvider({required this.apiService, required this.token}) {
    if (token.isNotEmpty) {
      fetchAllStories();
    }
  }

  // State for list of stories (for pagination)
  ResultState _state = ResultState.initial;
  ResultState get state => _state;
  String _message = '';
  String get message => _message;
  List<Story> _stories = [];
  List<Story> get stories => _stories;

  // Pagination state
  int _page = 1;
  final int _size = 10;
  bool _hasReachedMax = false;
  bool get hasReachedMax => _hasReachedMax;

  // State for detail of a story
  ResultState _detailState = ResultState.initial;
  ResultState get detailState => _detailState;
  String _detailMessage = '';
  String get detailMessage => _detailMessage;
  Story? _detailStory;
  Story? get detailStory => _detailStory;

  Future<void> fetchAllStories({bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      _page = 1;
      _stories = [];
      _hasReachedMax = false;
      _state = ResultState.loading;
      notifyListeners();
    } else if (_state == ResultState.loading || _hasReachedMax) {
      // Prevent multiple requests or fetching beyond the end
      return;
    }

    try {
      final response = await apiService.getAllStories(
        token,
        page: _page,
        size: _size,
      );
      if (response['error'] == false) {
        final List<dynamic> storyList = response['listStory'];

        if (storyList.length < _size) {
          _hasReachedMax = true;
        }

        final newStories = storyList
            .map((json) => Story.fromJson(json))
            .toList();
        _stories.addAll(newStories);

        if (_stories.isEmpty) {
          _state = ResultState.noData;
          _message = 'No stories found.';
        } else {
          _state = ResultState.hasData;
        }

        _page++; // Increment for next fetch
      } else if (isInitialLoad) {
        _state = ResultState.error;
        _message = response['message'];
      }
    } catch (e) {
      if (isInitialLoad) {
        _state = ResultState.error;
        _message = 'Failed to load stories. Please check your connection.';
      }
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
    String description,
    List<int> bytes,
    String fileName, {
    double? lat,
    double? lon,
  }) async {
    try {
      final response = await apiService.addNewStory(
        token,
        description,
        bytes,
        fileName,
        lat: lat,
        lon: lon,
      );
      if (response['error'] == false) {
        await fetchAllStories(isInitialLoad: true); // Refresh list
      }
      return response;
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }
}
