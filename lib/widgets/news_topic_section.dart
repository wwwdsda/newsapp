import 'package:flutter/material.dart';

const List<String> allTopics = [
  '한국', '해외', '경제', '과학/기술', '엔터테인먼트', '스포츠',
];

class NewsTopicSection extends StatefulWidget {
  final Set<String> selectedTopics;
  final ValueChanged<Set<String>> onTopicsChanged;

  const NewsTopicSection({
    Key? key,
    required this.selectedTopics,
    required this.onTopicsChanged,
  }) : super(key: key);

  @override
  State<NewsTopicSection> createState() => _NewsTopicSectionState();
}

class _NewsTopicSectionState extends State<NewsTopicSection> {
  late Set<String> _selectedTopics;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedTopics = Set.from(widget.selectedTopics);
  }

  @override
  void didUpdateWidget(covariant NewsTopicSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTopics != widget.selectedTopics) {
      setState(() {
        _selectedTopics = Set.from(widget.selectedTopics);
      });
    }
  }

  Future<void> _onChipSelected(String topic, bool isSelected) async {
    setState(() {
      if (isSelected) {
        _selectedTopics.remove(topic);
      } else {
        _selectedTopics.add(topic);
      }
      _isSaving = true;
    });
    widget.onTopicsChanged(_selectedTopics.toSet());
    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '주제 즐겨찾기',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                if (_isSaving)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allTopics.map((topic) {
                final isSelected = _selectedTopics.contains(topic);
                return FilterChip(
                  label: Text(
                    topic,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : const Color(0xFF868E96),
                    ),
                  ),
                  selected: isSelected,
                  showCheckmark: false,
                  backgroundColor: const Color(0xFFF8F9FA),
                  selectedColor: const Color(0xFF228BE6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Color(0xFFDDE2E6)),
                  onSelected: (bool selected) => _onChipSelected(topic, isSelected),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
