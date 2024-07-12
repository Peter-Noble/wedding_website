import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'EBGaramond'),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: ExampleParallax(),
        ),
      ),
    );
  }
}

class ExampleParallax extends StatelessWidget {
  const ExampleParallax({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
        color: Colors.black, fontSize: 30, fontStyle: FontStyle.italic, letterSpacing: 10);
    final nameTitleShadow = [
      Shadow(
        blurRadius: 20.0,
        color: Colors.black.withAlpha(100),
      )
    ];
    final subtitleShadow = [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black.withAlpha(100),
      )
    ];
    final nameTitleStyle = TextStyle(
        fontSize: 100,
        color: Colors.white,
        fontFamily: "Caslon",
        letterSpacing: 65,
        shadows: nameTitleShadow);
    return SingleChildScrollView(
      physics: const PageScrollPhysics(),
      child: Stack(
        children: [
          Column(
            children: [
              SectionListItem(
                image: 'wedding.jpg',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "PETER",
                              style: nameTitleStyle,
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "&",
                              style: nameTitleStyle.apply(
                                  fontFamily: "Caslon", fontStyle: FontStyle.italic),
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "EMMA",
                              style: nameTitleStyle,
                            ),
                          ),
                        ])),
                    Text("Saturday 16th November 2024",
                        style:
                            TextStyle(color: Colors.white, fontSize: 30, shadows: subtitleShadow)),
                    const SizedBox(height: 18),
                    OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Thank you for RSVPing"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            side: const BorderSide(color: Colors.white, width: 1.0)),
                        child: const Text("RSVP", style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
              SectionListItem(
                image: 'paper.jpg',
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CEREMONY",
                      style: headerStyle,
                    ),
                    Divider(),
                    Text(
                      "Service:\nChristchurch Durham\nDurham\nClaypath\nDH1 1RH",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SectionListItem(
                image: 'backs.jpg',
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("RECEPTION", style: headerStyle),
                    Divider(),
                    Text(
                      "Reception:\nBowburn Hall Hotel\nBowburn\nDurham\nDH6 5NH",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Divider(),
                    Text("Wedding ceremony 12pm",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    Text("Reception 3pm",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    Text("Ceilidh 7pm",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    Text("Evening food 8pm",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    Text("IF GUEST ISN'T SELECTED THEN DON'T SHOW RECEPTION DETAILS",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ],
                ),
              ),
              SectionListItem(
                image: 'paper.jpg',
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "ACCOMMODATION",
                        style: headerStyle,
                      ),
                    ),
                    Divider(),
                    Text(
                      "We have reserved a block of rooms at the Bowburn Hall Hotel for our guests",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Divider(),
                    Text(
                      "Please mention the wedding when booking to receive a discount",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SectionListItem(
                  image: 'bridge.jpg',
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Gifts",
                          style: TextStyle(color: Colors.white, fontSize: 30, shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(.0, .0),
                            ),
                          ])),
                      Divider(),
                      Text("Your presence at our wedding is the greatest gift of all",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20, shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(.0, .0),
                            ),
                          ])),
                      Divider(),
                      Text(
                          "However, if you would like to give a gift, we have a gift list at John Lewis",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20, shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(.0, .0),
                            ),
                          ])),
                    ],
                  )),
              SectionListItem(
                  image: 'paper.jpg',
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Parking/Travel",
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                      Divider(),
                      Text(
                        "Car parks are available at both the church and the hotel",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Divider(),
                      Text(
                        "Please wear a mask",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  )),
              SectionListItem(
                  image: 'sunset.jpg',
                  child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Contact us",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Divider(),
                    Text(
                      "If you have any questions, please contact us at peterandemma@noblesque.org.uk",
                      style: TextStyle(color: Colors.white),
                    )
                  ]))
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 6 - 56,
            right: MediaQuery.of(context).size.width * 0.1,
            width: 100,
            child: Image.asset("images/cat.png"),
          )
        ],
      ),
    );
  }
}

class SectionListItem extends StatelessWidget {
  SectionListItem({
    super.key,
    required this.image,
    required this.child,
  });

  final String image;
  final Widget child;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      // aspectRatio: 16 / 9,
      child: Stack(
        children: [
          ClipRRect(
            child: Stack(
              children: [
                _buildParallaxBackground(context),
                // _buildGradient(),
              ],
            ),
          ),
          _buildTitleAndSubtitle(context),
        ],
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
          scrollable: Scrollable.of(context),
          listItemContext: context,
          backgroundImageKey: _backgroundImageKey),
      children: [
        Image.asset(
          "images/$image",
          key: _backgroundImageKey,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 2,
        )
      ],
    );
  }

  Widget _buildTitleAndSubtitle(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
        child: child,
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    // print("viewportDimension: $viewportDimension");
    // final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);
    final scrollFraction = listItemOffset.dy / viewportDimension;
    // print(scrollFraction);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = -Alignment(0.0, scrollFraction * 0.5);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox).size;
    // print(backgroundSize);
    final listItemSize = context.size;
    // print("listItemSize: $listItemSize");
    final childRect = verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // print("childRect.top: ${childRect.top}");

    // Paint the background.
    context.paintChild(
      0,
      transform: Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
    // context.paintChild(0, transform: );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}
