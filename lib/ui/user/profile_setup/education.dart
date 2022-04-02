import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Education extends StatefulWidget {
  const Education({Key? key}) : super(key: key);
  static List educationFieldsList = [
    {"collegeName": "", "degree": "", "percentage": ""}
  ];
  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  late List<Widget> educationWidgetList = [educationItem(0)];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: educationWidgetList.length,
          itemBuilder: (context, index) =>
              // wrap with container
              Container(
                  margin: const EdgeInsets.all(10),
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      educationWidgetList[index],
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 10.0, bottom: 10.0),
                        child: InkWell(
                          child: const Text("Remove",
                              style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                              )),
                          onTap: () {
                            setState(() {
                              if (educationWidgetList.length > 1) {
                                educationWidgetList.removeAt(index);
                                Education.educationFieldsList.removeAt(index);
                              } else {
                                debugPrint("Need at least item");
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  )),
        ),
        SizedBox(
          height: 30,
          width: 30,
          child: FittedBox(
            child: FloatingActionButton(
              child: const Icon(
                FontAwesomeIcons.plus,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  int index = educationWidgetList.length;
                  educationWidgetList.add(educationItem(index));
                  Education.educationFieldsList
                      .add({"collegeName": "", "degree": "", "percentage": ""});
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget customTextField(String text, Icon icon, int index) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: label(icon, text),
          hintText: text,
        ),
        onChanged: (value) {
          if (text == "College Name") {
            Education.educationFieldsList[index]['collegeName'] = value;
          } else if (text == "Degree Name") {
            Education.educationFieldsList[index]['degree'] = value;
          } else if (text == "Percentage") {
            Education.educationFieldsList[index]['percentage'] = value;
          }
        },
      ),
    );
  }

  Widget educationItem(int index) {
    return Column(
      children: [
        customTextField("College Name", const Icon(Icons.school), index),
        customTextField("Degree Name", const Icon(Icons.school), index),
        customTextField(
            "Percentage", const Icon(FontAwesomeIcons.percentage), index),
      ],
    );
  }
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
