import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/switch/switch_events.dart';
import 'package:flutter_blocs/apps/bloc/switch/switch_state.dart';

class SwitchBloc extends Bloc<SwitchEvents, SwitchState> {
  SwitchBloc() : super(SwitchState()) {
    on<SwitchNotification>(_toggleNotification);
    on<SliderEvent>(_slider);
  }

  void _toggleNotification(
    SwitchNotification events,
    Emitter<SwitchState> emit,
  ) {
    emit(state.copyWith(switchValue: !state.switchValue));
  }

  void _slider(SliderEvent events, Emitter<SwitchState> emit) {
    emit(state.copyWith(slider: events.slider));
  }
}
