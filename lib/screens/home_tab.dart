import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; 

import '../model/news_item.dart';
import '../widgets/news_block_widget.dart';
import '../service/api_service.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DateTime _currentDate = DateTime.now();
  List<NewsBlockData> _newsBlocks = [];


  @override
  void initState() {
    super.initState();
    _applyAiFilter(_currentDate);
    _loadNewsForDate(_currentDate);
  }

  Future<void> _applyAiFilter(DateTime date) async {
    await ApiService.aiFilter();
  }

  Future<void> _loadNewsForDate(DateTime date) async {
    setState(() => _newsBlocks = []);
    final blocks = await ApiService.fetchNews(date);
    setState(() => _newsBlocks = blocks);
  }

  Future<void> _toggleScrap(NewsItem newsItem) async {
    final success = await ApiService.toggleScrap(newsItem);
    if (success) {
      setState(() {
        _newsBlocks = _newsBlocks.map((block) {
          if (block.title != newsItem.category) return block;
          final updatedItems = block.newsItems.map((item) {
            if (item.title != newsItem.title) return item;
            return item.copyWith(isScrapped: !item.isScrapped);
          }).toList();
          return block.copyWith(newsItems: updatedItems);
        }).toList();
      });
    }
  }

  void _changeDate(int amount) {
    final newDate = _currentDate.add(Duration(days: amount));
    final today = DateTime.now();
    if (newDate.isAfter(DateTime(today.year, today.month, today.day + 1))) return;
    setState(() => _currentDate = newDate);
    _loadNewsForDate(_currentDate);
  }

  void _openMenu() {
    print('Opening menu...');
  }

  void _refreshData() {
    _loadNewsForDate(_currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => _changeDate(-1),
            ),
            const SizedBox(width: 8.0),
            Text(
              DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_currentDate),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () => _changeDate(1),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: _openMenu),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _refreshData(),
              child: ListView.separated(
                itemCount: _newsBlocks.length,
                separatorBuilder: (context, index) => const Divider(height: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemBuilder: (context, index) {
                  final newsBlock = _newsBlocks[index];
                  final validItems = newsBlock.newsItems.where((item) => item.isValid).toList();
                  if (validItems.isNotEmpty) {
                    return NewsBlock(
                      newsBlock: newsBlock.copyWith(newsItems: validItems),
                      onToggleScrap: _toggleScrap,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
