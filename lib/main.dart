import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const newsapp());
}

class newsapp extends StatelessWidget {
  const newsapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 249, 250),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF228BE6),
          unselectedItemColor: Color(0xFF495057),
        ),
      ),
      home: const Scaffold(
        body: Login(), // Login을 시작화면으로 설정
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn(BuildContext context) {
    String email = _emailController.text;
    String password = _passwordController.text;

    print('Email: $email, Password: $password');

    // TODO: 실제 서버 통신 또는 로컬 인증 로직 구현

    if (email == '' && password == '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디 또는 비밀번호가 올바르지 않습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        width: double.infinity,
        height: screenHeight * 1,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to continue',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF868E96),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _signIn(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF228BE6),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(color: Color(0xFF868E96), fontSize: 14),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // TODO: 회원가입 화면으로 이동 로직 구현
                    print('Register tapped');
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Color(0xFF228BE6), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
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
    // **TODO: 실제 서버 API 호출 및 데이터 파싱**

    // **임시 데이터 (서버 연동 전)**
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _newsBlocks = [
        NewsBlockData(
          title: '국내 정치',
          newsItems: [
            NewsItem(id: 'pol1-$formattedDate', title: '여야 대립 격화', date: date.add(const Duration(hours: 14, minutes: 40)), isScrapped: _scrappedNewsIds.contains('pol1-$formattedDate')),
            NewsItem(id: 'pol2-$formattedDate', title: '국회 본회의 예정', date: date.add(const Duration(hours: 9, minutes: 30)), isScrapped: _scrappedNewsIds.contains('pol2-$formattedDate')),
            NewsItem(id: 'pol3-$formattedDate', title: '새 정책 발표 임박', date: date.subtract(const Duration(days: 1, hours: 18, minutes: 15)), isScrapped: _scrappedNewsIds.contains('pol3-$formattedDate')),
          ],
        ),
        NewsBlockData(
          title: '미국',
          newsItems: [
            NewsItem(id: 'usa1-$formattedDate', title: '금리 인상 시사', date: date.add(const Duration(hours: 8, minutes: 34)), isScrapped: _scrappedNewsIds.contains('usa1-$formattedDate')),
            NewsItem(id: 'usa2-$formattedDate', title: '대통령 특별 연설', date: date.subtract(const Duration(days: 1, hours: 21)), isScrapped: _scrappedNewsIds.contains('usa2-$formattedDate')),
          ],
        ),
        NewsBlockData(
          title: '한국 경제',
          newsItems: [
            NewsItem(id: 'econ1-$formattedDate', title: '수출 지표 상승', date: date.add(const Duration(hours: 16, minutes: 5)), isScrapped: _scrappedNewsIds.contains('econ1-$formattedDate')),
          ],
        ),
      ];
    });
  }

  Future<void> _fetchScrappedNews() async {
    // **TODO: 서버에서 스크랩한 뉴스 ID 목록 가져오기**

    // **임시 데이터**
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _scrappedNewsIds = {'pol2-2025-04-24', 'econ1-2025-04-24'};
      // 초기 뉴스 데이터에 스크랩 상태 반영
      _newsBlocks = _newsBlocks.map((block) {
        return block.copyWith(
          newsItems: block.newsItems.map((item) {
            return item.copyWith(isScrapped: _scrappedNewsIds.contains(item.id));
          }).toList(),
        );
      }).toList();
    });
  }

  //   // **TODO: 서버 응답 JSON 파싱하여 NewsBlock 리스트 생성**

  Future<void> _toggleScrap(NewsItem newsItem) async {
    final isCurrentlyScrapped = _scrappedNewsIds.contains(newsItem.id);
    // **TODO: 서버에 스크랩 상태 업데이트 요청**

    setState(() {
      if (isCurrentlyScrapped) {
        _scrappedNewsIds.remove(newsItem.id);
      } else {
        _scrappedNewsIds.add(newsItem.id);
      }
      _newsBlocks = _newsBlocks.map((block) {
        return block.copyWith(
          newsItems: block.newsItems.map((item) {
            if (item.id == newsItem.id) {
              return item.copyWith(isScrapped: !isCurrentlyScrapped);
            }
            return item;
          }).toList(),
        );
      }).toList();
    });

    // **임시 (서버 연동 전)**
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      if (isCurrentlyScrapped) {
        _scrappedNewsIds.remove(newsItem.id);
      } else {
        _scrappedNewsIds.add(newsItem.id);
      }
      _newsBlocks = _newsBlocks.map((block) {
        return block.copyWith(
          newsItems: block.newsItems.map((item) {
            if (item.id == newsItem.id) {
              return item.copyWith(isScrapped: !isCurrentlyScrapped);
            }
            return item;
          }).toList(),
        );
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _fetchNewsForDate(_currentDate); // 홈 탭으로 돌아올 때 현재 날짜 뉴스 로드
    } else if (index == 1) {
      print('스크랩 탭');
    } else if (index == 2) {
      print('설정 탭');
    }
  }

  void _changeDate(int amount) {
    final newDate = _currentDate.add(Duration(days: amount));
    setState(() {
      _currentDate = newDate;
    });
    _fetchNewsForDate(_currentDate);
  }

  void _refreshData() {
    _fetchNewsForDate(_currentDate);
  }

  void _openMenu() {
    print('메뉴 열기');
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormatter = DateFormat('a h:mm', 'ko_KR');
    final String formattedDate = dateFormatter.format(_currentDate);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openMenu,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: () => _changeDate(-1),
            ),
            Text(formattedDate),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () => _changeDate(1),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: const Color(0xFFE9ECEF),
          ),
        ),
      ),
      body: _newsBlocks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    ..._newsBlocks.map((block) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x19000000),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Color(0x19000000),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  block.title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.50,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...block.newsItems.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title, // 서버에서 제공하는 제목 사용
                                              style: const TextStyle(
                                                color: Color(0xFF212529),
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.50,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            timeFormatter.format(item.date),
                                            style: const TextStyle(
                                              color: Color(0xFF868E96),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 1.50,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () => _toggleScrap(item),
                                            child: Icon(
                                              item.isScrapped ? Icons.bookmark : Icons.bookmark_border,
                                              color: item.isScrapped ? const Color(0xFFFF9800) : const Color(0xFF868E96),
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: '스크랩',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF228BE6),
        onTap: _onItemTapped,
      ),
    );
  }
}

class NewsBlockData {
  final String title;
  final List<NewsItem> newsItems;

  NewsBlockData({
    required this.title,
    required this.newsItems,
  });

  NewsBlockData copyWith({
    String? title,
    List<NewsItem>? newsItems,
  }) {
    return NewsBlockData(
      title: title ?? this.title,
      newsItems: newsItems ?? this.newsItems,
    );
  }
}

class NewsItem {
  final String id;
  final String title;
  final DateTime date;
  final bool isScrapped;

  NewsItem({
    required this.id,
    required this.title,
    required this.date,
    required this.isScrapped,
  });

  NewsItem copyWith({
    String? id,
    String? title,
    DateTime? date,
    bool? isScrapped,
  }) {
    return NewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isScrapped: isScrapped ?? this.isScrapped,
    );
  }
}