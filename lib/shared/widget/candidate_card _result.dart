// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_evoting_app/feautures/election/model/model.dart';
import 'package:secure_evoting_app/feautures/election/presentation/candidate_detail.dart';

class CandidateCardResult extends StatefulWidget {
  final CandidateModel candidate;
  final String electionId;
  const CandidateCardResult({
    Key? key,
    required this.candidate,
    required this.electionId,
  }) : super(key: key);

  @override
  State<CandidateCardResult> createState() => _CandidateCardResultState();
}

class _CandidateCardResultState extends State<CandidateCardResult> {
  int _vote = 0;

  @override
  void initState() {
    super.initState();
    _voteCandidate();
  }

  void _voteCandidate() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await _db.collection('elections').doc(widget.electionId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      int? totalVoters = data['totalVoters'];
      print('Total voters: $totalVoters');
      setState(() {
        _vote = totalVoters!;
      });
    } else {
      print('Document does not exist on the database');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => CandidateDetailScreen(
                candidate: widget.candidate,
                electionId: widget.electionId,
                fromWidget: 'Complete'),
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
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(widget.candidate.images[0]),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.candidate.status!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.candidate.status == 'Winner'
                                  ? Colors.green
                                  : widget.candidate.status == 'Fair'
                                      ? Colors.green
                                      : widget.candidate.status == 'Lost'
                                          ? Colors.red
                                          : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${widget.candidate.vote}/$_vote",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.candidate.status == 'Winner'
                                  ? Colors.green
                                  : widget.candidate.status == 'Fair'
                                      ? Colors.green
                                      : widget.candidate.status == 'Lost'
                                          ? Colors.red
                                          : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.candidate.full_name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        widget.candidate.manifesto,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: GoogleFonts.workSans().fontFamily,
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold),
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
