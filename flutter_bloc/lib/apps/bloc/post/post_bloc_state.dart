import 'package:equatable/equatable.dart';
import 'package:flutter_blocs/models/post_model.dart';
import 'package:flutter_blocs/utils/enums.dart';

class PostBlocState extends Equatable {
  final PostStatus postStatus;
  final List<PostModel> postList;
  final String errorMessage;

  const PostBlocState({
    this.postStatus = PostStatus.loading,
    this.postList = const [],
    this.errorMessage = '',
  });

  PostBlocState copyWith({
    PostStatus? postStatus,
    List<PostModel>? postList,
    String? errorMessage,
  }) {
    return PostBlocState(
      postStatus: postStatus ?? this.postStatus,
      postList: postList ?? this.postList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [postStatus, postList, errorMessage];
}
