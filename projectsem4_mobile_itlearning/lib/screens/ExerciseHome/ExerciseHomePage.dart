import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';
import 'package:projectsem4_mobile_itlearning/providers/ExerciseProvider.dart';
import 'package:projectsem4_mobile_itlearning/screens/Course/CourseDataPage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../models/CourseKey/CourseKey.dart';
import '../../models/Lesson/Lesson.dart';

class ExerciseHomePage extends StatefulWidget {
  final CourseKey? courseKey;
  final ItemOfLesson? itemOfLesson;

  // Constructor that accepts an ExerciseData object
  ExerciseHomePage({required this.itemOfLesson, required this.courseKey});

  @override
  _ExerciseHomePageState createState() => _ExerciseHomePageState();
}

class _ExerciseHomePageState extends State<ExerciseHomePage> {
  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  void _launchURL() async {
    final url = widget.itemOfLesson!.exerciseHome!.urlDocument!;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.itemOfLesson!.title!),
        backgroundColor: primaryBlue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0), // padding for the text inside the container
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black87.withOpacity(0.8)// border radius
              ),
              child: Text(
                widget.itemOfLesson!.exerciseHome!.description!,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold// font size of text
                ),
                softWrap: true,
              ),
            ),
            TextButton(
              onPressed: _launchURL,
              child: Text(
                'Link description',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            // Text('Mark: ${exerciseHome.mark}', style: TextStyle(fontSize: 24)),
            Container(
              padding: EdgeInsets.all(6.0), // padding for the text inside the container
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.green// border radius
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check, // this is the icon
                    color: Colors.white, // this is the color of the icon
                  ),
                  SizedBox(width: 10), // this adds some space between the icon and the text
                  Expanded( // use Expanded here
                    child: Text(
                      'You can upload the source code to GITHUB, GOOGLE DRIVE,... make it public then submit your work',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold// font size of text
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: myController,
              decoration: InputDecoration(
                labelText: "Type note here",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) async {

                if (myController.text.isEmpty) {
                  return;
                }

                // Show confirmation dialog
                bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm'),
                      content: Text('Are you sure you want to create this note?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(false); // Dismiss dialog and return false
                          },
                        ),
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(true); // Dismiss dialog and return true
                          },
                        ),
                      ],
                    );
                  },
                );

                // If confirmed, call the createNoteInDuration function
                if (confirmed == true) {


                }
              },
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white, // This changes the color of the text
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: primaryBlue, // This changes the color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // This changes the border radius
                  ),
                ),
                onPressed: () async {
                  await Provider.of<ExerciseProvider>(context, listen: false).submitHWExercise(widget.itemOfLesson!.exerciseHome!.id!, myController.text, context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CourseDataPage(courseKey: widget.courseKey)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}