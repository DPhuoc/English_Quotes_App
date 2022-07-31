import 'dart:math';
import 'package:english_memory_app/package/quote/quote.dart';
import 'package:english_memory_app/package/quote/quote_model.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:english_memory_app/values/app_assets.dart';
import 'package:english_memory_app/values/app_colors.dart';
import 'package:english_memory_app/values/app_styles.dart';
import 'package:english_memory_app/models/english_today.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];

  String quote = Quotes().getRandom().content!;

  List<int> fixedListRamdom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() {
    List<String> newList = [];
    List<int> rans = fixedListRamdom(len: 5, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    words = newList.map((word) {
      return getQuote(word);
    }).toList();
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(noun: noun, quote: quote?.content, id: quote?.id);
  }

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    getEnglishToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        elevation: 0,
        title: Text('English today', style: AppStyles.h4.copyWith(color: AppColors.textColor, fontSize: 36)),
        leading: InkWell(
          onTap: () {},
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                height: size.height * 1 / 10,
                alignment: Alignment.centerLeft,
                child: Text('"$quote"',
                    style: AppStyles.h5.copyWith(
                      fontSize: 15,
                      color: AppColors.textColor,
                    ))),
            Container(
              height: size.height * 2 / 3,
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    String firstLetter = words[index].noun ?? '';
                    firstLetter = firstLetter.substring(0, 1);

                    String leftLetter = words[index].noun ?? '';
                    leftLetter = leftLetter.substring(1, leftLetter.length);

                    String quoteDefault = 'Think of all the beauty still left around you and be happy';
                    String quote = words[index].quote ?? quoteDefault;

                    return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackGray,
                              blurRadius: 6,
                              offset: Offset(3, 6),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Image.asset(AppAssets.heart),
                            ),
                            RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: firstLetter.toUpperCase(),
                                    style: const TextStyle(fontFamily: FontFamily.sen, fontSize: 89, fontWeight: FontWeight.bold, shadows: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                      )
                                    ]),
                                    children: [
                                      TextSpan(
                                        text: leftLetter,
                                        style: const TextStyle(fontFamily: FontFamily.sen, fontSize: 56, fontWeight: FontWeight.bold, shadows: []),
                                      )
                                    ])),
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Text('"$quote"',
                                  style: AppStyles.h4.copyWith(
                                    letterSpacing: 1,
                                    color: AppColors.textColor,
                                  )),
                            )
                          ],
                        ));
                  }),
            ),
            SizedBox(
              height: size.height * 1 / 12,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                alignment: Alignment.center,
                child: ListView.builder(
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
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
        color: isActive ? AppColors.lightBlue : AppColors.lightGray,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(2, 3),
            blurRadius: 6,
          )
        ],
      ),
    );
  }
}
