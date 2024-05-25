// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_evoting_app/feautures/election/model/model.dart';
import 'package:intl/intl.dart';
import 'package:secure_evoting_app/feautures/election/presentation/election_detail.dart';

class ElectionCard extends StatelessWidget {
  final ElectionsModel election;
  const ElectionCard({
    Key? key,
    required this.election,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ElectionDetailScreen(election: election),
            transition: Transition.rightToLeftWithFade);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Card(
          elevation: 4,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset('assets/images/vote_icon.png'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        election.title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 7),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Election Code: ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontFamily:
                                      GoogleFonts.workSans().fontFamily),
                            ),
                            TextSpan(
                              text: election.id,
                              style: TextStyle(
                                  fontFamily: GoogleFonts.workSans().fontFamily,
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Open Until: ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontFamily:
                                      GoogleFonts.workSans().fontFamily),
                            ),
                            TextSpan(
                              text: DateFormat('d MMM h:mm a')
                                  .format(election.end_date),
                              style: TextStyle(
                                  fontFamily: GoogleFonts.workSans().fontFamily,
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            size: 20,
                            Icons.person,
                            color: Colors.orange[600],
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${election.totalVoters} Voters Registered',
                            style: TextStyle(
                                fontFamily: GoogleFonts.workSans().fontFamily,
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 20,
                ), // New icon
              ],
            ),
          ),
        ),
      ),
    );
  }
}
