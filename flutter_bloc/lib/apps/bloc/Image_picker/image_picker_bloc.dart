import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/Image_picker/image_picker_event.dart';
import 'package:flutter_blocs/apps/bloc/Image_picker/image_picker_state.dart';
import 'package:flutter_blocs/utils/image_picker.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePickerUtils imagePickerUtils;
  ImagePickerBloc(this.imagePickerUtils) : super(const ImagePickerState()) {
    on<CaptureImageFromCamera>(_captureImageCameraHandler);
    on<PickImageFromGallery>(_pickImageFromGallery);
  }

  void _captureImageCameraHandler(
    CaptureImageFromCamera event,
    Emitter<ImagePickerState> emit,
  ) async {
    XFile? file = await imagePickerUtils.cameraCapture();
    emit(state.copyWith(file: file));
  }

  void _pickImageFromGallery(
    PickImageFromGallery event,
    Emitter<ImagePickerState> emit,
  ) async {
    XFile? file = await imagePickerUtils.pickImageFromGallery();
    emit(state.copyWith(file: file));
  }
}
