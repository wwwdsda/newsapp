import 'package:flutter/material.dart';


class NewsCompany {
  final String name;
  final String bias;
  NewsCompany(this.name, this.bias);
}

class NewsCompanySection extends StatefulWidget {
  const NewsCompanySection({super.key});

  @override
  State<NewsCompanySection> createState() => NewsCompanySectionState();
}

class NewsCompanySectionState extends State<NewsCompanySection> {
  final List<NewsCompany> allCompanies = [
    NewsCompany('MBC', '진보'),
    NewsCompany('JTBC', '진보'),
    NewsCompany('KBS', '중도, 친정부'),
    NewsCompany('SBS', '중도'),
    NewsCompany('YTN', '-'),
    NewsCompany('Channel A', '-'),
    NewsCompany('TV Chosun', '-'),
    NewsCompany('News1', '-'),
    NewsCompany('연합뉴스', '-'),
    NewsCompany('뉴시스', '-'),
    NewsCompany('한겨레', '-'),
    NewsCompany('경향신문', '-'),
    NewsCompany('중앙일보', '중도'),
    NewsCompany('동아일보', '보수'),
    NewsCompany('조선일보', '보수'),
    NewsCompany('매일경제', '중도'),
    NewsCompany('한국경제', '중도'),
    NewsCompany('서울경제', '중도'),
    NewsCompany('머니투데이', '중도'),
    NewsCompany('아시아경제', '중도'),
  ];
  Set<int> _selectedIndexes = {0, 1, 2, 3, 4}; // 예시로 상위 5개 기본 선택

  void _showCompanySelectDialog() async {
    final result = await showDialog<Set<int>>(
      context: context,
      builder: (context) {
        Set<int> tempSelected = {..._selectedIndexes};
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '관심 뉴스사',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(tempSelected),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: allCompanies.length,
                itemBuilder: (context, idx) {
                  final company = allCompanies[idx];
                  return CheckboxListTile(
                    value: tempSelected.contains(idx),
                    onChanged: (checked) {
                      (context as Element).markNeedsBuild();
                      if (checked == true) {
                        tempSelected.add(idx);
                      } else {
                        tempSelected.remove(idx);
                      }
                    },
                    title: Row(
                      children: [
                        Text(
                          company.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          company.bias,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF868E96),
                          ),
                        ),
                      ],
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: const Color(0xFF228BE6),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(tempSelected),
              child: const Text(
                '확인',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _selectedIndexes = result;
      });
    }
  }

  void _removeSelectedItem(int indexToRemove) {
    setState(() {
      _selectedIndexes.remove(indexToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndicesList = _selectedIndexes.toList();
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '관심 뉴스사',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: _showCompanySelectDialog,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF228BE6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '변경',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  selectedIndicesList.map((index) {
                    final companyName = allCompanies[index].name;
                    return InputChip(
                      backgroundColor: const Color(0xFFF8F9FA),
                      label: Text(companyName),
                      onDeleted: () => _removeSelectedItem(index),
                      deleteIcon: const Icon(Icons.close, size: 18),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
