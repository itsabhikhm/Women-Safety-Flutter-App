import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_final_project/utils/quotes.dart';

import 'safewebview.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({super.key});

  void navigateToRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 2.0, autoPlay: true, enlargeCenterPage: true),
        items: List.generate(
          imageSliders.length,
          (index) => Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  navigateToRoute(
                      context,
                      SafeWebView(
                          index: index,
                          title: "Predict Crime",
                          url: "https://abhikhm.pythonanywhere.com/"));
                } else if (index == 1) {
                  navigateToRoute(
                      context,
                      SafeWebView(
                          index: index,
                          title: "Predict Crime",
                          url:
                              "https://plan-international.org/ending-violence/16-ways-end-violence-girls"));
                } else if (index == 2) {
                  navigateToRoute(
                      context,
                      SafeWebView(
                          index: index,
                          title: "Predict Crime",
                          url:
                              "https://www.healthline.com/health/womens-health/self-defense-tips-escape"));
                } else {
                  navigateToRoute(
                      context,
                      SafeWebView(
                          index: index,
                          title: "Predict Crime",
                          url:
                              "https://www.healthline.com/health/womens-health/self-defense-tips-escape"));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        imageSliders[index],
                      )),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ]),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8),
                      child: Text(
                        articleTitle[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
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
