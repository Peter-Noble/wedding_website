import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wedding_website/prefs.dart';
import 'package:wedding_website/rsvp_survery.dart';

class RSVPDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) guestUpdatedCallback;

  const RSVPDialog({
    super.key,
    required this.guestUpdatedCallback,
  });

  @override
  State<RSVPDialog> createState() => RSVPDialogState();
}

class RSVPDialogState extends State<RSVPDialog> {
  List<Map<String, dynamic>>? guests;
  List<Map<String, dynamic>> guestsFiltered = [];

  void getGuests() async {
    guests = await Supabase.instance.client
        .from('Guests')
        .select('id, Names, reception, ceilidh, first, second, third, children');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (guests == null) {
      getGuests();
    }
    if (guests == null) {
      return const AlertDialog(
        title: Text("Getting info about guests"),
      );
    } else {
      return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 275,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "Search name"),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          guestsFiltered = [];
                        });
                        return;
                      }
                      final fuse = Fuzzy(guests!.map((e) => e['Names'].toString()).toList(),
                          options: FuzzyOptions(
                            isCaseSensitive: false,
                            findAllMatches: false,
                            threshold: 0.05,
                            location: 0,
                            distance: 100,
                            maxPatternLength: 32,
                            minMatchCharLength: 1,
                            tokenize: true,
                          ));
                      final result = fuse.search(value);
                      setState(() {
                        guestsFiltered = result.sublist(0, min(3, result.length)).map((e) {
                          print(
                              "Matched guest: ${e.item} ${e.matches[0].arrayIndex} with score ${e.score}");
                          return guests![e.matches[0].arrayIndex];
                        }).toList();
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: guestsFiltered
                        .map((g) => ElevatedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                side: const BorderSide(color: Colors.white, width: 1.0)),
                            onPressed: () {
                              setState(() {
                                prefs.setString("Guest names", g['Names']);
                                prefs.setBool("Reception", g['reception']);
                                prefs.setBool("Ceilidh", g['ceilidh']);
                                prefs.setInt("Guest ID", g['id']);

                                prefs.setString("First", g['first']);
                                if (g['second'] != null && g['second'] != "") {
                                  prefs.setString("Second", g['second']);
                                }
                                if (g['third'] != null && g['third'] != "") {
                                  prefs.setString("Third", g['third']);
                                }
                                if (g['children'] != null && g['children'] != "") {
                                  prefs.setString("Children", g['children']);
                                }
                                prefs.setBool('RSVPed', false);
                              });
                              widget.guestUpdatedCallback(g);

                              Supabase.instance.client
                                  .from("Responses")
                                  .select('id')
                                  .eq('guest_id', g['id'])
                                  .then(
                                (responses) {
                                  if (responses.isEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RSVPSurvey(
                                              guestId: g['id'],
                                              first: g['first'],
                                              second: g['second'],
                                              third: g['third'],
                                              rsvpCallback: () {
                                                setState(() {
                                                  g['RSVPed'] = true;
                                                  prefs.setBool('RSVPed', true);
                                                  widget.guestUpdatedCallback(g);
                                                });
                                              },
                                              children: g['children'])),
                                    );
                                  } else {
                                    setState(() {
                                      g['RSVPed'] = true;
                                      prefs.setBool('RSVPed', true);
                                      widget.guestUpdatedCallback(g);
                                    });
                                  }
                                },
                              );

                              Navigator.pop(context);
                            },
                            child: Text(g['Names'], style: const TextStyle(color: Colors.black))))
                        .toList(),
                  ),
                ],
              ),
            ),
          )
          // child: Column(
          //     children: guests!
          //         .map((e) => ElevatedButton(
          //             onPressed: () {
          //               setState(() {
          //                 prefs.setString("Guest names", e['Names']);
          //                 prefs.setBool("Reception", e['reception']);
          //                 prefs.setBool("Ceilidh", e['ceilidh']);
          //               });
          //               widget.guestUpdatedCallback(e);
          //               Navigator.pop(context);
          //             },
          //             child: Text(e['Names'])))
          //         .toList()),
          );
    }
  }
}
