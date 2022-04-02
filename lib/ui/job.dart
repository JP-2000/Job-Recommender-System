import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:job_recommender_system/Network/network.dart';

class Job extends StatefulWidget {
  final String jobId;
  final String jobTitle;
  final String companyName;
  // ignore: use_key_in_widget_constructors
  const Job(this.jobId, this.jobTitle, this.companyName);

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  late String jobId;
  late String jobTitle;
  late String companyName;
  final ItemScrollController _scrollController = ItemScrollController();
  late List<Widget> widgetsList = [
    block("Job Description"),
    block("About Company"),
    block("Reviews"),
    block("Benefits"),
    block("Salaries"),
    similarJobs("Similar Jobs", jobId)
  ];
  @override
  Widget build(BuildContext context) {
    jobId = widget.jobId;
    jobTitle = widget.jobTitle;
    companyName = widget.companyName;

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 10,
              margin: const EdgeInsets.all(0),
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(FontAwesomeIcons.building),
                    ),
                    Text(
                      jobTitle,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(companyName,
                        style: const TextStyle(
                          fontSize: 18,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.star,
                          size: 12,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text("4.5"),
                        SizedBox(
                          width: 10,
                        ),
                        Text("(3272) Reviews")
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("101 Applicants"),
                        Text("Posted 2 days ago")
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    navBar()
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  itemCount: widgetsList.length,
                  itemBuilder: (context, index) {
                    return widgetsList[index];
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget block(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text(
              "Lorem adipisicing incididunt aliqua anim ut Lorem nisi velit esse. Proident duis est et excepteur. Pariatur eu incididunt sit veniam qui non cupidatat fugiat anim Lorem nulla. Minim reprehenderit ex id incididunt. Consectetur in occaecat eu magna reprehenderit quis ea duis do non culpa mollit. Culpa proident ipsum sunt labore nostrud occaecat et laboris ipsum amet tempor amet. Tempor proident enim excepteur reprehenderit nisi.Duis dolor labore est occaecat cillum irure excepteur ea tempor dolor occaecat voluptate. Duis voluptate eu deserunt ipsum excepteur est. Labore dolor non labore est deserunt et aliquip incididunt dolor labore ipsum.Commodo eiusmod ex sit nostrud in. Dolore non proident ad magna elit minim aute pariatur mollit. Esse velit Lorem do minim qui. Irure aliquip labore non ea. Ipsum aliquip ex occaecat consequat et irure et quis cupidatat consequat et exercitation."),
        ],
      ),
    );
  }

  Widget similarJobs(String title, String? jobId) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          FutureBuilder(
              future: Network.getCustomRecommendations(jobId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data;
                  return Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Job(
                                              list[index][9],
                                              list[index][1],
                                              list[index][1],
                                            )));
                              },
                              child: customCard(
                                  jobTitle: list[index][0],
                                  companyName: list[index][1],
                                  rating: list[index][6],
                                  experience: list[index][2],
                                  vacancy: list[index][7],
                                  location: list[index][3]),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }

  TextStyle navStyle() {
    return const TextStyle(fontSize: 15);
  }

  Widget navBar() {
    return SizedBox(
      height: 20,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _scrollController.scrollTo(
                    index: 0, duration: const Duration(seconds: 1));
              });
            },
            child: const Text("Job Description",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _scrollController.scrollTo(
                    index: 1, duration: const Duration(seconds: 1));
              });
            },
            child: const Text("About Company",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _scrollController.scrollTo(
                    index: 2, duration: const Duration(seconds: 1));
              });
            },
            child: const Text("Reviews",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _scrollController.scrollTo(
                    index: 3, duration: const Duration(seconds: 1));
              });
            },
            child: const Text("Benefits",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _scrollController.scrollTo(
                    index: 4, duration: const Duration(seconds: 1));
              });
            },
            child: const Text("Salaries",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _scrollController.scrollTo(
                    index: 5, duration: const Duration(seconds: 1));
              });
            },
            child: const Text("Similar Jobs",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

Widget customCard(
    {required String jobTitle,
    required String companyName,
    required String rating,
    required String experience,
    required String vacancy,
    required String location}) {
  return Builder(builder: (context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(FontAwesomeIcons.building),
            ),
            ListTile(
              title: Text(jobTitle),
              subtitle: Text(companyName),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  txtWithIcon(icon: const Icon(Icons.work), text: experience),
                  vacancy != ""
                      ? txtWithIcon(
                          icon: const Icon(Icons.people), text: vacancy)
                      : const SizedBox(width: 10),
                  txtWithIcon(icon: const Icon(Icons.place), text: location),
                ],
              ),
            )
          ],
        ),
      ),
    );
  });
}

Widget txtWithIcon({required Icon icon, required String text}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: FittedBox(
      child: Row(
        children: [icon, Text(text)],
      ),
    ),
  );
}
