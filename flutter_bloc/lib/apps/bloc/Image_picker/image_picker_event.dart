import 'package:equatable/equatable.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();
  @override
  List<Object?> get props => [];
}

class CaptureImageFromCamera extends ImagePickerEvent {}

class PickImageFromGallery extends ImagePickerEvent {}
