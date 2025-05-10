import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), // 여기에 배경색 설정
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn(BuildContext context) async {
    final id = _emailController.text;
    final password = _passwordController.text;

    final url = Uri.http('127.0.0.1:8080', '/login');
    final client = http.Client();

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(data['message'] ?? '로그인 실패')));
        }
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'] ?? '로그인 실패')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('서버 연결 실패: $e')));
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 70),
                const Text(
                  '오늘의 뉴스',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '시작하려면 로그인 하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF868E96),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFE9ECEF),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: '아이디',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Color(0xFF999999)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFE9ECEF),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: '비밀번호',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Color(0xFF999999)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _signIn(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF228BE6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '아직 아이디가 없나요?',
                      style: TextStyle(color: Color(0xFF868E96), fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF228BE6),
                      ),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _createAccount() async {
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 필드를 입력해주세요.')));
      return;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    } else {
      final userData = {
        "이름": _fullNameController.text,
        "아이디": _emailController.text,
        "비밀번호": _passwordController.text,
      };

      final url = Uri.http('127.0.0.1:8080', '/register');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(userData);

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('계정이 성공적으로 생성되었습니다.')));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        } else {
          final responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? '회원가입에 실패했습니다.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('서버 연결에 실패했습니다: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Container(
            height: screenHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                const Text(
                  '회원가입',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '아이디를 만들고 시작하세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF868E96),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 32),

                // 이름 입력 필드
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFE9ECEF),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _fullNameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: '이름',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Color(0xFF999999)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 아이디 입력 필드
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFE9ECEF),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: '아이디',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Color(0xFF999999)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFE9ECEF),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: '비밀번호',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Color(0xFF999999)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 비밀번호 확인 입력 필드
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFE9ECEF),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: '비밀번호 재입력',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Color(0xFF999999)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 계정 생성 버튼
                ElevatedButton(
                  onPressed: _createAccount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF228BE6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '계정 생성',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 로그인 텍스트 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '이미 아이디가 있으신가요?',
                      style: TextStyle(color: Color(0xFF868E96), fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF228BE6),
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const ScrapTabWidget(),
    const SettingsTab(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openMenu() {
    print('메뉴 열기');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: '스크랩',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF228BE6),
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DateTime _currentDate = DateTime.now();
  List<NewsBlockData> _newsBlocks = [];
  Set<String> _scrappedNewsIds = {};

  @override
  void initState() {
    super.initState();
    _fetchNewsForDate(_currentDate);
    _fetchScrappedNews();
  }

  Future<void> _fetchNewsForDate(DateTime date) async {
    setState(() {
      _newsBlocks = [];
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final url = Uri.http('127.0.0.1:8080', '/news', {'date': formattedDate});

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['news'] != null) {
          final Map<String, dynamic> newsMap = Map<String, dynamic>.from(
            data['news'],
          );
          final List<NewsBlockData> blocks = [];

          for (final entry in newsMap.entries) {
            final String category = entry.key;
            final List<dynamic> items = entry.value;

            final List<NewsItem> newsItems =
                items.map((item) {
                  final String title = item['title'];
                  final String summary = item['summary'];
                  final dynamic isScrappedValue = item['isScrapped'];
                  final bool isScrapped = isScrappedValue == 1;

                  return NewsItem(
                    id: '${category}_$title\_$formattedDate',
                    title: title,
                    summary: summary,
                    date: date,
                    isScrapped: isScrapped,
                  );
                }).toList();

            blocks.add(NewsBlockData(title: category, newsItems: newsItems));
          }

          setState(() {
            _newsBlocks = blocks;
          });
        } 
      } 
    } catch (e) {
      
    }
  }

  Future<void> _fetchScrappedNews() async {
    // TODO: 서버에서 스크랩된 뉴스 ID 가져오기

    // 임시 데이터
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _scrappedNewsIds = {'pol2-2025-04-24', 'econ1-2025-04-24'};
      // 초기 뉴스 데이터에 스크랩 상태 반영
      _newsBlocks =
          _newsBlocks.map((block) {
            return block.copyWith(
              newsItems:
                  block.newsItems.map((item) {
                    return item.copyWith(
                      isScrapped: _scrappedNewsIds.contains(item.id),
                    );
                  }).toList(),
            );
          }).toList();
    });
  }

Future<void> _toggleScrap(NewsItem newsItem) async {
  setState(() {
    if (_scrappedNewsIds.contains(newsItem.id)) {
      _scrappedNewsIds.remove(newsItem.id);
    } else {
      _scrappedNewsIds.add(newsItem.id);
    }

    _newsBlocks = _newsBlocks.map((block) {
      return block.copyWith(
        newsItems: block.newsItems.map((item) {
          if (item.id == newsItem.id) {
            return item.copyWith(isScrapped: _scrappedNewsIds.contains(item.id));
          }
          return item;
        }).toList(),
      );
    }).toList();
  });
}


  void _changeDate(int amount) {
    final newDate = _currentDate.add(Duration(days: amount));
    final today = DateTime.now();
    if (newDate.isAfter(DateTime(today.year, today.month, today.day + 1))) {
      return;
    }
    setState(() {
      _currentDate = newDate;
    });
    _fetchNewsForDate(_currentDate);
  }

  void _refreshData() {
    _fetchNewsForDate(_currentDate);
  }

  void _openMenu() {}

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
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshData();
              },
              child: ListView.separated(
                itemCount: _newsBlocks.length,
                separatorBuilder: (context, index) => const Divider(height: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                itemBuilder: (context, index) {
                  final newsBlock = _newsBlocks[index];
                  return NewsBlock(
                    newsBlock: newsBlock,
                    onToggleScrap: _toggleScrap,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsBlock extends StatelessWidget {
  const NewsBlock({
    Key? key,
    required this.newsBlock,
    required this.onToggleScrap,
  }) : super(key: key);

  final NewsBlockData newsBlock;
  final Function(NewsItem) onToggleScrap;

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
            child: Text(
              newsBlock.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          ...newsBlock.newsItems
              .map(
                (item) =>
                    NewsItemTile(newsItem: item, onToggleScrap: onToggleScrap),
              )
              .toList(),
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SummeryPopup(
              title: newsItem.title,
              content: newsItem.summary ?? '',
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
                      DateFormat('HH:mm').format(newsItem.date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  newsItem.isScrapped ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () => onToggleScrap(newsItem),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('설정 화면'));
  }
}

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

class NewsItem {
  final String id;
  final String title;
  final String summary;
  final DateTime date;
  final bool isScrapped;

  NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.date,
    required this.isScrapped,
  });

  NewsItem copyWith({
    String? id,
    String? title,
    String? summary,
    DateTime? date,
    bool? isScrapped,
  }) {
    return NewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      date: date ?? this.date,
      isScrapped: isScrapped ?? this.isScrapped,
    );
  }
}

class ScrapTabWidget extends StatefulWidget {
  const ScrapTabWidget({Key? key}) : super(key: key);

  @override
  State<ScrapTabWidget> createState() => _ScrapTabWidgetState();
}

class _ScrapTabWidgetState extends State<ScrapTabWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('스크랩 화면'));
  }
}

class SummeryPopup extends StatelessWidget {
  final String title;
  final String content;

  const SummeryPopup({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
