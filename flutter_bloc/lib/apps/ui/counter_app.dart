import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/counter/counter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/counter/counter_events.dart';
import 'package:flutter_blocs/apps/bloc/counter/counter_state.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('main build');
    return Scaffold(
      appBar: AppBar(title: Text('Counter Bloc Example')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state) {
              print('builder bloc');
              return Center(
                child: Text(
                  state.counter.toString(),
                  style: TextStyle(fontSize: 60),
                ),
              );
            },
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print('build decrement');
                  context.read<CounterBloc>().add(DecrementCounterEvent());
                },
                child: Text('Decrement'),
              ),
              SizedBox(width: 25),
              ElevatedButton(
                onPressed: () {
                  print('build increment');
                  context.read<CounterBloc>().add(IncrementCounterEvent());
                },
                child: Text('Increment'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
