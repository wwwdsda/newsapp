import 'package:flutter/material.dart';


class NewsTopicSection extends StatefulWidget {
  final Set<String> selectedTopics;
  final Function(String topic, bool isSelected) onTopicSelected;

  const NewsTopicSection({
    required this.selectedTopics,
    required this.onTopicSelected,
  });

  @override
  State<NewsTopicSection> createState() => NewsTopicSectionState();
}

class NewsTopicSectionState extends State<NewsTopicSection> {
  final List<String> allTopics = [
    '국내 정치, 사회',
    '미국',
    '중국, 대만',
    '유럽',
    '한국 경제',
    '연예',
    '건강',
    '스포츠',
    '해외 축구',
    '테크',
    '게임',
  ];

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '주제 즐겨찾기',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  allTopics.map((topic) {
                    final isSelected = widget.selectedTopics.contains(topic);
                    return FilterChip(
                      label: Text(topic, style: const TextStyle(fontSize: 14)),
                      selected: isSelected,
                      showCheckmark: false, // 체크마크 숨김
                      backgroundColor: const Color(0xFFF8F9FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Color(0xFFDDE2E6)),
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      onSelected: (bool selected) {
                        widget.onTopicSelected(topic, selected);
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

