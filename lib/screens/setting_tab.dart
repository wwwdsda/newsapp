import 'package:flutter/material.dart';

import '../utils/globals.dart';
import '../model/news_item.dart';
import '../service/api_service.dart';
import '../widgets/news_bias_section.dart';
import '../widgets/news_topic_section.dart';
import '../widgets/keyword_section.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final ApiService apiService = ApiService();


  Set<String> _selectedBiases = {};
  Set<String> _selectedTopics = {};

  @override
  void initState() {
    super.initState();
    _loadInitialBiases();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialBiases();
  }

  Future<void> _loadInitialBiases() async {
    try {
      final fetched = await ApiService.fetchUserBiases();
      setState(() {
        _selectedBiases = fetched;
      });
    } catch (e) {
      debugPrint('뉴스 성향 로딩 실패: $e');
    }
  }

  void _updateBiases(Set<String> newBiases) {
    final before = _selectedBiases;

    setState(() {
      _selectedBiases = newBiases;
    });

    final added = newBiases.difference(before);
    final removed = before.difference(newBiases);

    for (final bias in added) {
      ApiService.addUserBias(bias);
    }
    for (final bias in removed) {
      ApiService.deleteUserBias(bias);
    }
  }

  void _updateTopics(String topic, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedTopics.add(topic);
      } else {
        _selectedTopics.remove(topic);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            onTopicSelected: _updateTopics,
          ),
          const SizedBox(height: 24),
          const KeywordSection(),
        ],
      ),
    );
  }
}
