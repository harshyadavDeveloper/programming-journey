import 'package:equatable/equatable.dart';

abstract class PostBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostFetched extends PostBlocEvent {}

class SearchItem extends PostBlocEvent {
  final String searchTerm;
  SearchItem(this.searchTerm);
}
