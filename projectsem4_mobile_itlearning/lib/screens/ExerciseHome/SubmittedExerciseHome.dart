import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../constants/colors.dart';
import '../../models/Lesson/Lesson.dart';

class SubmittedExerciseHome extends StatelessWidget {
  final ItemOfLesson? itemOfLesson;

  // Constructor that accepts an ExerciseData object
  SubmittedExerciseHome({required this.itemOfLesson});
  void _launchURL() async {
    final url = itemOfLesson!.exerciseHome!.urlDocument!;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController(text: itemOfLesson!.exerciseHome!.yourUrlDocument);
    return Scaffold(
      appBar: AppBar(
        title: Text(itemOfLesson!.title!),
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
              padding: EdgeInsets.all(6.0), // padding for the text inside the container
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black87// border radius
              ),
              child: Text(
                itemOfLesson!.exerciseHome!.description!,
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
                labelText: "Submit link",
                border: OutlineInputBorder(),
              ),
                enabled: false
            ),
            Align(
              alignment: Alignment.center,
              child: itemOfLesson!.exerciseHome!.marked == false
                  ? TextButton(
                child: Text(
                  'Pending...',
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
                onPressed: () {
                  // Your code here...
                },
              )
                  : Text('Marked: ${itemOfLesson!.exerciseHome!.mark!}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),), // Replace with your 'Marked' widget
            ),
            if(itemOfLesson!.exerciseHome!.marked!)
              Text("Mentor's feedback", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            if (itemOfLesson?.exerciseHome?.mentorDescription != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.0), // padding for the text inside the container
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: primaryBlue.withOpacity(0.8)// border radius
              ),
              child: Text(
                itemOfLesson!.exerciseHome!.mentorDescription!,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}