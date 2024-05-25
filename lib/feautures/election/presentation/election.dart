import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/feautures/election/model/model.dart';
import 'package:secure_evoting_app/shared/widget/build_title.dart';
import 'package:secure_evoting_app/shared/widget/election_card.dart';

class ElectionScreen extends StatelessWidget {
  const ElectionScreen({super.key});
  Stream<List<ElectionsModel>> getElectionStream() {
    FirebaseFirestore _db = FirebaseFirestore.instance;

    return _db
        .collection('elections')
        .where('voterIds', arrayContains: Auth().currentUser!.uid)
        .where('status', isEqualTo: 'In Progress')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return ElectionsModel.fromJson(data);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      child: Scaffold(
        appBar: AppBar(
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
                buildTitle('Active Election'),
                StreamBuilder<List<ElectionsModel>>(
                  stream: getElectionStream(),
                  builder: (BuildContext context, AsyncSnapshot<List<ElectionsModel>> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.data!.isEmpty) {
                      return const Text('No active election');
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ElectionCard(election: snapshot.data![index]);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
