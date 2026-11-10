import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/Image_picker/image_picker_bloc.dart';
import 'package:flutter_blocs/apps/bloc/counter/counter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/favourite_app/favourite_app_bloc.dart';
import 'package:flutter_blocs/apps/bloc/post/post_bloc.dart';
import 'package:flutter_blocs/apps/bloc/switch/switch_bloc.dart';
import 'package:flutter_blocs/apps/ui/post_screen.dart';
import 'package:flutter_blocs/repository/favourite_repository.dart';
import 'package:flutter_blocs/repository/post_repository.dart';
import 'package:flutter_blocs/utils/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => SwitchBloc()),
        BlocProvider(create: (_) => ImagePickerBloc(ImagePickerUtils())),
        BlocProvider(create: (_) => FavouriteAppBloc(FavouriteRepository())),
        BlocProvider(create: (_) => PostBloc(PostRepository())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        home: const PostScreen(),
      ),
    );
  }
}

class Person extends Equatable {
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  @override
  List<Object?> get props => [name, age];
}
