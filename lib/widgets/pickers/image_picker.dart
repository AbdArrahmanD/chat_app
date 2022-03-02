import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  final void Function(File pickedImage) imagepickedFn;

  const PickImage(
    this.imagepickedFn, {
    Key? key,
  }) : super(key: key);

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? image;
  final ImagePicker _picker = ImagePicker();
  void chooseImage(ImageSource src) async {
    XFile? pickedImage = await _picker.pickImage(
      source: src,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
      widget.imagepickedFn(image!);
    } else {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: image != null ? FileImage(image!) : null,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () => chooseImage(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_back_outlined),
              label: Text(
                'Add Image\nFrom Camera',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton.icon(
              onPressed: () => chooseImage(ImageSource.gallery),
              icon: const Icon(Icons.image_outlined),
              label: Text(
                'Add Image\nFrom Gallery',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
