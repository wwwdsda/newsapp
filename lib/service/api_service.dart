import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../model/news_item.dart';
import '../widgets/news_block_widget.dart';
import '../utils/globals.dart';
import '../widgets/news_bias_section.dart';

class ApiService {
  static const String _authUrl = '127.0.0.1:8081';
  static const String _userUrl = '127.0.0.1:8083';
  static const String _newsUrl = '127.0.0.1:8084';
  static const String _filterUrl = '127.0.0.1:8082';

  static String cleanTitle(String title) {
    return title.replaceAll('\n', '').replaceAll('\"', '').trim();
  }

  static Future<bool> login(String id, String password) async {
    final url = Uri.http(_authUrl, '/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password}),
    );
    return response.statusCode == 200 &&
        jsonDecode(response.body)['success'] == true;
  }

  static Future<void> refreshData() async {
    await saveNews('/korea_news_save');
    await saveNews('/world_news_save');
    await saveNews('/economy_news_save');
    await saveNews('/tech_news_save');
    await saveNews('/entertainment_news_save');
    await saveNews('/sport_news_save');
    await aiFilter();
  }

  static Future<void> allnewssave() async {
    await saveNews('/korea_news_save');
    await saveNews('/world_news_save');
    await saveNews('/economy_news_save');
    await saveNews('/tech_news_save');
    await saveNews('/entertainment_news_save');
    await saveNews('/sport_news_save');
  }

  static Future<void> saveNews(String endpoint) async {
    final url = Uri.http(_newsUrl, endpoint);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] != true) {
        print('뉴스 저장 실패: ${data['message']}');
      }
    } else {
      print('서버 오류: ${response.statusCode}');
    }
  }

  static Future<void> aiFilter() async {
    final filterUrl = Uri.http(_filterUrl, '/ai_filter', {
      'id': userid,
      'password': userpassword,
    });
    final response = await http.get(filterUrl);
  }

  static Future<List<NewsBlockData>> fetchNews(DateTime date) async {
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    final url = Uri.http(_newsUrl, '/news', {'date': formatted});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['news'] != null) {
        final Map<String, dynamic> newsMap = Map<String, dynamic>.from(
          data['news'],
        );
        final List<NewsBlockData> blocks = [];

        for (final entry in newsMap.entries) {
          final String category = entry.key;
          final List<dynamic> items = entry.value;

          final List<NewsItem> newsItems =
              items.map((item) {
                final String title = item['title'];
                final String summary = item['summary'];
                final String time = item['time'];
                final bool isValid = item['isValid'];
                final isScrappedRaw = item['isScrapped'];
                final isScrappedList =
                    (isScrappedRaw is List)
                        ? List<String>.from(isScrappedRaw)
                        : <String>[];
                final bool isScrapped = isScrappedList.contains(userid);

                final timeParts = time.split(':');
                final String timeHM =
                    timeParts.length >= 2
                        ? '${timeParts[0]}:${timeParts[1]}'
                        : time;

                return NewsItem(
                  category: category,
                  title: title,
                  summary: summary,
                  date: date,
                  isScrapped: isScrapped,
                  isValid: isValid,
                  time: timeHM,
                );
              }).toList();

          blocks.add(NewsBlockData(title: category, newsItems: newsItems));
        }

        return blocks;
      }
    }

    return [];
  }

  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final userData = {
      "이름": fullName,
      "아이디": email,
      "비밀번호": password,
      "키워드": [],
      "뉴스사": [],
      "뉴스 성향": ["중도"],
      "뉴스 주제": ["국내 정치", "해외", "경제"],
    };

    final url = Uri.http(_authUrl, '/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(userData);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return {"success": true};
    } else {
      final responseData = jsonDecode(response.body);
      return {
        "success": false,
        "message": responseData['message'] ?? '회원가입에 실패했습니다.',
      };
    }
  }

  static Future<bool> toggleScrap(NewsItem newsItem) async {
    final url = Uri.http(_newsUrl, '/scrap');
    final body = jsonEncode({
      'userid': userid,
      'date': DateFormat('yyyy-MM-dd').format(newsItem.date),
      'category': newsItem.category,
      'title': cleanTitle(newsItem.title),
      'summary': cleanTitle(newsItem.summary ?? ''),
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('에러 발생(news toggleScrap): $e');
      return false;
    }
  }

  static Future<List<NewsItem>> fetchScrappedNews() async {
    final url = Uri.http(_newsUrl, '/bring_scrap');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userid': userid}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => NewsItem.fromJson(e)).toList();
    } else {
      throw Exception('스크랩 뉴스 불러오기 실패: ${response.statusCode}');
    }
  }

  static Future<bool> addKeyword({
    required String id,
    required String password,
    required String keyword,
  }) async {
    final url = Uri.http(_userUrl, '/addkeyword');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password, 'keyword': keyword}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> removeKeyword({
    required String id,
    required String password,
    required String keyword,
  }) async {
    final url = Uri.http(_userUrl, '/deletekeyword');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password, 'keyword': keyword}),
    );
    return response.statusCode == 200;
  }

  static Future<List<String>> loadKeywords({
    required String id,
    required String password,
  }) async {
    final url = Uri.http(_userUrl, '/keyword', {
      'id': id,
      'password': password,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['keyword'] ?? []);
    } else {
      throw Exception('키워드 로드 실패: ${response.statusCode}');
    }
  }

  static Future<Set<String>> fetchUserBiases() async {
    final url = Uri.http(_userUrl, '/user_biases', {
      'id': userid,
      'password': userpassword,
    });
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final dynamic rawBiases = body['biases'];

      if (rawBiases is List) {
        return rawBiases.cast<String>().toSet();
      } else {
        return {};
      }
    } else {
      throw Exception('뉴스 성향 불러오기 실패');
    }
  }

  static Future<void> addUserBias(String bias) async {
    final url = Uri.http(_userUrl, '/add_bias');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': userid, 'password': userpassword, 'bias': bias}),
    );
    if (response.statusCode != 200) {
      throw Exception('뉴스 성향 추가 실패: ${response.statusCode}');
    }
  }

  static Future<void> deleteUserBias(String bias) async {
    final url = Uri.http(_userUrl, '/delete_bias');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': userid, 'password': userpassword, 'bias': bias}),
    );
    if (response.statusCode != 200) {
      throw Exception('뉴스 성향 삭제 실패: ${response.statusCode}');
    }
  }

  static Future<void> saveUserBias(Set<String> biases) async {
    final url = Uri.http(_userUrl, '/save_biases');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userid,
        'password': userpassword,
        'biases': biases.toList(),
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('뉴스 주제 저장 실패: ${response.statusCode}');
    }
  }

  static Future<Set<String>> fetchUserTopics() async {
    final url = Uri.http(_userUrl, '/user_topics', {
      'id': userid,
      'password': userpassword,
    });
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final dynamic rawTopics = body['topics'];
      if (rawTopics is List) {
        return rawTopics.cast<String>().toSet();
      } else {
        return {};
      }
    } else {
      throw Exception('뉴스 주제 불러오기 실패');
    }
  }

  static Future<void> addUserTopic(String topic) async {
    final url = Uri.http(_userUrl, '/add_topic');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userid,
        'password': userpassword,
        'topic': topic,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('뉴스 주제 추가 실패: ${response.statusCode}');
    }
  }

  static Future<void> deleteUserTopic(String topic) async {
    final url = Uri.http(_userUrl, '/delete_topic');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userid,
        'password': userpassword,
        'topic': topic,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('뉴스 주제 삭제 실패: ${response.statusCode}');
    }
  }

  static Future<void> saveUserTopics(Set<String> topics) async {
    final url = Uri.http(_userUrl, '/save_topics');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userid,
        'password': userpassword,
        'topics': topics.toList(),
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('뉴스 주제 저장 실패: ${response.statusCode}');
    }
  }

  static Future<String> fetchSummaryFromServer(String title) async {
    final uri = Uri.http(_filterUrl, '/ai_summary');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['summary'] ?? '요약 실패';
    } else {
      return '요약 실패';
    }
  }
}
