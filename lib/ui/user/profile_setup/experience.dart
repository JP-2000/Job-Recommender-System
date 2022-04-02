import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Experience extends StatefulWidget {
  const Experience({Key? key}) : super(key: key);
  static List experienceFieldsList = [
    {
      "jobTitle": "",
      "companyName": "",
      "startDate": "",
      "endDate": "",
      "jobDescription": ""
    }
  ];
  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  late List<Widget> experienceWidgetList = [experienceItem(0)];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: experienceWidgetList.length,
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
                      experienceWidgetList[index],
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
                              if (experienceWidgetList.length > 1) {
                                experienceWidgetList.removeAt(index);
                                Experience.experienceFieldsList.removeAt(index);
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
                  int index = experienceWidgetList.length;
                  experienceWidgetList.add(experienceItem(index));
                  Experience.experienceFieldsList.add({
                    "jobTitle": "",
                    "companyName": "",
                    "startDate": "",
                    "endDate": "",
                    "jobDescription": ""
                  });
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
          if (text == "Job Title") {
            Experience.experienceFieldsList[index]['jobTitle'] = value;
          } else if (text == "Company Name") {
            Experience.experienceFieldsList[index]['companyName'] = value;
          }
        },
      ),
    );
  }

  Widget descriptionTextField(String text, Icon icon, int index) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        maxLines: null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: label(icon, text),
          hintText: text,
        ),
        onChanged: (value) {
          Experience.experienceFieldsList[index]['jobDescription'] = value;
        },
      ),
    );
  }

  Widget customDatePicker(String text, Icon icon, int index) {
    TextEditingController controller = TextEditingController();
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: label(icon, text),
          hintText: text,
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime.now());

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
            setState(() {
              controller.text = formattedDate;
              if (text == "Start Date") {
                Experience.experienceFieldsList[index]['startDate'] =
                    formattedDate;
              } else if (text == "End Date") {
                Experience.experienceFieldsList[index]['endDate'] =
                    formattedDate;
              }
            });
          } else {
            debugPrint("Date is not selected");
          }
        },
      ),
    );
  }

  Widget experienceItem(int index) {
    return Column(
      children: [
        customTextField("Job Title", const Icon(Icons.edit), index),
        customTextField("Company Name", const Icon(Icons.edit), index),
        customDatePicker("Start Date", const Icon(Icons.calendar_today), index),
        customDatePicker("End Date", const Icon(Icons.calendar_today), index),
        descriptionTextField(
            "Job Description", const Icon(Icons.description), index)
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
