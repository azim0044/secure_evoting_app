import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_evoting_app/feautures/chat/presentation/chat.dart';
import 'package:secure_evoting_app/feautures/election/model/model.dart';
import 'package:secure_evoting_app/feautures/settings/presentation/face_recognition.dart';
import 'package:secure_evoting_app/shared/widget/build_title.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CandidateDetailScreen extends StatefulWidget {
  const CandidateDetailScreen(
      {super.key,
      required this.candidate,
      required this.electionId,
      required this.fromWidget});
  final CandidateModel candidate;
  final String electionId;
  final String fromWidget;

  @override
  State<CandidateDetailScreen> createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends State<CandidateDetailScreen> {
  List<Widget> imageSliders = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    imageSliders = widget.candidate.images
        .map((item) => Container(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
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
          "Candidate Detail",
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
        child: Column(
          children: [
            _buildImageSlider(context),
            buildTitle('Candidate Manifesto'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.candidate.manifesto,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: GoogleFonts.workSans().fontFamily,
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),
            if (widget.fromWidget == 'In Progress')
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                        () => FaceAuthenticationWidgetScreen(
                              fromWidget: 'Vote',
                              electionId: widget.electionId,
                              candidateId: widget.candidate.id,
                              candidateName: widget.candidate.full_name,
                            ),
                        transition: Transition.rightToLeft);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Vote Now !',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5.0,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: widget.fromWidget == 'In Progress'
          ? Container(
              height: 90.0,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.green, // Set the color of the circle
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Get.to(() => ChatPage(
                              candidateId: widget.candidate.id,
                              candidateImage: widget.candidate.images[0],
                            ), transition: Transition.downToUp);
                      },
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Column _buildImageSlider(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                  child: Column(
                children: [
                  CarouselSlider(
                    items: imageSliders,
                    options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 1.6,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    carouselController: _controller,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        widget.candidate.images.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
