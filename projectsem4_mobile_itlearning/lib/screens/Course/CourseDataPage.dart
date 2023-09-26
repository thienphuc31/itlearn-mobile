import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:projectsem4_mobile_itlearning/models/CourseKey/CourseKey.dart';
import 'package:projectsem4_mobile_itlearning/providers/ExerciseProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/NoteProvider.dart';
import 'package:projectsem4_mobile_itlearning/screens/ExerciseHome/ExerciseHomePage.dart';
import 'package:projectsem4_mobile_itlearning/screens/ExerciseHome/SubmittedExerciseHome.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../models/Lesson/ItemOfLesson/Video/NoteInDurationDTO.dart';
import '../../models/Lesson/ItemOfLesson/Video/NoteInVideoDTO.dart';
import '../../models/Lesson/Lesson.dart';
import '../../providers/CourseKeyProvider.dart';
import '../TheoryExercise/DoExercisePage.dart';
import '../TheoryExercise/SubmittedExercisesPage.dart';
import 'NoteList.dart';


class CourseDataPage extends StatefulWidget {
  final CourseKey? courseKey;
  CourseDataPage({this.courseKey});

  @override
  _CourseDataPageState createState() => _CourseDataPageState();


}

class _CourseDataPageState extends State<CourseDataPage> {
  ChewieController? _chewieController;
  String? playingVideoUrl;
  bool isLoading = false;
  ItemOfLesson? iol;
  bool isNoteTaking = false;
  bool canComplete = false;
  late bool isCompleted = iol!.complete!;


  ValueNotifier<ItemOfLesson?> _selectedItemNotifier = ValueNotifier<ItemOfLesson?>(null);
  ValueNotifier<ChewieController?> _chewieControllerNotifier = ValueNotifier<ChewieController?>(null);
  final TextEditingController _contentController = TextEditingController();
  ValueNotifier<double> _progressNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<Future<List<Lesson>>>? futureNotifier;
  ValueNotifier<Lesson?> _selectedLessonNotifier = ValueNotifier<Lesson?>(null);


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadFirstIncompleteVideo();
    });
    _chewieControllerNotifier.addListener(_updateProgress);
    futureNotifier = ValueNotifier(
        Provider.of<CourseKeyProvider>(context, listen: false).fetchCourseData(widget.courseKey!.id!)
    );
  }

  void _updateProgress() {
    if (_chewieControllerNotifier.value?.videoPlayerController.value.isInitialized ?? false) {
      double progress = _chewieControllerNotifier.value!.videoPlayerController.value.position.inSeconds / _chewieControllerNotifier.value!.videoPlayerController.value.duration.inSeconds;
      _progressNotifier.value = progress;
    }
  }
  Future<void> _loadFirstIncompleteVideo() async {
    final lessons = await Provider.of<CourseKeyProvider>(context, listen: false).fetchCourseData(widget.courseKey!.id!);
    for (var lesson in lessons) {
      for (var item in lesson.itemOfLessons!) {
        if ((item.type ?? '') == 'VIDEO' && item.complete == false) {
          await _initializePlayer(item, context);
          return;
        }
      }
    }
  }

  Future<void> _initializePlayer(ItemOfLesson IoL, BuildContext context) async {
    iol = IoL;
    final oldVideoPlayerController = _chewieControllerNotifier.value?.videoPlayerController;
    final videoPlayerController = VideoPlayerController.network(iol!.videoCourse!.urlVideo!);
    await videoPlayerController.initialize();
    await Provider.of<NoteProvider>(context,listen:  false).getNote(iol!.videoCourse!.id!, context);
    videoPlayerController.addListener(()  {
      _updateProgress();
      // This will be called whenever the video position changes
    });  // Add this line
    _chewieControllerNotifier.value = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
    );

    oldVideoPlayerController?.dispose();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  String _formatDuration(int duration) {
    int hours = duration ~/ 3600;
    int minutes = (duration % 3600) ~/ 60;
    int seconds = duration % 60;

    if (hours == 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${hours}h ${minutes}m ${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    print("aaa");
    return Scaffold(
      
      appBar: AppBar(
        title: Text(widget.courseKey!.title!,style: TextStyle(fontSize: 17),),
        backgroundColor: primaryBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          width: 500,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    ValueListenableBuilder<ChewieController?>(
                      valueListenable: _chewieControllerNotifier,
                      builder: (context, value, child) {

                        return (value != null && value.videoPlayerController.dataSource != '')
                            ? Column(
                          children: <Widget>[
                            Container(
                              height: 250, // replace with your desired height
                              width: 350, // replace with your desired width
                              child: Chewie(
                                controller: value,
                              ),
                            ),
                            Column(
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ValueListenableBuilder<double>(
                                      valueListenable: _progressNotifier,
                                      builder: (context, progress, child) {
                                        // WidgetsBinding.instance!.addPostFrameCallback((_) {
                                        //   setState(() {
                                        //     canComplete = progress >= 0.7;
                                        //   });
                                        // });
                                        return Row(
                                          children: [ // Only show the 'Complete' button if the video has been fully watched
                                            isCompleted
                                                ? Container(

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
                                                  Text(
                                                    'Completed',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white, // font size of text
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                                : TextButton(
                                              child: Text(
                                                'Complete',
                                                style: TextStyle(
                                                  color: Colors.white, // This changes the color of the text
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor: progress >= 0.7 ? Colors.green : Colors.grey, // This changes the color of the button
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5), // This changes the border radius
                                                ),
                                              ),
                                              onPressed: progress >= 0.7 ? () async{
                                                if (iol != null && iol!.id! != null) {
                                                  await Provider.of<CourseKeyProvider>(context, listen: false).completeItemofLesson(iol!.id!, context);
                                                  setState(() {
                                                    futureNotifier = ValueNotifier(
                                                        Provider.of<CourseKeyProvider>(context, listen: false).fetchCourseData(widget.courseKey!.id!)
                                                    );
                                                    canComplete == !canComplete;
                                                    isCompleted = true;
                                                  });
                                                } else {
                                                  print('iol or id is null');
                                                }
                                              } : null, // ,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Spacer(),
                                    TextButton(
                                      child: Text(
                                        'Note List',
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
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Consumer<NoteProvider>(
                                              builder: (context, noteProvider, child) {
                                                if (noteProvider.listNote == null) {
                                                  return CircularProgressIndicator();  // Hiển thị spinner nếu dữ liệu chưa sẵn sàng
                                                } else {
                                                  return NoteList(notes: noteProvider.listNote!);
                                                }
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(width: 5),
                                    TextButton(
                                      child: Text(
                                        'Take Note',
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
                                        setState(() {
                                          isNoteTaking = !isNoteTaking;
                                        });

                                      },
                                    ),
                                  ],
                                ),
                                if(canComplete)
                                  Text("Now you can complete this lesson!",
                                  style: TextStyle(fontSize: 20,color: Colors.green ),),
                                if (isNoteTaking)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      children: [
                                        Align(alignment: Alignment.centerLeft,child: Text("Note content", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                        TextField(
                                          controller: _contentController,
                                          decoration: InputDecoration(
                                            labelText: "Type note here",
                                            border: OutlineInputBorder(),
                                          ),
                                          onSubmitted: (text) async {
                                            // If _contentController is empty, set isNoteTaking = false and return
                                            if (_contentController.text.isEmpty) {
                                              setState(() {
                                                isNoteTaking = false;
                                              });
                                              return;
                                            }
                                            int duration = _chewieControllerNotifier.value?.videoPlayerController!.value!.position?.inSeconds ?? 0;

                                            // Create the NoteInDurationDTO
                                            final NoteInDurationDTO note = NoteInDurationDTO(
                                              duration: duration,
                                              content: text,
                                              videoCourseId: iol!.videoCourse!.id!,
                                            );

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
                                              await Provider.of<NoteProvider>(context, listen: false).createNoteInDuration(note, context);
                                              _contentController.clear();
                                              setState(() {
                                                isNoteTaking = false;
                                              });// Clear the text field

                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                
                              ],
                            ),
                          ],
                        )
                            : Container();
                      },
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: futureNotifier!,
                builder: (context, value, child) {
                  return FutureBuilder<List<Lesson>>(
                    future: value,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.error != null) {
                        return Center(child: Text('An error occurred!'));
                      } else if (snapshot.data == null) {
                        return Center(child: Text('No data available!'));
                      } else {
                        for (var lesson in snapshot.data!) {
                          for (var item in lesson.itemOfLessons!) {
                            if ((item.type ?? '') == 'VIDEO' &&
                                item.complete == false) {
                              _initializePlayer(item, context);
                              break;
                            }
                          }
                          if (_chewieController != null) {
                            break;
                          }
                        }
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (ctx, i) => _buildLessonItem(snapshot.data![i], futureNotifier),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonItem(Lesson lesson, ValueNotifier<Future<List<Lesson>>>? futureNotifier ) {
    var title = lesson.title ?? 'No title available';
    var itemOfLessons = lesson.itemOfLessons ?? [];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder<Lesson?>(
        valueListenable: _selectedLessonNotifier,
        builder: (context, selectedLesson, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: selectedLesson == lesson ? Colors.red : Colors.blueAccent),
            ),
            child: ExpansionTile(
              title: Text('$title (${itemOfLessons.length})',
                style: TextStyle(fontSize: 15),
              ),
              children: itemOfLessons.map((item) => _buildLessonSubItem(item, futureNotifier)).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonSubItem(ItemOfLesson item, ValueNotifier<Future<List<Lesson>>>? futureNotifier) {
    ItemOfLesson? firstIncompleteItem;

    Future<void> assignFirstIncompleteLesson(ValueNotifier<Future<List<Lesson>>>? futureNotifier) async {
      if (futureNotifier == null) {
        return;
      }

      List<Lesson>? lessons = await futureNotifier.value;
      if (lessons == null) {
        return;
      }

      for (Lesson lesson in lessons) {
        for (ItemOfLesson a in lesson.itemOfLessons!) { // Assuming 'items' is the list of ItemOfLesson in a Lesson
          if (a.complete == false) {
            firstIncompleteItem = a;
            return;
          }
        }
      }
    }
    var itemTitle = item.title ?? 'No item title available';
    return ValueListenableBuilder<ItemOfLesson?>(
      valueListenable: _selectedItemNotifier,
      builder: (context, selectedItem, child) {
        return Container(
          color: item == selectedItem ? Colors.blue : null,
          child: ListTile(
            title: Text(
              itemTitle,
              style: TextStyle(
                fontSize: 14,

              ),
            ),
            leading: item.complete == true ? Icon(Icons.done) : null,
              onTap: () async
              {
                await assignFirstIncompleteLesson(futureNotifier);
                if (item == firstIncompleteItem || item.complete == true ) {
                  // If the item is not the first incomplete item, return immediately.
                  if ((item.type ?? '') == 'VIDEO') {
                    setState(() {
                      iol = item;
                    });
                    _selectedItemNotifier.value = item;
                    await _initializePlayer(item, context);
                    await Provider.of<NoteProvider>(context,listen:  false).getNote(item!.videoCourse!.id!, context);
                    // await Provider.of<NoteProvider>(context,listen:  false).getNote(item!.videoCourse!.id!, context);
                  }
                  if((item.type ?? '') == 'THEORY'){
                    await Provider.of<ExerciseProvider>(context, listen: false).getTheoryExercise(item.theoryExercise!.id!, context);
                    var submittedExerciseData = Provider.of<ExerciseProvider>(context, listen: false).submittedExerciseData;

                    if (submittedExerciseData != null && submittedExerciseData.status == "SUBMITTED") {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SubmittedExercisesPage(),
                      ));
                    }else if (submittedExerciseData != null && submittedExerciseData.status == "WORKING"){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DoExercisePage(),
                      ));
                    }
                    else {
                      print('submittedExerciseData is null');
                    }
                  }
                  if (item.type == 'EXERCISE' && item.complete == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubmittedExerciseHome(itemOfLesson: item)),
                    );
                  }
                  if (item.type == 'EXERCISE' && item.complete == false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExerciseHomePage(itemOfLesson: item, courseKey: widget.courseKey)),
                    );
                  }
                }
                else {
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

              },
            subtitle: (item.type ?? '') == 'VIDEO'
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.slow_motion_video_outlined),
                SizedBox(width: 5),
                Text(_formatDuration(item.videoCourse!.duration!)),
              ],
            )
                : null,
          ),
        );
      },
    );
  }
}





