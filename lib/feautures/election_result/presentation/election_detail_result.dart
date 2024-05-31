import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_evoting_app/feautures/election/model/model.dart';
import 'package:secure_evoting_app/shared/widget/build_title.dart';
import 'package:secure_evoting_app/shared/widget/candidate_card%20_result.dart';

class ElectionDetailResultScreen extends StatelessWidget {
  const ElectionDetailResultScreen({super.key, required this.election});
  final ElectionsModel election;
  Stream<List<CandidateModel>> getElectionStream() {
    FirebaseFirestore _db = FirebaseFirestore.instance;

    return _db
        .collection('elections')
        .doc(election.id)
        .collection('candidates')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return CandidateModel.fromJson(data);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Election",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              _electionCode(),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              ),
              _electionDetail(),
              buildTitle('Candidates'),
              StreamBuilder<List<CandidateModel>>(
                stream: getElectionStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CandidateModel>> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CandidateCardResult(
                        candidate: snapshot.data![index],
                        electionId: election.id,
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _electionDetail() {
    return Column(
      children: [
        buildTitle('Election Detail'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            election.details,
            style: TextStyle(
                fontFamily: GoogleFonts.workSans().fontFamily,
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Center _electionCode() {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Election Code: ',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.workSans().fontFamily),
            ),
            TextSpan(
              text: election.id,
              style: TextStyle(
                  fontFamily: GoogleFonts.workSans().fontFamily,
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
