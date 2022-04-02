import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_recommender_system/Network/network.dart';
import 'package:job_recommender_system/ui/job.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Recommeder System"),
      ),
      drawer: Drawer(
        child: customDrawer(),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: const TextField(
              decoration: InputDecoration(
                  fillColor: Colors.amber,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  label: Icon(Icons.search),
                  hintText: "Search Job"),
            ),
          ),
          FutureBuilder(
              future: Network.getRecommendations(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data;
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
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
                              index == list.length - 1
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.0, left: 10),
                                          child: Text(
                                            "Recommended Jobs: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          height: 250,
                                          child: ListView.builder(
                                            itemCount: list.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return customCard(
                                                  jobTitle: list[index][0],
                                                  companyName: list[index][1],
                                                  rating: list[index][6],
                                                  experience: list[index][2],
                                                  vacancy: list[index][7],
                                                  location: list[index][3]);
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              })
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

Widget customDrawer() {
  return Column(
    children: [
      Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.asset('./assets/dp_background.png'),
          Container(
            margin: const EdgeInsets.all(10),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              shape: BoxShape.circle,
              image: const DecorationImage(
                  image: AssetImage('./assets/user.png'), fit: BoxFit.cover),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      drawerItem(icon: const Icon(Icons.search), name: "Search Jobs"),
      drawerItem(icon: const Icon(Icons.work), name: "Recommended Jobs"),
      drawerItem(icon: const Icon(Icons.bookmark), name: "Saved Jobs"),
      drawerItem(icon: const Icon(Icons.edit), name: "Edit Profile"),
      drawerItem(icon: const Icon(Icons.logout), name: "Logout"),
    ],
  );
}

Widget drawerItem({required Icon icon, required String name}) {
  return Container(
    margin: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon,
        const SizedBox(
          width: 10,
        ),
        Text(name)
      ],
    ),
  );
}
