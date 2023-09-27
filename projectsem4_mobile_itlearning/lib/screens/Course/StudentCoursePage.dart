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
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<StudentCourseProvider>(context, listen: false).fetchStudentCourses(context);
        },
        child: FutureBuilder(
          future: Provider.of<StudentCourseProvider>(context, listen: false).fetchStudentCourses(context),
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
                      itemBuilder: (ctx, i) => ListTile(
                        title: Container(
                          padding: EdgeInsets.all(10.0), // Add some padding to the container
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.6), // Set the background color
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${courses[i].title ?? 'No title'}',
                                  style: DefaultTextStyle.of(context).style.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  '${courses[i].dateStart ?? ''} to ${courses[i].dateEnd ?? ''}',
                                  style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12), // Change the font size here
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Provider.of<CourseKeyProvider>(context, listen: false).fetchCourseKeyList(courses[i].id!);
                        },
                        subtitle: Container(
                          padding: EdgeInsets.all(16.0),
                          color: primaryYellow.withOpacity(0.4),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CircularPercentIndicator(
                                      radius: 30.0,
                                      lineWidth: 6.0,
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
                                      radius: 30.0,
                                      lineWidth: 6.0,
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
                                      radius: 30.0,
                                      lineWidth: 6.0,
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
                              SizedBox(height: 16),
                              ExpansionTile(
                                title: Text('Course chapters'),
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
                                              final courseKeys = courseKeyProvider.getCourseKeys(courses[i].id!);
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
                                                          Image(
                                                            image: NetworkImage(courseKeys[index].thumbnail ?? 'https://www.stellarinfo.com/blog/wp-content/uploads/2018/05/Media-file-error-in-online-video.png'),
                                                            width: 40, // You can adjust the size as needed.
                                                            height: 40, // You can adjust the size as needed.
                                                          ),
                                                          SizedBox(width: 8), // Add some spacing between the image and the text
                                                          Expanded(child: Text(courseKeys[index].title ?? 'No title')),
                                                          SizedBox(width: 8),
                                                          CircularPercentIndicator(
                                                            radius: 15.0,
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
                                                        if (courseKeys[index] != null) {
                                                          if (courseKeys[index].allowAccess!) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => CourseDataPage(courseKey: courseKeys[index]),
                                                              ),
                                                            );
                                                          } else {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                title: Text('Notice'),
                                                                content: Text('Please complete the previous.'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: Text('OK'),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          print('courseKeys[index] is null');
                                                        }
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
                                  SizedBox(height: 16),
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
      ),
    );
  }
}
