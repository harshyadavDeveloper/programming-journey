import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/switch/switch_bloc.dart';
import 'package:flutter_blocs/apps/bloc/switch/switch_events.dart';
import 'package:flutter_blocs/apps/bloc/switch/switch_state.dart';

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Switch App(Multiple State)")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Notification'),
                BlocBuilder<SwitchBloc, SwitchState>(
                  buildWhen: (previous, current) =>
                      previous.switchValue != current.switchValue,
                  builder: (context, state) {
                    print('notification?');
                    return Switch(
                      value: state.switchValue,
                      onChanged: (newValue) {
                        context.read<SwitchBloc>().add(SwitchNotification());
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            BlocBuilder<SwitchBloc, SwitchState>(
              builder: (context, state) {
                return Container(
                  height: 200,
                  color: Colors.red.withOpacity(state.slider),
                );
              },
            ),
            const SizedBox(height: 30),
            BlocBuilder<SwitchBloc, SwitchState>(
              buildWhen: (previous, current) =>
                  previous.slider != current.slider,
              builder: (context, state) {
                print('slider');

                return Slider(
                  value: state.slider,
                  onChanged: (value) {
                    context.read<SwitchBloc>().add(SliderEvent(slider: value));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
