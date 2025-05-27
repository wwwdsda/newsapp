import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../utils/globals.dart';

class KeywordSection extends StatefulWidget {
  const KeywordSection({super.key});

  @override
  State<KeywordSection> createState() => KeywordSectionState();
}

class KeywordSectionState extends State<KeywordSection> {
  final TextEditingController _controller = TextEditingController();
  List<String> _keywords = [];
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadKeywords();
  }

  Future<void> _loadKeywords() async {
  final keywords = await ApiService.loadKeywords(
    id: userid,
    password: userpassword,
  );
  setState(() {
    _keywords = keywords;
  });
}

Future<void> _addKeyword() async {
  final keyword = _controller.text.trim();
  if (keyword.isEmpty || _keywords.contains(keyword)) return;

  final success = await ApiService.addKeyword(
    id: userid,
    password: userpassword,
    keyword: keyword,
  );
  if (success) {
    setState(() {
      _keywords.add(keyword);
      _controller.clear();
    });
  }
}

Future<void> _removeKeyword(String keyword) async {
  final success = await ApiService.removeKeyword(
    id: userid,
    password: userpassword,
    keyword: keyword,
  );
  if (success) {
    setState(() {
      _keywords.remove(keyword);
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '키워드 관리',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: '키워드를 입력하세요',
                            suffixIcon: ElevatedButton(
                              onPressed: _addKeyword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF228BE6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '추가',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _keywords
                              .map((keyword) => _buildKeywordChip(keyword))
                              .toList(),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordChip(String text) {
    return InputChip(
      label: Text(text),
      backgroundColor: const Color(0xFFF8F9FA),
      onDeleted: () => _removeKeyword(text),
      deleteIcon: const Icon(Icons.close, size: 18),
    );
  }
}

