// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:frontend/constants/constants.dart';


class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  CarouselController controller = CarouselController();
  int activeIndex = 0;
  List images = [
    "https://i.ibb.co/k4ZpSzG/Untitled-design-6.png",
    'https://i.ibb.co/H7rSfzq/Untitled-design-5.png',
    'https://i.ibb.co/ScdH1d8/Untitled-design-3.png',
  ];
  Color colorA = MyColors.colorA;
  Color colorB = MyColors.colorB;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: MyColors.colorC,
            child: CarouselSlider.builder(
                carouselController: controller,
                itemCount: images.length,
                itemBuilder: (context, itemIndex, pageIndex) {
                  return Container(
                    child: Center(
                      child: Image.network(
                        images[itemIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  height: MediaQuery.of(context).size.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ))),
        Positioned(
          left: width / 2 - 25,
          // right: width / 2,
          bottom: 150,
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: 3,
              effect: const ExpandingDotsEffect(
                dotColor: MyColors.colorA,
                activeDotColor: MyColors.colorB,
                dotHeight: 8,
                dotWidth: 8,
              ),
              onDotClicked: (activeIndex) {
                controller.animateToPage(activeIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
            ),
          ),
        ),
        Positioned(
          left: width / 2 - 100,
          // right: width / 2,
          bottom: 100,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            style: ElevatedButton.styleFrom(
              primary: colorA,
              fixedSize: Size(width / 2, 20),
            ),
            child: const Text('Register'),
          ),
        ),
        Positioned(
          left: width / 2 - 100,
          bottom: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signin');
            },
            style: ElevatedButton.styleFrom(
              primary: colorB,
              fixedSize: Size(width / 2, 20),
            ),
            child: const Text('Login'),
          ),
        ),
      ]),
    );
  }
}
