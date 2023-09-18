import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/providers/ExerciseProvider.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../../models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';
import '../../models/Lesson/Lesson.dart';
import '../../providers/CourseKeyProvider.dart';
import '../TheoryExercise/DoExercisePage.dart';
import '../TheoryExercise/ExercisesPage.dart';
import '../TheoryExercise/SubmittedExercisesPage.dart';


class CourseDataPage extends StatefulWidget {
  final int? id;
  CourseDataPage({this.id});

  @override
  _CourseDataPageState createState() => _CourseDataPageState();


}

class _CourseDataPageState extends State<CourseDataPage> {
  ChewieController? _chewieController;
  String? playingVideoUrl;
  bool isLoading = false;
  ValueNotifier<ItemOfLesson?> _selectedItemNotifier = ValueNotifier<ItemOfLesson?>(null);
  ValueNotifier<ChewieController?> _chewieControllerNotifier = ValueNotifier<ChewieController?>(null);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadFirstIncompleteVideo();
    });
  }

  Future<void> _loadFirstIncompleteVideo() async {
    final lessons = await Provider.of<CourseKeyProvider>(context, listen: false).fetchCourseData(widget.id!);
    for (var lesson in lessons) {
      for (var item in lesson.itemOfLessons!) {
        if ((item.type ?? '') == 'VIDEO' && item.complete == false) {
          await _initializePlayer(item.videoCourse!.urlVideo!);
          return;
        }
      }
    }
  }

  Future<void> _initializePlayer(String url) async {
    final oldVideoPlayerController = _chewieControllerNotifier.value?.videoPlayerController;
    final videoPlayerController = VideoPlayerController.network(url);

    await videoPlayerController.initialize();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Data'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 250, // replace with your desired height
              width: 350, // replace with your desired width
              child: ValueListenableBuilder<ChewieController?>(
                valueListenable: _chewieControllerNotifier,
                builder: (context, value, child) {
                  return value != null
                      ? Chewie(
                    controller: value,
                  )
                      : Container();
                },
              ),
            ),
          ),
          FutureBuilder<List<Lesson>>(
            future: Provider.of<CourseKeyProvider>(context, listen: false)
                .fetchCourseData(widget.id!),
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
                      _initializePlayer(item.videoCourse!.urlVideo!);
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
                      itemBuilder: (ctx, i) =>
                          _buildLessonItem(snapshot.data![i]),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(Lesson lesson) {
    var title = lesson.title ?? 'No title available';
    var itemOfLessons = lesson.itemOfLessons ?? [];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
        ),
        child: ExpansionTile(
          title: Text('$title (${itemOfLessons.length})'),
          children: itemOfLessons.map((item) => _buildLessonSubItem(item))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLessonSubItem(ItemOfLesson item) {
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
              onTap: () async {
                if ((item.type ?? '') == 'VIDEO') {
                  await _initializePlayer(item.videoCourse!.urlVideo!);
                  _selectedItemNotifier.value = item;
                }
                if((item.type ?? '') == 'THEORY'){

                  await Provider.of<ExerciseProvider>(context, listen: false).getTheoryExercise(item.theoryExercise!.id!);
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