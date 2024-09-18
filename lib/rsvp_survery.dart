import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wedding_website/prefs.dart';

List<Question> perPersonQuestions(bool isFirstPerson, bool isOnlyPerson, String name) {
  return [
    Question(
      isMandatory: true,
      question: isOnlyPerson ? 'Will you be joining us?' : '$name, will you be joining us?',
      answerChoices: {
        "Yes": [
          Question(
              isMandatory: true,
              singleChoice: true,
              question: "What would you like to eat?\nFor starters (all can be made GF)",
              answerChoices: {
                "Melon and ham": null,
                "Smoked salmon terrine": null,
                "Mixed tempura vegetables (VG)": null,
              }),
          Question(
              isMandatory: true,
              singleChoice: true,
              question: "For the main (all can be made GF)",
              answerChoices: {
                "Chicken, garlic mushroom & white wine sauce": null,
                "Topside of beef + Yorkshire pudding": null,
                "Nut roast (VG)": null,
              }),
          Question(isMandatory: true, singleChoice: true, question: "For pudding", answerChoices: {
            "Sticky toffee pudding with ice cream": null,
            "Raspberry pavlova": null,
            "Black cherry and vanilla cheesecake (VG and GF)": null,
          }),
          Question(
            isMandatory: true,
            question: "Do you have any dietary requirements?",
            answerChoices: {
              "Yes": [
                Question(
                  isMandatory: true,
                  question: "Please specify",
                )
              ],
              "No": [],
            },
          ),
          // Question(
          //   isMandatory: true,
          //   question: "Would you like to be served alcohol?",
          //   answerChoices: {
          //     "Yes": null,
          //     "No, soft drink alternative please": null,
          //   },
          // ),
          if (isFirstPerson)
            Question(
                isMandatory: true,
                question: "How will you travel to and from the reception?",
                answerChoices: {
                  "I can make my own way": [
                    Question(
                        isMandatory: true,
                        question: "Are you able to offer a lift to another guest?",
                        answerChoices: {
                          "Yes": [
                            Question(
                              isMandatory: true,
                              question: "Number of seats available",
                            ),
                          ],
                          "No": null
                        })
                  ],
                  "I would appreciate a lift": null,
                }),
        ],
        "Sorry, no": [],
      },
    ),
  ];
}

List<Question> perPersonQuestionsCeilidh(bool isFirstPerson, bool isOnlyPerson, String name) {
  return [
    Question(
      isMandatory: true,
      question: isOnlyPerson ? 'Will you be joining us?' : '$name, will you be joining us?',
      answerChoices: {
        "Yes": [
          Question(
            isMandatory: true,
            question: "Do you have any dietary requirements?",
            answerChoices: {
              "Yes": [
                Question(
                  isMandatory: true,
                  question: "Please specify",
                )
              ],
              "No": [],
            },
          ),
          if (isFirstPerson)
            Question(
                isMandatory: true,
                question: "How will you travel to and from the reception?",
                answerChoices: {
                  "I can make my own way": [
                    Question(
                        isMandatory: true,
                        question: "Are you able to offer a lift to another guest?",
                        answerChoices: {
                          "Yes": [
                            Question(
                              isMandatory: true,
                              question: "Number of seats available",
                            ),
                          ],
                          "No": null
                        })
                  ],
                  "I would appreciate a lift": null,
                }),
        ],
        "Sorry, no": [],
      },
    ),
  ];
}

List<Question> perPersonQuestionsService(bool isFirstPerson, bool isOnlyPerson, String name) {
  return [
    Question(
      isMandatory: true,
      question: 'Will you be joining us for the service?',
      answerChoices: {
        "Yes": null,
        "Sorry, no": null,
      },
    ),
  ];
}

List<Question> childrenQuestions(String names) {
  return [
    Question(
        isMandatory: true,
        question: "Will $names be coming?",
        answerChoices: {"Yes": null, "No, just the adults": null}),
  ];
}

List<Question> emailQuestion() {
  return [
    Question(
      isMandatory: true,
      question: "What is your email address?",
    ),
  ];
}

Future<void> readResponse(QuestionResult result, int guestId, String guestName) async {
  bool offeringLifts = false;
  String liftCapacity = "";

  bool attending = false;
  String starter = "";
  String main = "";
  String pudding = "";

  bool dietaryRequirements = false;
  String dietaryDescription = "";
  String travelMethod = "";

  // bool alcohol = true;

  if (result.answers[0] == "Yes") {
    attending = true;
    starter = result.children[0].answers[0];
    main = result.children[1].answers[0];
    pudding = result.children[2].answers[0];

    if (result.children[3].answers[0] == "Yes") {
      dietaryRequirements = true;
      dietaryDescription = result.children[3].children[0].answers[0];
      print("Dietary requirements: ${result.children[3].children[0].answers[0]}");
    }

    // alcohol = result.children[4].answers[0] == "Yes";

    if (result.children.length > 4) {
      travelMethod = result.children[4].answers[0];
      if (result.children[4].answers[0] == "I can make my own way") {
        if (result.children[4].children[0].answers[0] == "Yes") {
          print(
              "Number of seats available: ${result.children[4].children[0].children[0].answers[0]}");
          offeringLifts = true;
          liftCapacity = result.children[4].children[0].children[0].answers[0];
        }
      }
    }
  }

  // await Supabase.instance.client.from("test").insert({
  //   "num": 1,
  // });

  await Supabase.instance.client.from("Responses").insert({
    "guest_id": guestId,
    "guest_name": guestName,
    "attending": attending,
    "starter_choice": starter,
    "main_choice": main,
    "desert_choice": pudding,
    "dietary_requirements": dietaryRequirements,
    "dietary_description": dietaryDescription,
    "travel_method": travelMethod,
    "offering_lifts": offeringLifts,
    "lift_capacity": liftCapacity,
    // "alcohol": alcohol,
  });
}

Future<void> readResponseCeilidh(QuestionResult result, int guestId, String guestName) async {
  bool offeringLifts = false;
  String liftCapacity = "";

  bool attending = false;

  bool dietaryRequirements = false;
  String dietaryDescription = "";
  String travelMethod = "";

  // bool alcohol = true;

  if (result.answers[0] == "Yes") {
    attending = true;

    if (result.children[0].answers[0] == "Yes") {
      dietaryRequirements = true;
      dietaryDescription = result.children[0].children[0].answers[0];
      print("Dietary requirements: ${result.children[0].children[0].answers[0]}");
    }

    // alcohol = result.children[4].answers[0] == "Yes";

    if (result.children.length > 1) {
      if (result.children[1].answers[0] == "I can make my own way") {
        travelMethod = result.children[1].answers[0];
        if (result.children[1].children[0].answers[0] == "Yes") {
          print(
              "Number of seats available: ${result.children[1].children[0].children[0].answers[0]}");
          offeringLifts = true;
          liftCapacity = result.children[1].children[0].children[0].answers[0];
        }
      }
    }
  }

  // await Supabase.instance.client.from("test").insert({
  //   "num": 1,
  // });

  await Supabase.instance.client.from("Responses").insert({
    "guest_id": guestId,
    "guest_name": guestName,
    "attending": attending,
    "starter_choice": null,
    "main_choice": null,
    "desert_choice": null,
    "dietary_requirements": dietaryRequirements,
    "dietary_description": dietaryDescription,
    "travel_method": travelMethod,
    "offering_lifts": offeringLifts,
    "lift_capacity": liftCapacity,
    // "alcohol": alcohol,
  });
}

Future<void> readResponseService(QuestionResult result, int guestId, String guestName) async {
  bool attending = false;

  if (result.answers[0] == "Yes") {
    attending = true;
  }

  await Supabase.instance.client.from("Responses").insert({
    "guest_id": guestId,
    "guest_name": guestName,
    "attending": attending,
    "starter_choice": null,
    "main_choice": null,
    "desert_choice": null,
    "dietary_requirements": null,
    "dietary_description": null,
    "travel_method": null,
    "offering_lifts": null,
    "lift_capacity": null,
    // "alcohol": alcohol,
  });
}

Future<void> readChildren(QuestionResult result, int guestId, String guestName) async {
  bool childrenAttending = result.answers[0] == "Yes";

  await Supabase.instance.client.from("Responses").insert({
    "guest_id": guestId,
    "guest_name": guestName,
    "attending": childrenAttending,
    "starter_choice": null,
    "main_choice": null,
    "desert_choice": null,
    "dietary_requirements": null,
    "dietary_description": null,
    "travel_method": "",
    "offering_lifts": null,
    "lift_capacity": null,
  });
}

Future<void> readEmail(QuestionResult result, int guestId) async {
  await Supabase.instance.client.from("Emails").insert({
    "email": result.answers[0],
    "guest_id": guestId,
  });
}

class RSVPSurvey extends StatefulWidget {
  final int guestId;
  final String first;
  final String? second;
  final String? third;
  final String? children;
  final Function rsvpCallback;
  const RSVPSurvey(
      {required this.guestId,
      required this.first,
      required this.second,
      required this.third,
      required this.children,
      required this.rsvpCallback,
      super.key});

  @override
  State<RSVPSurvey> createState() => _RSVPSurveyState();
}

class _RSVPSurveyState extends State<RSVPSurvey> {
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    List<QuestionResult> results = [];
    List<Question> firstQuestions;
    if (prefs.getBool("Reception") == true) {
      firstQuestions = perPersonQuestions(true, widget.second == null, widget.first);
    } else if (prefs.getBool("Ceilidh") == true) {
      firstQuestions = perPersonQuestionsCeilidh(true, widget.second == null, widget.first);
    } else {
      firstQuestions = perPersonQuestionsService(true, widget.second == null, widget.first);
    }

    List<Question> secondQuestions;
    if (widget.second == null || widget.second == "") {
      secondQuestions = [];
    } else if (prefs.getBool("Reception") == true) {
      secondQuestions = perPersonQuestions(false, false, widget.second!);
    } else if (prefs.getBool("Ceilidh") == true) {
      secondQuestions = perPersonQuestionsCeilidh(false, false, widget.second!);
    } else {
      secondQuestions = perPersonQuestionsService(false, false, widget.second!);
    }

    List<Question> thirdQuestions;
    if (widget.third == null || widget.third == "") {
      thirdQuestions = [];
    } else if (prefs.getBool("Reception") == true) {
      thirdQuestions = perPersonQuestions(false, false, widget.third!);
    } else if (prefs.getBool("Ceilidh") == true) {
      thirdQuestions = perPersonQuestionsCeilidh(false, false, widget.third!);
    } else {
      thirdQuestions = perPersonQuestionsService(false, false, widget.third!);
    }
    final List<Question> childQuestions =
        widget.children != null && widget.children != "" ? childrenQuestions(widget.children!) : [];
    final List<Question> emailQuestions = emailQuestion();

    return Dialog(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.75 -
                    MediaQuery.of(context).viewInsets.bottom,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: formKey,
                  child: Survey(
                      onNext: (questionResults) {
                        results = questionResults;
                      },
                      initialData: firstQuestions +
                          secondQuestions +
                          thirdQuestions +
                          childQuestions +
                          emailQuestions),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      side: const BorderSide(color: Colors.white, width: 1.0)),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Saving your responses')));

                      int i = 0;
                      print("First person");
                      if (prefs.getBool("Reception") == false &&
                          prefs.getBool("Ceilidh") == false) {
                        await readResponseService(results[i], widget.guestId, widget.first);
                      } else if (prefs.getBool("Reception") == false &&
                          prefs.getBool("Ceilidh") == true) {
                        await readResponseCeilidh(results[i], widget.guestId, widget.first);
                      } else {
                        await readResponse(results[i], widget.guestId, widget.first);
                      }
                      if (widget.second != null && widget.second != "") {
                        i++;
                        print("Second person");

                        if (prefs.getBool("Reception") == false &&
                            prefs.getBool("Ceilidh") == false) {
                          await readResponseService(results[i], widget.guestId, widget.second!);
                        } else if (prefs.getBool("Reception") == false &&
                            prefs.getBool("Ceilidh") == true) {
                          await readResponseCeilidh(results[i], widget.guestId, widget.second!);
                        } else {
                          await readResponse(results[i], widget.guestId, widget.second!);
                        }
                      }
                      if (widget.third != null && widget.third != "") {
                        i++;
                        print("Third person");

                        if (prefs.getBool("Reception") == false &&
                            prefs.getBool("Ceilidh") == false) {
                          await readResponseService(results[i], widget.guestId, widget.third!);
                        } else if (prefs.getBool("Reception") == false &&
                            prefs.getBool("Ceilidh") == true) {
                          await readResponseCeilidh(results[i], widget.guestId, widget.third!);
                        } else {
                          await readResponse(results[i], widget.guestId, widget.third!);
                        }
                      }
                      if (widget.children != null && widget.children != "") {
                        i++;
                        print("Child");
                        await readChildren(results[i], widget.guestId, widget.children!);
                      }
                      i++;
                      print("Email");
                      await readEmail(results[i], widget.guestId);
                      print("Done");

                      widget.rsvpCallback();
                      print("Done callback");
                    }
                  },
                  child: const Text("Submit")),
            ),
          ],
        ));
  }
}
