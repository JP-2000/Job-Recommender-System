import 'package:flutter/material.dart';

class Skills extends StatefulWidget {
  const Skills({Key? key}) : super(key: key);
  static List skillsList = [];

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            child: Skills.skillsList.isEmpty
                ? Container()
                : Container(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 10,
                      children: Skills.skillsList
                          .map((value) => skillsItem(value))
                          .toList(),
                    ),
                  )),
        customTextField("Skills", const Icon(Icons.code)),
      ],
    );
  }

  Widget skillsItem(String text) {
    return Container(
        color: Colors.grey.withOpacity(0.2),
        margin: const EdgeInsets.only(top: 5),
        child: FittedBox(
          child: Row(
            children: [
              Text(text),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                child: const Icon(Icons.close),
                onTap: () {
                  setState(() {
                    Skills.skillsList.remove(text);
                  });
                },
              )
            ],
          ),
        ));
  }

  Widget customTextField(String text, Icon icon) {
    TextEditingController controller = TextEditingController();
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: label(icon, text),
          hintText: text,
        ),
        onSubmitted: (value) {
          setState(() {
            Skills.skillsList.add(value);
            controller.clear();
          });
        },
      ),
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
