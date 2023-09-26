import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:projectsem4_mobile_itlearning/providers/NoteProvider.dart';
import 'package:provider/provider.dart';
import '../../models/Lesson/ItemOfLesson/Video/NoteInVideoDTO.dart';

class NoteList extends StatefulWidget {
  final List<NoteInVideoDTO> notes;

  NoteList({required this.notes});

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList>  {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft,child: Text("Notes in this video", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
            Column(
              children: widget.notes.map((note) {
                int durationInSeconds = note.duration!; // Giả sử note.duration là số giây
                Duration duration = Duration(seconds: durationInSeconds);
                String durationInHoursMinutesSeconds = duration.toString().split('.').first;
                DateTime createdAt = DateTime.parse(note.createdAt!); // Giả sử note.createdAt là một DateTime
                final formatter = DateFormat('dd/MM/yyyy-HH:mm:ss');
                String formattedDate = formatter.format(createdAt);
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.8), // background color
                                borderRadius: BorderRadius.circular(20), // border radius
                              ),
                              child: Text(
                                durationInHoursMinutesSeconds,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10// text color
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                                child: Text('Create at: ${formattedDate}',style: TextStyle(fontSize: 10),)),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 20.0,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                // Show a confirmation dialog
                                final bool? confirmDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm delete'),
                                      content: Text('Do you really want to delete this note?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () => Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () => Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // If the user confirmed the deletion
                                // If the user confirmed the deletion
                                if (confirmDelete == true) {
                                  // Delete the note
                                  await Provider.of<NoteProvider>(context, listen: false).deleteNote(note.id!, context);

                                  // Then call setState to refresh the UI
                                  setState(() {
                                    // Your state update logic here
                                    // For example, you might want to remove the deleted note from the list
                                    widget.notes.remove(note);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      subtitle: Container(
                        padding: EdgeInsets.all(8.0), // padding around the text
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.2), // background color
                          borderRadius: BorderRadius.circular(10), // border radius
                        ),
                        child: Text(
                          note.content!,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10// text color
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}