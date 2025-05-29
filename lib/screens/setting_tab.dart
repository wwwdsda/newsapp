import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../widgets/news_bias_section.dart';
import '../widgets/news_topic_section.dart';
import '../widgets/keyword_section.dart';

class SettingsTab extends StatefulWidget {
  final ValueChanged<Set<String>>? onTopicsChanged;
  const SettingsTab({super.key, this.onTopicsChanged});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Set<String> _selectedBiases = {};
  Set<String> _selectedTopics = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialPreferences();
  }

  Future<void> _loadInitialPreferences() async {
    try {
      final fetchedBiases = await ApiService.fetchUserBiases();
      final fetchedTopics = await ApiService.fetchUserTopics();
      setState(() {
        _selectedBiases = fetchedBiases;
        _selectedTopics = fetchedTopics;
        _loading = false;
      });
    } catch (e) {
      debugPrint('설정 불러오기 실패: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _updateBiases(Set<String> newBiases) async {
    setState(() => _selectedBiases = newBiases);
    try {
      await ApiService.saveUserBias(newBiases);
    } catch (e) {
      debugPrint('성향 저장 실패: $e');
    }
  }

  Future<void> _updateTopics(Set<String> newTopics) async {
    setState(() => _selectedTopics = newTopics);
    try {
      await ApiService.saveUserTopics(newTopics);
      widget.onTopicsChanged?.call(newTopics); // HomeTab에 알림!
    } catch (e) {
      debugPrint('주제 저장 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NewsBiasSection(
            selectedBiases: _selectedBiases,
            onBiasesChanged: _updateBiases,
          ),
          const SizedBox(height: 24),
          NewsTopicSection(
            selectedTopics: _selectedTopics,
            onTopicsChanged: _updateTopics,
          ),
          const SizedBox(height: 24),
          const KeywordSection(),
        ],
      ),
    );
  }
}
