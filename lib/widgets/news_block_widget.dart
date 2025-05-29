import '../model/news_item.dart';
import 'summary_popup.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../service/api_service.dart';

class NewsBlockData {
  final String title;
  final List<NewsItem> newsItems;

  NewsBlockData({required this.title, required this.newsItems});

  NewsBlockData copyWith({String? title, List<NewsItem>? newsItems}) {
    return NewsBlockData(
      title: title ?? this.title,
      newsItems: newsItems ?? this.newsItems,
    );
  }
}

class NewsBlock extends StatefulWidget {
  const NewsBlock({
    Key? key,
    required this.newsBlock,
    required this.onToggleScrap,
  }) : super(key: key);

  final NewsBlockData newsBlock;
  final Function(NewsItem) onToggleScrap;

  @override
  State<NewsBlock> createState() => _NewsBlockState();
}

class _NewsBlockState extends State<NewsBlock> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 13.0, top: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.newsBlock.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
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
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  _isExpanded
                      ? widget.newsBlock.newsItems
                          .map(
                            (item) => NewsItemTile(
                              newsItem: item,
                              onToggleScrap: widget.onToggleScrap,
                            ),
                          )
                          .toList()
                      : widget.newsBlock.newsItems
                          .take(3)
                          .map(
                            (item) => NewsItemTile(
                              newsItem: item,
                              onToggleScrap: widget.onToggleScrap,
                            ),
                          )
                          .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsItemTile extends StatelessWidget {
  const NewsItemTile({
    Key? key,
    required this.newsItem,
    required this.onToggleScrap,
  }) : super(key: key);

  final NewsItem newsItem;
  final Function(NewsItem) onToggleScrap;

Future<String> _getSummary(BuildContext context) async {
  final currentSummary = newsItem.summary ?? '';
  if (currentSummary.startsWith('https://news.google.com')) {
    final fetchedSummary = await ApiService.fetchSummaryFromServer(newsItem.title);
    newsItem.summary = fetchedSummary;
    return fetchedSummary;
  } else {
    return currentSummary;
  }
}



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final future = _getSummary(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FutureBuilder<String>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return SummeryPopup(
                    title: newsItem.title,
                    content: '요약을 불러오는 중 오류가 발생했습니다: ${snapshot.error}',
                  );
                }
                return SummeryPopup(
                  title: newsItem.title,
                  content: snapshot.data ?? '요약을 불러올 수 없습니다.',
                );
              },
            );
          },
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem.title,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      newsItem.time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  newsItem.isScrapped ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () => {onToggleScrap(newsItem)},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
