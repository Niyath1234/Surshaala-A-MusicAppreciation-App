import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/mood_model.dart';
class MoodCard extends StatelessWidget {
  const MoodCard({Key? key, required this.mood}) : super(key: key);

  final Mood mood;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
      Get.toNamed('/mood', arguments: mood);
    },
    child: Container(
    margin: const EdgeInsets.only(right: 10),
    child: Stack(
    alignment: Alignment.bottomCenter,
    children: [
    Container(
    width: MediaQuery.of(context).size.width * 0.45,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15.0),
    image: DecorationImage(
    image: AssetImage(
    mood.coverUrl,
    ),
    fit: BoxFit.cover,
    ),
    ),
    ),
      Container(),
    ],
    ),
    ),
    );
  }
}