import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../providers/CourseKeyProvider.dart';
import '../../providers/StudentCourseProvider.dart';
import 'CourseDataPage.dart';

class StudentCoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<StudentCourseProvider>(context, listen: false).fetchStudentCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Consumer<StudentCourseProvider>(
              builder: (ctx, studentCourseProvider, _) {
                final courses = studentCourseProvider.course;
                if (courses.isEmpty) {
                  return Center(child: Text('No courses found.'));
                } else {
                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (ctx, i) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(courses[i].title ?? 'No title'),
                        onTap: () {
                          Provider.of<CourseKeyProvider>(context, listen: false).fetchCourseKeyList(courses[i].id!);
                        },
                        subtitle: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CircularPercentIndicator(
                                    radius: 35.0,
                                    lineWidth: 8.0,
                                    percent: courses[i].percentVideo != null ? courses[i].percentVideo! / 100 : 0,
                                    center: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${(courses[i].percentVideo != null ? courses[i].percentVideo! : 0)}%",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                                        ),
                                        Icon(Icons.slow_motion_video_outlined, size: 15.0,)
                                      ],
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.green,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CircularPercentIndicator(
                                    radius: 35.0,
                                    lineWidth: 8.0,
                                    percent: courses[i].percentExercise != null ? courses[i].percentExercise! / 100 : 0,
                                    center: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${(courses[i].percentExercise != null ? courses[i].percentExercise! : 0)}%",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                                        ),
                                        Icon(Icons.home_work_outlined, size: 15.0,)
                                      ],
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.yellow,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CircularPercentIndicator(
                                    radius: 35.0,
                                    lineWidth: 8.0,
                                    percent: courses[i].percentTheory != null ? courses[i].percentTheory! / 100 : 0,
                                    center: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${(courses[i].percentTheory != null ? courses[i].percentTheory! : 0)}%",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                                        ),
                                        Icon(Icons.quiz_outlined, size: 15.0,)
                                      ],
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text('Các chương của khoá học'),
                              children: <Widget>[
                                FutureBuilder(
                                  future: Provider.of<CourseKeyProvider>(context, listen: false).fetchCourseKeyList(courses[i].id!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator()); // Show loading indicator while waiting
                                    } else {
                                      if (snapshot.error != null) {
                                        // Do error handling here
                                        return Center(child: Text('An error occurred!'));
                                      } else {
                                        return Consumer<CourseKeyProvider>(
                                          builder: (context, courseKeyProvider, _) {
                                            final courseKeys = courseKeyProvider.courseList;
                                            if (courseKeys.isEmpty) {
                                              return Text('No course keys found.');
                                            } else {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: courseKeys.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Row(
                                                      children: [
                                                        // Image(
                                                        //   image: NetworkImage(courseKeys[index].thumbnail ?? 'https://www.stellarinfo.com/blog/wp-content/uploads/2018/05/Media-file-error-in-online-video.png'),
                                                        //   width: 50, // You can adjust the size as needed.
                                                        //   height: 50, // You can adjust the size as needed.
                                                        // ),
                                                        SizedBox(width: 8), // Add some spacing between the image and the text
                                                        Expanded(child: Text(courseKeys[index].title ?? 'No title')),
                                                        SizedBox(width: 8),
                                                        CircularPercentIndicator(
                                                          radius: 20.0,
                                                          lineWidth: 4.0,
                                                          percent: courseKeys[index].percentCompleted != null ? courseKeys[index].percentCompleted! / 100 : 0,
                                                          center: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                "${(courseKeys[index].percentCompleted != null ? courseKeys[index].percentCompleted! : 0)}%",
                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8.0),
                                                              )

                                                            ],
                                                          ),
                                                          circularStrokeCap: CircularStrokeCap.round,
                                                          progressColor: primaryBlue,
                                                        ),
                                                        // Add more properties as needed
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => CourseDataPage(id: courseKeys[index].id),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                              onExpansionChanged: (bool expanding) {
                                if (expanding) {
                                  Provider.of<CourseKeyProvider>(context, listen: false).fetchCourseKeyList(courses[i].id!);
                                }
                              },
                            ),
                          ],
                        ),


                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
