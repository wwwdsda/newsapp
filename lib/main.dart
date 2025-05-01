import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
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
        body: Login(),
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

    // TODO: 실제 서버에서 아이디 비밀번호 확인하기

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

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Container(
          width: double.infinity,
          height: screenHeight * 0.8, 
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 3,
                offset: Offset(0, 1),
                ),
            ],
          ),
          child: SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?',
                    style: TextStyle(color: Color(0xFF868E96), fontSize: 14),),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Register',
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
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _createAccount() {
    final userData = {
      "fullName": _fullNameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "confirmPassword": _confirmPasswordController.text,
    };

    // TODO: 이 데이터 서버로 보내기
    print("Create Account: $userData");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign up to get started',
                  style: TextStyle(
                    color: Color(0xFF868E96),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _createAccount,
                    child: const Text('Create Account'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        'Sign In',
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
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), 
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
    // TODO: 서버에서 날짜에 해당하는 뉴스 데이터 가져오기

    // 임시 데이터
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
    // TODO: 서버에서 스크랩된 뉴스 ID 가져오기

    // 임시 데이터
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

  Future<void> _toggleScrap(NewsItem newsItem) async {
    final isCurrentlyScrapped = _scrappedNewsIds.contains(newsItem.id);
    // TODO: 서버에 스크랩 상태 업데이트 요청

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

    // 임시 (서버 연동 전)
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

  void _openMenu() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 뉴스'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openMenu,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => _changeDate(-1),
                ),
                Text(
                  DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_currentDate),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => _changeDate(1),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshData();
              },
              child: ListView.separated(
                itemCount: _newsBlocks.length,
                separatorBuilder: (context, index) => const Divider(height: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemBuilder: (context, index) {
                  final newsBlock = _newsBlocks[index];
                  return NewsBlock(newsBlock: newsBlock, onToggleScrap: _toggleScrap);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          newsBlock.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ...newsBlock.newsItems.map((item) => NewsItemTile(newsItem: item, onToggleScrap: onToggleScrap)).toList(),
      ],
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              icon: Icon(newsItem.isScrapped ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => onToggleScrap(newsItem),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('설정 화면'),
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

class ScrapTabWidget extends StatefulWidget {
  const ScrapTabWidget({Key? key}) : super(key: key);

  @override
  State<ScrapTabWidget> createState() => _ScrapTabWidgetState();
}

class _ScrapTabWidgetState extends State<ScrapTabWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('스크랩 화면'),
    );
  }
}