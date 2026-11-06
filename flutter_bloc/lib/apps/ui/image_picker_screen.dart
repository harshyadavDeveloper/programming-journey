import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/Image_picker/image_picker_bloc.dart';
import 'package:flutter_blocs/apps/bloc/Image_picker/image_picker_event.dart';
import 'package:flutter_blocs/apps/bloc/Image_picker/image_picker_state.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker Screen')),
      body: Center(
  child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
    builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          state.file == null
              ? const CircleAvatar(
                  child: Icon(Icons.camera),
                )
              : Image.file(File(state.file!.path)),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ImagePickerBloc>().add(
                    CaptureImageFromCamera(),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
              ),

              const SizedBox(width: 15),

              ElevatedButton.icon(
                onPressed: () {
                  context.read<ImagePickerBloc>().add(
                    PickImageFromGallery(),
                  );
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ],
          ),
        ],
      );
    },
  ),
),
    );
  }
}
