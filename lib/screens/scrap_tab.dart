import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../model/news_item.dart';
import '../service/api_service.dart';
import '../widgets/news_block_widget.dart';
import 'side_menu.dart';

class ScrapTab extends StatefulWidget {
  const ScrapTab({Key? key}) : super(key: key);

  @override
  State<ScrapTab> createState() => _ScrapTabState();
}

class _ScrapTabState extends State<ScrapTab> {
  Map<String, List<NewsItem>> _scrappedNews = {};
  final Map<String, bool> _expandedDates = {};

  @override
  void initState() {
    super.initState();
    _fetchScrappedNews();
  }

  Future<void> _fetchScrappedNews() async {
    try {
      final response = await ApiService.fetchScrappedNews();

      final Map<String, List<NewsItem>> groupedNews = {};

      for (var item in response) {
        final dateStr = DateFormat('yyyy-MM-dd').format(item.date);
        groupedNews.putIfAbsent(dateStr, () => []).add(item);
      }

      setState(() {
        _scrappedNews = groupedNews;
      });
    } catch (e) {
      print('스크랩 뉴스 불러오기 실패: $e');
    }
  }

  void _toggleDateExpansion(String date) {
    setState(() {
      _expandedDates[date] = !(_expandedDates[date] ?? false);
    });
  }

  Future<void> _handleScrapToggle(NewsItem item) async {
    try {
      final success = await ApiService.toggleScrap(item);
      if (success) {
        await _fetchScrappedNews();
      } else {
        print('스크랩 상태 변경 실패');
      }
    } catch (e) {
      print('스크랩 상태 변경 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateKeys =
        _scrappedNews.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8.0),
            Text(
              '스크랩',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8.0),
          ],
        ),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: _openMenu),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchScrappedNews,
          ),
        ],
      ),
      body:
          _scrappedNews.isEmpty
              ? const Center(child: Text('스크랩한 뉴스가 없습니다'))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: dateKeys.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final date = dateKeys[index];
                  final items = _scrappedNews[date]!;
                  final isExpanded = _expandedDates[date] ?? false;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat(
                                  'yyyy년 MM월 dd일 (E)',
                                  'ko_KR',
                                ).format(DateTime.parse(date)),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                ),
                                onPressed: () => _toggleDateExpansion(date),
                              ),
                            ],
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child:
                              isExpanded
                                  ? Column(
                                    children:
                                        items
                                            .map(
                                              (item) => NewsItemTile(
                                                newsItem: item,
                                                onToggleScrap:
                                                    _handleScrapToggle,
                                              ),
                                            )
                                            .toList(),
                                  )
                                  : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  void _openMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: SideMenuButton(),
        );
      },
    );
  }
}
