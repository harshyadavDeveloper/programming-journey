import 'package:equatable/equatable.dart';

class SwitchState extends Equatable {
  final bool switchValue;
  final double slider;

  const SwitchState({this.switchValue = false, this.slider = 0.2});

  SwitchState copyWith({bool? switchValue, double? slider}) {
    return SwitchState(
      switchValue: switchValue ?? this.switchValue,
      slider: slider ?? this.slider,
    );
  }

  @override
  List<Object?> get props => [switchValue, slider];
}
