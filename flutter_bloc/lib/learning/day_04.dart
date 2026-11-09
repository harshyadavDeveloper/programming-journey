/*
========================================================
   FLUTTER BLOC — DAY 04: IMAGE PICKER (XFile + DI)
========================================================

Video covered: image picker app (gallery + camera events)

Topics:
- Non-primitive data (XFile?) inside state
- Async handlers
- Dependency injection through the Bloc constructor
- Nullable state and copyWith
- Equatable with non-primitive fields

IMPORTANT:
- Code shown in Q2 and Q3 sits inside comments.
  Those are predict-and-explain only.
- Q4 is real code you write. Add equatable, flutter_bloc
  and image_picker to pubspec.yaml.
- Stick to today's video: no get_it, no bloc_test.
*/

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

/*
========================================================
Q1. UMBRELLA THEORY — DEPENDENCY INJECTION
========================================================

Explain this as if answering an interview question.
Use the image picker Bloc as your example.

Cover these points:
- What is the dependency of the Bloc in this app?
- What is dependency injection, and how does the Bloc
  receive its dependency?
- Where is the real object created in this app?
- What would the Bloc look like without DI, and what
  problem does that cause for testing?
- Is DI a Bloc feature, or a general idea?

Your answer:
- Dependency Injection is a software design technique in which a class receives its dependencies from outside rather than 
creating them internally.
- In my image picker application, ImagePickerBloc depends on ImagePickerUtils because it uses that utility to capture images from the camera and pick 
images from the gallery.
- I inject this dependency through the Bloc's constructor. The actual ImagePickerUtils object is created outside the Bloc, when I initialize the Bloc using BlocProvider.
- The advantage is loose coupling. If I were creating ImagePickerUtils directly inside the Bloc, it would become difficult to replace the real implementation 
during unit testing. With dependency injection, I can pass a mock implementation instead
- Also, DI is not a feature of Bloc. It's a general software engineering concept that can be used with different architectures and state management solutions

*/

/*
========================================================
Q2. DEBUGGING — THE CANCELLED PICK
========================================================

  class ImagePickerState extends Equatable {
    final XFile? file;
    const ImagePickerState({this.file});

    ImagePickerState copyWith({XFile? file}) {
      return ImagePickerState(file: file ?? this.file);
    }

    @override
    List<Object?> get props => [file];
  }

  Future<void> _pickFromGallery(
    GalleryPickedEvent event,
    Emitter<ImagePickerState> emit,
  ) async {
    final file = await utils.pickFromGallery();
    emit(state.copyWith(file: file));
  }

Scenario: the user has already picked image A, so
state.file holds A. They tap Gallery again, then close
the gallery without choosing anything.
*/
/*
Questions:
- What does the local variable file hold after the await?
- What does the new state hold, and what happens to that
  emit? (Trace it step by step.)
- What does the user see on screen?
- Is this behaviour acceptable for this app? Why or
  why not?
- If you added a "remove image" button, why couldn't
  copyWith(file: null) alone clear the image?

Your answer:
- It holds null because the user cancelled the gallery selection.
- The new state still holds image A. copyWith receives null, falls back to this.file, and retains image A. When emit is called, Bloc compares the new state with 
the current state using Equatable. Since both states contain image A, they are equal. Bloc suppresses the duplicate state emission.
- The previously selected image A remains visible. Nothing changes on screen.
- Yes, generally. Cancelling an image selection should not unexpectedly remove the previously selected image. It preserves the existing selection.
- Because copyWith uses: file: file ?? this.file, Passing null tells it to retain the existing image, not clear it.
You need an additional mechanism to distinguish between:
No new value was provided.
Explicitly clear the existing value.
ImagePickerState copyWith({
  XFile? file,
  bool clearFile = false,
}) {  
  return ImagePickerState(
    file: clearFile ? null : file ?? this.file,
  );
}
Now you can clear the image using:
state.copyWith(clearFile: true);
A nullable parameter alone cannot distinguish between an omitted value and an explicitly passed null when using the ?? fallback pattern.
*/

/*
========================================================
Q3. OUTPUT PREDICTION — THE SAME PHOTO TWICE
========================================================

Assume for this question:
- XFile uses the default identity-based ==.
- Each pick returns a NEW XFile object.
- The user picks the same photo twice in a row, so both
  XFile objects have the same path.

Version A: props => [file]
Version B: props => [file?.path]
*/
/*
Questions:
- How many states reach the UI from the two picks in
  Version A, and in Version B?
- Explain why, using what you learned about identity vs
  value equality and the emit rule.
- Which version is better for this app? There is no
  single right answer, so justify yours.

Your answer:
1. How many states reach the UI from the two picks?
- Version A: 2 states.
- Version B: 1 state.
2. In Version A, Equatable compares two different XFile objects using identity equality. Since they are different instances, both states are considered 
unequal and emitted.
In Version B, Equatable compares their paths. Since both paths have the same value, the second state is considered equal to the current state, so Bloc 
suppresses the emission.
- I'd prefer Version B because this app only needs the image path to display the selected image.
Picking the same image again doesn't represent a meaningful UI state change. Comparing paths avoids unnecessary state emissions and rebuilds.
However, if the application needed to track other file-specific information, comparing the entire object or including those properties in props might be more appropriate
*/

/*
========================================================
Q4. PRACTICAL — WRITE THE BLOC WITH DI
========================================================

ImagePickerUtils is given. Do not change it.
*/
class ImagePickerUtils {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickFromGallery() {
    return _picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> captureFromCamera() {
    return _picker.pickImage(source: ImageSource.camera);
  }
}

/*
Write below, without looking at the video:

1. abstract class ImagePickerEvent extends Equatable
2. GalleryPickedEvent and CameraCapturedEvent
3. ImagePickerState with XFile? file, a const constructor,
   copyWith, and props
4. ImagePickerBloc that receives ImagePickerUtils through
   its constructor and has an async handler per event

Write your code here:

*/
abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();
  @override
  List<Object?> get props => [];
}

class GalleryPickedEvent extends ImagePickerEvent {}

class CameraCapturedEvent extends ImagePickerEvent {}

class ImagePickerState extends Equatable {
  final XFile? file;
  const ImagePickerState({this.file});

  ImagePickerState copyWith({XFile? file}) {
    return ImagePickerState(file: file ?? this.file);
  }

  @override
  List<Object?> get props => [file];
}

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePickerUtils _imagePickerUtils;
  ImagePickerBloc(this._imagePickerUtils) : super(const ImagePickerState()) {
    on<GalleryPickedEvent>(_galleryPickerHandler);
    on<CameraCapturedEvent>(_cameraCapturedEventHandler);
  }

  void _galleryPickerHandler(
    GalleryPickedEvent event,
    Emitter<ImagePickerState> emit,
  ) async {
    final XFile? file = await _imagePickerUtils.pickFromGallery();
    emit(state.copyWith(file: file));
  }

  void _cameraCapturedEventHandler(
    CameraCapturedEvent event,
    Emitter<ImagePickerState> emit,
  ) async {
    final XFile? file = await _imagePickerUtils.captureFromCamera();
    emit(state.copyWith(file: file));
  }
}

/*
Questions about your code:
- Which line of your Bloc shows dependency injection?
- Why are both handlers async, and what does await
  do before emit?
- Write, as a comment, the BlocProvider line that creates
  the Bloc with its dependency.
- Why do the two events carry no data?

Your answer:
- This line: ImagePickerBloc(this._imagePickerUtils)
The Bloc receives ImagePickerUtils through its constructor instead of creating the object internally.

- Both handlers are asynchronous because the image picker operations return a Future<XFile?>
Here's what happens:
1. The gallery picker starts its operation.
2. await pauses the execution of this handler until the Future completes.
3. The handler returns control to the asynchronous runtime, allowing other work to continue.
4. Once the Future completes, execution resumes.
5. The returned image is assigned to file.
6. emit() updates the Bloc state.

- BlocProvider(create: (_) => ImagePickerBloc(ImagePickerUtils())),
ImagePickerUtils() creates the actual object.
That object is passed to ImagePickerBloc.
BlocProvider provides the Bloc to its child widget tree

- Because these events only communicate which action the user wants to perform.
GalleryPickedEvent tells the Bloc to open the gallery.
CameraCapturedEvent tells the Bloc to open the camera.

The actual image is obtained later through ImagePickerUtils.
We don't need to pass any additional data because the utility handles the image selection.
*/

void main() {}

/*
========================================================
                  END OF DAY 04
========================================================
*/
