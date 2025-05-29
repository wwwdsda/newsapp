import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'scrap_tab.dart';
import 'setting_tab.dart';

class HomeScreen extends StatefulWidget {
  final bool runAiFilterOnStart;
  const HomeScreen({Key? key, this.runAiFilterOnStart = false}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  late final GlobalKey<HomeTabState> _homeTabKey;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _homeTabKey = GlobalKey<HomeTabState>();
    _widgetOptions = <Widget>[
      HomeTab(
        key: _homeTabKey,
        runAiFilterOnStart: widget.runAiFilterOnStart,
      ),
      const ScrapTab(),
      SettingsTab(
        onTopicsChanged: (topics) {
          _homeTabKey.currentState?.onTopicsChanged(topics);
        },
      ),
    ];
  }

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
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: '스크랩'),
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
