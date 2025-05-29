import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'side_menu.dart';
import '../model/news_item.dart';
import '../widgets/news_block_widget.dart';
import '../service/api_service.dart';

class HomeTab extends StatefulWidget {
  final bool runAiFilterOnStart;
  const HomeTab({Key? key, this.runAiFilterOnStart = false}) : super(key: key);

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  DateTime _currentDate = DateTime.now();
  List<NewsBlockData> _newsBlocks = [];
  Set<String> _selectedTopics = {};
  bool _loading = true;
  bool _aiFiltering = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    await _loadUserTopics();
    if (widget.runAiFilterOnStart) {
      await _runAiFilterAndNews();
    } else {
      await _loadNewsForDate(_currentDate);
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _runAiFilterAndNews() async {
    if (mounted) setState(() => _aiFiltering = false);
    await _loadNewsForDate(_currentDate);
    if (mounted) setState(() => _aiFiltering = true);
    await ApiService.refreshData();
    if (mounted) setState(() => _aiFiltering = false);
    await _loadNewsForDate(_currentDate);
  }

  Future<void> _loadUserTopics() async {
    try {
      final topics = await ApiService.fetchUserTopics();
      if (mounted) setState(() {
        _selectedTopics = topics;
      });
    } catch (e) {
      debugPrint('주제 불러오기 실패: $e');
      if (mounted) setState(() {
        _selectedTopics = {};
      });
    }
  }

  Future<void> _loadNewsForDate(DateTime date) async {
    if (!mounted) return;
    setState(() => _newsBlocks = []);
    final blocks = await ApiService.fetchNews(date);

    final filteredBlocks = blocks
        .where((block) => _selectedTopics.contains(block.title))
        .toList();

    if (!mounted) return;
    setState(() => _newsBlocks = filteredBlocks);
  }

  Future<void> _refreshData() async {
    if (mounted) setState(() => _aiFiltering = true);
    await ApiService.refreshData();
    if (mounted) setState(() => _aiFiltering = false);
    await _loadNewsForDate(_currentDate);
  }

  Future<void> _toggleScrap(NewsItem newsItem) async {
    final success = await ApiService.toggleScrap(newsItem);
    if (success && mounted) {
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
    if (!mounted) return;
    setState(() => _currentDate = newDate);
    _loadNewsForDate(_currentDate);
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

  // public 메서드로 변경 (SettingsTab에서 호출)
  void onTopicsChanged(Set<String> newTopics) {
    setState(() => _selectedTopics = newTopics);
    _loadNewsForDate(_currentDate);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
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
          if (_loading || _aiFiltering)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
