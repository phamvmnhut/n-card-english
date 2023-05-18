import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:n_card_english/models/dictionaryapi_dev.dart';
import 'package:n_card_english/models/english_today.dart';
import 'package:n_card_english/values/app_colors.dart';
import 'package:n_card_english/values/app_styles.dart';
import 'package:http/http.dart' as http;

class EnglishCard extends StatefulWidget {
  EnglishCard(
      {Key? key, required this.english_today, required this.onFavoriteClick})
      : super(key: key);
  final EnglishToday english_today;
  final Function onFavoriteClick;

  @override
  _EnglishCardState createState() {
    return _EnglishCardState();
  }
}

class _EnglishCardState extends State<EnglishCard> {
  Future<DictionaryApiDev> fetchWord(String word) async {
    final response = await http.get(
        Uri.parse("https://api.dictionaryapi.dev/api/v2/entries/en/$word"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return DictionaryApiDev.fromJson(jsonDecode(response.body)[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('This word not found example.');
    }
  }

  late Future<DictionaryApiDev> wordDic;

  @override
  void initState() {
    super.initState();
    wordDic = fetchWord(widget.english_today.noun);
  }

  @override
  Widget build(BuildContext context) {
    String wordNoun = widget.english_today.noun ?? "  ";

    String firstLetter = wordNoun.substring(0, 1);
    String leftLetter = wordNoun.substring(1, wordNoun.length);

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Material(
        borderRadius: BorderRadius.circular(24),
          clipBehavior : Clip.antiAlias,
        child: InkWell(
          onDoubleTap: () {
            widget.onFavoriteClick();
          },
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.priColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.secondColor,
                      offset: Offset(2, 3),
                      blurRadius: 4,
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LikeButton(
                    // key: _likeButtonKey,
                    mainAxisAlignment: MainAxisAlignment.end,
                    onTap: (bool isLiked) async {
                      await widget.onFavoriteClick();
                      return !isLiked;
                    },
                    size: 42,
                    isLiked: widget.english_today.isFavorite,
                    circleColor: const CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: const BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.blueAccent : Colors.white,
                        size: 42,
                      );
                    },
                  ),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: firstLetter.toUpperCase(),
                      children: [
                        TextSpan(
                          text: leftLetter,
                          style: const TextStyle(
                            fontSize: 42,
                          ),
                        )
                      ],
                      style: const TextStyle(
                        fontFamily: FontFamily.sen,
                        fontWeight: FontWeight.bold,
                        fontSize: 89,
                        shadows: [
                          BoxShadow(
                            color: Colors.black87,
                            offset: Offset(0, 6),
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: FutureBuilder<DictionaryApiDev>(
                        future: wordDic,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String definite = "";
                            List<Meanings>? listMeaning = snapshot.data!.meanings;
                            if (listMeaning != null && listMeaning.isNotEmpty) {
                              Meanings meaning = listMeaning[0];
                              List<Definitions>? listDef = meaning.definitions;
                              if (listDef != null && listDef.isNotEmpty) {
                                Definitions def = listDef.firstWhere((element) => element.definition != null, orElse: () => Definitions() );
                                definite = def.definition ?? "";
                              }
                            }

                            return AutoSizeText(
                              '$definite',
                              style: AppStyles.h4.copyWith(
                                letterSpacing: 1,
                              ),
                              maxLines: 12,
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const CircularProgressIndicator(
                            color: AppColors.secondColor,
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
