import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> _newssave(String newsurl) async {
  final saveUrl = Uri.http('127.0.0.1:8080', newsurl);
  final client = http.Client();
  try {
    final response = await client.get(saveUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] != true) {
        print('뉴스 데이터 저장 실패: ${data['message']}');
      }
    } else {
      print('서버 오류: ${response.statusCode}');
    }
  } catch (e) {
    print('에러 발생(news_save): $e');
  } finally {
    client.close();
  }
}

void _refreshData() async {
  await _newssave('/korea_news_save');
  await _newssave('/world_news_save');
  await _newssave('/economy_news_save');
  final filter = Uri.http('127.0.0.1:8080', '/ai_filter');
  final response = await http.get(filter);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  _refreshData();
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
  Set<String> _scrappedNews = {};

  @override
  void initState() {
    super.initState();
    _fetchNewsForDate(_currentDate);
  }

  Future<void> _fetchNewsForDate(DateTime date) async {
    setState(() {
      _newsBlocks = [];
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final newsUrl = Uri.http('127.0.0.1:8080', '/news', {
      'date': formattedDate,
    });

    try {
      final response = await http.get(newsUrl);

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
                  final String time = item['time'];
                  final bool isValid = item['isValid'];
                  final dynamic isScrappedValue = item['isScrapped'];
                  final bool isScrapped =
                      isScrappedValue == 1 || isScrappedValue == true;

                  final timeParts = time.split(':');
                  final String timeHM =
                      timeParts.length >= 2
                          ? '${timeParts[0]}:${timeParts[1]}'
                          : time;

                  return NewsItem(
                    category: category,
                    title: title,
                    summary: summary,
                    date: date,
                    isScrapped: isScrapped,
                    isValid: isValid,
                    time: timeHM,
                  );
                }).toList();

            blocks.add(NewsBlockData(title: category, newsItems: newsItems));
          }

          setState(() {
            _newsBlocks = blocks;
          });
        }
      } else {
        print('서버 오류(news): ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생(news): $e');
    }
  }

  Future<void> _toggleScrap(NewsItem newsItem) async {
    final newsUrl = Uri.http('127.0.0.1:8080', '/scrap');
    final body = jsonEncode({
      'date': DateFormat('yyyy-MM-dd').format(newsItem.date),
      'category': newsItem.category,
      'title': cleanTitle(newsItem.title),
      'summary': cleanTitle(newsItem.summary),
    });

    try {
      final response = await http.post(
        newsUrl,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          _newsBlocks =
              _newsBlocks.map((block) {
                if (block.title != newsItem.category) return block;
                final updatedItems =
                    block.newsItems.map((item) {
                      if (item.title != newsItem.title) return item;
                      return item.copyWith(isScrapped: !item.isScrapped);
                    }).toList();
                return block.copyWith(newsItems: updatedItems);
              }).toList();
        });
      } else {}
    } catch (e) {
      print('에러 발생(news): $e');
    }
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

  void _openMenu() {
    print('Opening menu...');
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
            onPressed: () {
              _refreshData();
              _fetchNewsForDate(_currentDate);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshData();
                _fetchNewsForDate(_currentDate);
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
                  final validNewsItems =
                      newsBlock.newsItems
                          .where((item) => item.isValid)
                          .toList();

                  if (validNewsItems.isNotEmpty) {
                    return NewsBlock(
                      newsBlock: newsBlock.copyWith(newsItems: validNewsItems),
                      onToggleScrap: (newsItem) => _toggleScrap(newsItem),
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

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Set<NewsBias> _selectedBiases = {};
  Set<String> _selectedTopics = {};

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
          _NewsBiasSection(
            selectedBiases: _selectedBiases,
            onBiasesChanged: (newBiases) {
              setState(() {
                _selectedBiases = newBiases;
              });
            },
          ),
          const SizedBox(height: 24),
          _NewsCompanySection(),
          const SizedBox(height: 24),
          _NewsTopicSection(
            selectedTopics: _selectedTopics,
            onTopicSelected: (topic, isSelected) {
              setState(() {
                if (isSelected) {
                  _selectedTopics.add(topic);
                } else {
                  _selectedTopics.remove(topic);
                }
              });
            },
          ),
          const SizedBox(height: 24),
          const _KeywordSection(),
        ],
      ),
    );
  }
}

class _NewsBiasSection extends StatefulWidget {
  final Set<NewsBias> selectedBiases;
  final ValueChanged<Set<NewsBias>> onBiasesChanged;

  const _NewsBiasSection({
    required this.selectedBiases,
    required this.onBiasesChanged,
  });

  @override
  State<_NewsBiasSection> createState() => _NewsBiasSectionState();
}

class _NewsBiasSectionState extends State<_NewsBiasSection> {
  late Set<NewsBias> _selectedBiases;

  @override
  void initState() {
    super.initState();
    _selectedBiases = Set.from(widget.selectedBiases);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '뉴스 성향',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  NewsBias.values.map((bias) {
                    final isSelected = _selectedBiases.contains(bias);
                    return ChoiceChip(
                      backgroundColor: const Color(0xFFF8F9FA),
                      label: Text(bias.label),
                      selected: isSelected,
                      selectedColor: const Color(0xFF228BE6),
                      labelStyle: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFF868E96),
                      ),
                      avatar:
                          isSelected
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                      onSelected: (_) {
                        setState(() {
                          if (isSelected) {
                            _selectedBiases.remove(bias);
                          } else {
                            _selectedBiases.add(bias);
                          }
                          widget.onBiasesChanged(_selectedBiases);
                        });
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

enum NewsBias {
  neutral('중도'),
  progressive('진보'),
  conservative('보수');

  const NewsBias(this.label);
  final String label;
}

class _NewsCompanySection extends StatefulWidget {
  const _NewsCompanySection({super.key});

  @override
  State<_NewsCompanySection> createState() => _NewsCompanySectionState();
}

class _NewsCompanySectionState extends State<_NewsCompanySection> {
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

class _NewsTopicSection extends StatefulWidget {
  final Set<String> selectedTopics;
  final Function(String topic, bool isSelected) onTopicSelected;

  const _NewsTopicSection({
    required this.selectedTopics,
    required this.onTopicSelected,
  });

  @override
  State<_NewsTopicSection> createState() => _NewsTopicSectionState();
}

class _NewsTopicSectionState extends State<_NewsTopicSection> {
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
    '-----',
    '중앙일보',
    '동아일보',
    '조선일보',
    '매일경제',
    '한국경제',
    '서울경제',
    '머니투데이',
    '아시아경제',
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

class _KeywordSection extends StatefulWidget {
  const _KeywordSection({super.key});

  @override
  State<_KeywordSection> createState() => _KeywordSectionState();
}

class _KeywordSectionState extends State<_KeywordSection> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _keywords = ['달러', '금리', '부동산'];
  bool _isExpanded = false;

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
            child:
                _isExpanded
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
                            children:
                                _keywords
                                    .map(
                                      (keyword) => _buildKeywordChip(keyword),
                                    )
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

  void _addKeyword() {
    if (_controller.text.isNotEmpty && !_keywords.contains(_controller.text)) {
      setState(() => _keywords.add(_controller.text));
      _controller.clear();
    }
  }

  void _removeKeyword(String text) {
    setState(() => _keywords.remove(text));
  }
}

class NewsCompany {
  final String name;
  final String bias;
  NewsCompany(this.name, this.bias);
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
  final String category;
  final String title;
  final String summary;
  final String time;
  final DateTime date;
  final bool isScrapped;
  final bool isValid;

  NewsItem({
    required this.category,
    required this.title,
    required this.summary,
    required this.date,
    required this.isScrapped,
    required this.time,
    required this.isValid,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      date: DateTime.parse(json['date']),
      category: json['category'] ?? '',
      isScrapped: json['isScrapped'] == 1 || json['isScrapped'] == true,
      time: json['time'] ?? '',
      isValid: json['isValid'] ?? false,
    );
  }

  NewsItem copyWith({
    String? category,
    String? title,
    String? summary,
    String? time,
    DateTime? date,
    bool? isScrapped,
    bool? isValid,
  }) {
    return NewsItem(
      category: category ?? this.category,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      time: time ?? this.time,
      date: date ?? this.date,
      isScrapped: isScrapped ?? this.isScrapped,
      isValid: isValid ?? this.isValid,
    );
  }
}

class ScrapTabWidget extends StatefulWidget {
  const ScrapTabWidget({Key? key}) : super(key: key);

  @override
  State<ScrapTabWidget> createState() => _ScrapTabWidgetState();
}

class _ScrapTabWidgetState extends State<ScrapTabWidget> {
  Map<String, List<NewsItem>> _scrappedNews = {};
  final Map<String, bool> _expandedDates = {};

  @override
  void initState() {
    super.initState();
    _fetchScrappedNews();
  }

  static Future<List<NewsItem>> fetchScrappedNews() async {
    final newsUrl = Uri.http('127.0.0.1:8080', '/bring_scrap');
    final response = await http.get(newsUrl);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => NewsItem.fromJson(e)).toList();
    }
    throw Exception('에러 발생(news)');
  }

  Future<void> _fetchScrappedNews() async {
    try {
      final response = await fetchScrappedNews();

      final Map<String, List<NewsItem>> groupedNews = {};

      for (var item in response) {
        final dateStr = DateFormat('yyyy-MM-dd').format(item.date);
        groupedNews.putIfAbsent(dateStr, () => []).add(item);
      }

      setState(() {
        _scrappedNews = groupedNews;
      });
    } catch (e) {
      print('스크랩 뉴스 불러오기 실패: $e');
    }
  }

  void _toggleDateExpansion(String date) {
    setState(() {
      _expandedDates[date] = !(_expandedDates[date] ?? false);
    });
  }

  Future<void> _handleScrapToggle(NewsItem item) async {
    final newsUrl = Uri.http('127.0.0.1:8080', '/scrap');
    final body = jsonEncode({
      'date': DateFormat('yyyy-MM-dd').format(item.date),
      'category': item.category,
      'title': cleanTitle(item.title),
      'summary': cleanTitle(item.summary),
      'isScrapped': item.isScrapped ? 1 : 0,
    });
    print('보내는 JSON: $body');
    print('스크랩 상태: ${item.isScrapped}');
    try {
      final response = await http.post(
        newsUrl,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print('응답 상태코드: ${response.statusCode}');
      print('응답 내용: ${response.body}');
      if (response.statusCode == 200) {
        await _fetchScrappedNews();
      } else {
        print('스크랩 상태 변경 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('스크랩 상태 변경 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateKeys =
        _scrappedNews.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8.0),
            Text(
              '스크랩',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8.0),
          ],
        ),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: _openMenu),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchScrappedNews();
            },
          ),
        ],
      ),
      body:
          _scrappedNews.isEmpty
              ? const Center(child: Text('스크랩한 뉴스가 없습니다'))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: dateKeys.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final date = dateKeys[index];
                  final items = _scrappedNews[date]!;
                  final isExpanded = _expandedDates[date] ?? false;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat(
                                  'yyyy년 MM월 dd일 (E)',
                                  'ko_KR',
                                ).format(DateTime.parse(date)),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                ),
                                onPressed: () => _toggleDateExpansion(date),
                              ),
                            ],
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child:
                              isExpanded
                                  ? Column(
                                    children:
                                        items
                                            .map(
                                              (item) => NewsItemTile(
                                                newsItem: item,
                                                onToggleScrap:
                                                    _handleScrapToggle,
                                              ),
                                            )
                                            .toList(),
                                  )
                                  : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  void _openMenu() {
    print('Opening menu from ScrapTab...');
  }

  void _refreshData() {
    _fetchScrappedNews();
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

String cleanTitle(String title) {
  return title.replaceAll('\n', '').replaceAll('\"', '').trim();
}
