import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wedding_website/prefs.dart';
import 'package:wedding_website/rsvp_dialog.dart';
import 'package:wedding_website/rsvp_survery.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Supabase.initialize(
    url: 'https://uwyfsigboiwhorbrruaq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3eWZzaWdib2l3aG9yYnJydWFxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjE0MTY4MzYsImV4cCI6MjAzNjk5MjgzNn0.Zpo1-IXvFYfIAxi7yaX2jDBGfm5ieay15MQKVQRpyVI',
  );
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

class ExampleParallax extends StatefulWidget {
  const ExampleParallax({
    super.key,
  });

  @override
  State<ExampleParallax> createState() => _ExampleParallaxState();
}

class _ExampleParallaxState extends State<ExampleParallax> {
  Map<String, dynamic> guest = {};

  @override
  void initState() {
    super.initState();
    if (prefs.containsKey("Guest names")) {
      guest['id'] = prefs.getInt("Guest ID");
      guest['Names'] = prefs.getString("Guest names");
      guest['reception'] = prefs.getBool("Reception");
      guest['ceilidh'] = prefs.getBool("Ceilidh");
      guest['first'] = prefs.getString("First");
      if (prefs.containsKey("Second")) {
        guest['second'] = prefs.getString("Second");
      }
      if (prefs.containsKey("Third")) {
        guest['third'] = prefs.getString("Third");
      }
      if (prefs.containsKey("Children")) {
        guest['children'] = prefs.getString("Children");
      }
      Supabase.instance.client
          .from("Responses")
          .select('id')
          .eq('guest_id', guest['id'])
          .then((responses) {
        if (responses.isNotEmpty) {
          setState(() {
            guest['RSVPed'] = true;
            prefs.setBool('RSVPed', true);
          });
        }
      });
    }
  }

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
    const textOnPaper = TextStyle(color: Colors.black, fontSize: 20, fontFamily: "EBGaramond");
    double width = MediaQuery.of(context).size.width;

    return PageView(
      scrollDirection: Axis.vertical,
      allowImplicitScrolling: true,
      children: [
        SectionListItem(
          image: 'wedding.jpg',
          child: Padding(
            padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
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
                Text(
                  "Saturday 16th November 2024",
                  style: TextStyle(color: Colors.white, fontSize: 30, shadows: subtitleShadow),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                OutlinedButton(
                    onPressed: () {
                      if (guest.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RSVPDialog(
                              guestUpdatedCallback: (guest) {
                                setState(() {
                                  this.guest = guest;
                                });
                              },
                            );
                          },
                        );
                      } else {
                        setState(() {
                          guest = {};
                          prefs.remove("Guest ID");
                          prefs.remove("Guest names");
                          prefs.remove("Reception");
                          prefs.remove("Ceilidh");
                          prefs.remove("First");
                          prefs.remove("Second");
                          prefs.remove("Third");
                          prefs.remove("Children");
                          prefs.remove("Surveyed");
                          prefs.remove("RSVPed");
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        side: const BorderSide(color: Colors.white, width: 1.0)),
                    child: guest.isEmpty
                        ? Text("RSVP",
                            style: TextStyle(color: Colors.white, shadows: subtitleShadow))
                        : Text("${guest['Names']}",
                            style: TextStyle(color: Colors.white, shadows: subtitleShadow))),
                if (prefs.containsKey("Guest names"))
                  const SizedBox(
                    height: 10,
                  ),
                if (prefs.containsKey("Guest names"))
                  OutlinedButton(
                      onPressed: guest["RSVPed"] == true
                          ? null
                          : () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return RSVPSurvey(
                                        guestId: guest['id'],
                                        first: guest['first'],
                                        second: guest['second'],
                                        third: guest['third'],
                                        rsvpCallback: () {
                                          setState(() {
                                            prefs.setBool('RSVPed', true);
                                            guest['RSVPed'] = true;
                                          });
                                        },
                                        children: guest['children']);
                                  });
                            },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          side: BorderSide(
                              color: guest["RSVPed"] == true ? Colors.transparent : Colors.white,
                              width: 1.0)),
                      child: Text(
                          guest["RSVPed"] == true
                              ? "Thank you for RSVPing"
                              : "Please fill out a few questions",
                          style: TextStyle(color: Colors.white, shadows: subtitleShadow)))
              ],
            ),
          ),
        ),
        SectionListItem(
          image: 'paper.jpg',
          child: DefaultTextStyle.merge(
            style: textOnPaper,
            textAlign: TextAlign.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                  child: const Column(
                    children: [
                      Text(
                        "CEREMONY",
                        style: headerStyle,
                      ),
                      SizedBox(height: 20),
                      Text("The ceremony will take place at 12 noon."),
                      Text("We invite guests to be seated by 11.50am."),
                      SizedBox(height: 20),
                      Text("Christchurch Durham", style: TextStyle(fontStyle: FontStyle.italic)),
                      Text("32 Claypath", style: TextStyle(fontStyle: FontStyle.italic)),
                      Text("DH1 1RH", style: TextStyle(fontStyle: FontStyle.italic)),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Center(child: Image.asset("images/christchurch drawing.png", height: 100)),
              ],
            ),
          ),
        ),
        SectionListItem(
          image: 'backs2_extended.jpg',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextStyle(
                style: textOnPaper,
                textAlign: TextAlign.center,
                child: Column(
                  children: [
                    const Text("RECEPTION", style: headerStyle),
                    const SizedBox(
                      height: 20,
                    ),
                    if (guest.isEmpty) const Text("Please RSVP for further details."),
                    if (guest['reception'] == true)
                      const Column(
                        children: [
                          Text("The reception will take place at 3pm."),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Bowburn Hall Hotel", style: TextStyle(fontStyle: FontStyle.italic)),
                          Text("Bowburn", style: TextStyle(fontStyle: FontStyle.italic)),
                          Text("DH6 5NH", style: TextStyle(fontStyle: FontStyle.italic)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "The reception will include a three course meal, speeches, and a ceilidh in the evening."),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    if (guest['ceilidh'] == true && guest['reception'] == false)
                      const Column(
                        children: [
                          Text("Please arrive for 7pm to Bowburn hall hotel"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "The ceilidh will start at 7.30pm and will include a buffet and dancing."),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Center(child: Image.asset("images/bowburn.png", width: 100)),
            ],
          ),
        ),
        SectionListItem(
          image: 'paper.jpg',
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "TRAVEL",
                        style: headerStyle,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextStyle(
                      style: textOnPaper,
                      textAlign: TextAlign.center,
                      child: Column(
                        children: [
                          Text(
                              "There is no parking at the church, but parking is available nearby at The Sands, Prince Bishops Car Park, and around the city."),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "There is plenty of parking at the hotel for the reception, which is 10-15 minutes drive away from the church."),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "We would love to make travel to and from the reception easier for those not travelling by car. If you are able to offer a lift, or would like to receive one, please let us know when RSVPing."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 0, top: -110, child: Image.asset("images/train tracks 2.png", width: 250)),
              Positioned(
                  bottom: 0,
                  left: MediaQuery.of(context).size.width * 0.55,
                  child: Image.asset("images/mountains.png", width: 200)),
            ],
          ),
        ),
        SectionListItem(
            image: 'hammock.jpg',
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                  child: DefaultTextStyle(
                    style: textOnPaper,
                    textAlign: TextAlign.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("GIFTS",
                            style:
                                headerStyle.copyWith(color: Colors.white, shadows: subtitleShadow)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "If you would like to give a gift for our new home, you are welcome to do so here.",
                          style: textOnPaper.copyWith(color: Colors.white, shadows: subtitleShadow),
                        ),
                        Text(
                          "(We will add a link here soon!)",
                          style: textOnPaper.copyWith(color: Colors.white, shadows: subtitleShadow),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 50,
                    left: width / 2 - 200 / 2,
                    child: Image.asset(
                      "images/bridesmaid leaves.png",
                      width: 200,
                      color: Colors.white,
                    )),
              ],
            )),
        SectionListItem(
          image: 'paper.jpg',
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "CONTACT",
                        style: headerStyle,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextStyle(
                      style: textOnPaper,
                      textAlign: TextAlign.center,
                      child: Column(
                        children: [
                          Text(
                              "If you have any questions, please send us a message or email us at peterandemma@noblesque.org.uk"),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.25,
                  left: MediaQuery.of(context).size.width * 0.5 -
                      MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset("images/cow.png",
                      height: MediaQuery.of(context).size.height * 0.8)),
            ],
          ),
        ),
      ],
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
      child: child,
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
