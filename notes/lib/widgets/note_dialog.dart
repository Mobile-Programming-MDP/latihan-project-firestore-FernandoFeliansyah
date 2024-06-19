import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/location_services.dart';
import 'package:notes/services/note_service.dart';
import 'dart:io' as io;

class NoteDialog extends StatefulWidget {
  final Note? note;

  NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _imageFile;
  Position? _position;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getLocation() async {
    final location = await LocationService().getCurrentLocation();
    setState(() {
      _position = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Add Note' : 'Update Note'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Title:'),
          TextField(
            controller: _titleController,
          ),
          const SizedBox(height: 20),
          const Text('Description:'),
          TextField(
            controller: _descriptionController,
          ),
          const SizedBox(height: 20),
          const Text('Image:'),
          Expanded(
            child: _imageFile != null
                ? Image.file(io.File(_imageFile!.path), fit: BoxFit.fill)
                : widget.note?.imageUrl != null &&
                        Uri.parse(widget.note!.imageUrl!).isAbsolute
                    ? Image.network(widget.note!.imageUrl!, fit: BoxFit.fill)
                    : Container(),
          ),
          TextButton(
            onPressed: _showImagePickerOptions,
            child: const Text('Pick Image'),
          ),
          TextButton(
            onPressed: _getLocation,
            child: const Text('Get Location'),
          ),
          Text(
            _position != null
                ? "Current Location: ${_position!.latitude}, ${_position!.longitude}"
                : widget.note?.lat != null && widget.note?.lng != null
                    ? "Current Location: ${widget.note!.lat}, ${widget.note!.lng}"
                    : "Current Location: Not Set",
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            String? imageUrl;
            if (_imageFile != null) {
              imageUrl = await NoteService.uploadImage(_imageFile!);
            } else {
              imageUrl = widget.note?.imageUrl;
            }

            Note note = Note(
              id: widget.note?.id,
              title: _titleController.text,
              description: _descriptionController.text,
              imageUrl: imageUrl,
              lat: _position != null
                  ? _position!.latitude.toString()
                  : widget.note?.lat,
              lng: _position != null
                  ? _position!.longitude.toString()
                  : widget.note?.lng,
              createdAt: widget.note?.createdAt,
            );

            if (widget.note == null) {
              await NoteService.addNote(note);
            } else {
              await NoteService.updateNote(note);
            }
            Navigator.of(context).pop();
          },
          child: Text(widget.note == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
