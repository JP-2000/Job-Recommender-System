import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_recommender_system/Network/skills_list.dart';
import 'package:job_recommender_system/ui/homepage.dart';
import 'package:job_recommender_system/ui/user/profile_setup/dob.dart';
import 'package:job_recommender_system/ui/user/profile_setup/education.dart';
import 'package:job_recommender_system/ui/user/profile_setup/experience.dart';
import 'package:job_recommender_system/ui/user/profile_setup/languages.dart';
import 'package:job_recommender_system/ui/user/profile_setup/skills.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:job_recommender_system/Network/network.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  static String? preferredLocation;
  static String? linkedIn;

  bool checkList(List list) {
    bool counter = true;
    for (var i = 0; i < list.length; i++) {
      list[i].forEach((key, value) {
        if (value == "" || value == null) {
          counter = false;
        }
      });
    }
    return counter;
  }

  SnackBar snackBar = const SnackBar(
    content: Text('Fill Form Thoroughly'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainLabel("Preferred Location"),
              customTextField("Preferred Location", const Icon(Icons.place)),
              mainLabel("Skills: "),
              const Skills(),
              mainLabel("Job Experience: "),
              const Experience(),
              mainLabel("Date of Birth: "),
              const DateOfBirth(),
              mainLabel("Education "),
              const Education(),
              mainLabel("Languages: "),
              const Languages(),
              mainLabel("LinkedIn: "),
              customTextField(
                  "Linked In", const Icon(FontAwesomeIcons.linkedin)),
              InkWell(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    // padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: () async {
                  List skills = Skills.skillsList;
                  List experience = Experience.experienceFieldsList;
                  String? dob = DateOfBirth.dob;
                  List education = Education.educationFieldsList;
                  List languages = Languages.languagesList;
                  if (preferredLocation != null &&
                      skills.isNotEmpty &&
                      checkList(experience) &&
                      dob != null &&
                      checkList(education) &&
                      languages.isNotEmpty) {
                    debugPrint("Noicee");
                    Map profile = {
                      "uid": 1,
                      "prefloc": "mumbai",
                      "exp": experience,
                      "skills": skills,
                      "edu": education,
                      "lang": languages,
                      "dob": dob,
                      "linkedin": linkedIn,
                    };
                    bool status = await Network.createProfile(profile);
                    if (status) {
                      debugPrint("Added Successfully");
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const HomePage()));
                    } else {
                      debugPrint("API Error: Profile Not Created");
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(String text, Icon icon) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: label(icon, text),
          hintText: text,
        ),
        onChanged: (value) {
          if (text == "Preferred Location") {
            preferredLocation = value;
          } else if (text == "Linked In") {
            linkedIn = value;
          }
        },
      ),
    );
  }
}

Widget mainLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
    child: Text(
      text,
      textScaleFactor: 1.2,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget label(Icon icon, String text) {
  return FittedBox(
    child: Row(
      children: [
        icon,
        const SizedBox(
          width: 5,
        ),
        Text(text)
      ],
    ),
  );
}

Widget typeAhead(BuildContext context) {
  TextEditingController controller = TextEditingController();
  return TypeAheadField(
    textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: const InputDecoration(border: OutlineInputBorder())),
    suggestionsCallback: (pattern) async {
      return SkillsData.getSuggestions(pattern);
    },
    itemBuilder: (context, String? suggestion) {
      return ListTile(
        title: Text(suggestion!),
      );
    },
    onSuggestionSelected: (String? suggestion) {
      controller.text = suggestion!;
    },
  );
}
