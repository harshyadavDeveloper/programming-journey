import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/counter/counter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/switch/switch_bloc.dart';
import 'package:flutter_blocs/apps/ui/switch_example.dart';

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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SwitchExample(),
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
