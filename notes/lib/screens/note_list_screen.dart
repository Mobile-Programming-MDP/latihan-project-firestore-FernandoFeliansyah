import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/google_maps_screen.dart';
import 'package:notes/services/note_service.dart';
import 'package:notes/widgets/note_dialog.dart';
import 'package:notes/widgets/theme.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Provider.of<ThemeProvider>(context).isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return NoteDialog();
            },
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  void _shareContent(Note document) {
    Share.share(
        'Check out my note: ${document.title}\n${document.description}');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NoteService.getNoteList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: snapshot.data!.map((document) {
                return Card(
                  child: Column(
                    children: [
                      if (document.imageUrl != null &&
                          Uri.parse(document.imageUrl!).isAbsolute)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            document.imageUrl!,
                            width: double.infinity,
                            height: 500,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                      ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return NoteDialog(note: document);
                            },
                          );
                        },
                        title: Text(document.title),
                        subtitle: Text(document.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                String shareText =
                                    "Check out this note: " + "\n" +
                                    "\nTitle : ${document.title}" + "\n" +
                                    "\nDescription : ${document.description}"+ "\n"; 
                                if (document.imageUrl != null) {
                                  shareText += "\nImage: ${document.imageUrl}";
                                }
                                Share.share(shareText);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Icon(Icons.share),
                              ),
                            ),
                            const SizedBox(),
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GoogleMapsScreen(
                                          latitude: double.parse(document.lat!),
                                          longitude:
                                              double.parse(document.lng!)),
                                    ));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Icon(Icons.map),
                              ),
                            ),
                            const SizedBox(),
                            InkWell(
                              onTap: () {
                                showAlertDialog(context, document);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void showAlertDialog(BuildContext context, Note document) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Yes"),
      onPressed: () {
        NoteService.deleteNote(document).whenComplete(() {
          Navigator.of(context).pop();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Note"),
      content: const Text("Are you sure to delete Note?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
