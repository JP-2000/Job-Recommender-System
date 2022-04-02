import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirth extends StatefulWidget {
  const DateOfBirth({Key? key}) : super(key: key);
  static String? dob;
  @override
  State<DateOfBirth> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        //editing controller of this TextField
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: label(const Icon(Icons.calendar_today), "Date of Birth"),
          hintText: "Date of Birth", //label text of field
        ),
        readOnly: true, //set it true, so that user will not able to edit text
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
              DateOfBirth.dob =
                  formattedDate; //set output date to TextField value.
            });
          } else {
            debugPrint("Date is not selected");
          }
        },
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
}
