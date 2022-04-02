import 'package:flutter/material.dart';

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);
  static List languagesList = [];
  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            child: Languages.languagesList.isEmpty
                ? Container()
                : Container(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 10,
                      children: Languages.languagesList
                          .map((value) => skillsItem(value))
                          .toList(),
                    ),
                  )),
        customTextField("Languages", const Icon(Icons.language)),
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
                  Languages.languagesList.remove(text);
                });
              },
            )
          ],
        ),
      ),
    );
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
            Languages.languagesList.add(value);
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
