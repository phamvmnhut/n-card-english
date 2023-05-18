import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:n_card_english/components/english_card.dart';
import 'package:n_card_english/models/english_today.dart';
import 'package:n_card_english/pages/all_word_page.dart';
import 'package:n_card_english/pages/control_page.dart';
import 'package:n_card_english/pages/favorites_page.dart';
import 'package:n_card_english/values/app_colors.dart';
import 'package:n_card_english/values/app_styles.dart';
import 'package:n_card_english/values/share_keys.dart';
import 'package:n_card_english/widgets/app_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];

  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random rand = Random();
    int count = 1;
    while (count < len) {
      int val = rand.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(ShareKeys.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRandom(len: len + 1, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    setState(() {
      words = newList.map((e) => EnglishToday(noun: e, id: e)).toList();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LikeButtonState> _likeButtonKey =
      GlobalKey<LikeButtonState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "English today",
          style: AppStyles.h3.copyWith(color: AppColors.priColor),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(
            Icons.menu_open,
            size: 35,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: size.height * 1 / 10,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Text(
                '"It is amazing how complete is the delusion that beauty is goodness."',
                style: AppStyles.h5,
              ),
            ),
            SizedBox(
              height: size.height * 2 / 3,
              child: PageView.builder(
                itemCount: words.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  EnglishToday word = words[index];
                  return EnglishCard(
                      english_today: word,
                      onFavoriteClick: () {
                        setState(() {
                          words[index].isFavorite = !words[index].isFavorite;
                        });
                      },);
                },
              ),
            ),
            // indicator
            SizedBox(
              height: size.height * 1 / 10,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 24),
                height: 0,
                child: _currentIndex > 4
                    ? buildShowMore()
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return buildIndicator(index == _currentIndex, size);
                        },
                      ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.priColor,
        onPressed: () {
          getEnglishToday();
        },
        child: const Icon(Icons.refresh_sharp),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 1 / 10,
              ),
              Text(
                "Your mind",
                style: AppStyles.h4.copyWith(color: AppColors.priColor),
              ),
              SizedBox(
                height: size.height * 1 / 40,
              ),
              AppButton(
                label: "Favorites",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FavoritesPage()));
                },
              ),
              SizedBox(
                height: size.height * 1 / 20,
              ),
              AppButton(
                label: "Your control",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ControlPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
      height: 24,
      width: isActive ? size.width * 1 / 5 : 36,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.priColor : AppColors.secondColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(2, 3), blurRadius: 4)
        ],
      ),
    );
  }

  Widget buildShowMore() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: AppColors.secondColor,
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllWordPage(
                          words: words,
                        )));
          },
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Show more",
              style: AppStyles.h5.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
