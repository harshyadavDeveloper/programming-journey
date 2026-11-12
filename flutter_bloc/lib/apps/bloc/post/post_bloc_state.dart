import 'package:equatable/equatable.dart';
import 'package:flutter_blocs/models/post_model.dart';
import 'package:flutter_blocs/utils/enums.dart';

class PostBlocState extends Equatable {
  final PostStatus postStatus;
  final List<PostModel> postList;
  final List<PostModel> tempPostList;
  final String errorMessage;
  final String searchMessage;

  const PostBlocState({
    this.postStatus = PostStatus.loading,
    this.postList = const [],
    this.tempPostList = const [],
    this.errorMessage = '',
    this.searchMessage = '',
  });

  PostBlocState copyWith({
    PostStatus? postStatus,
    List<PostModel>? postList,
    List<PostModel>? tempPostList,
    String? errorMessage,
    String? searchMessage,
  }) {
    return PostBlocState(
      postStatus: postStatus ?? this.postStatus,
      postList: postList ?? this.postList,
      tempPostList: tempPostList ?? this.tempPostList,
      errorMessage: errorMessage ?? this.errorMessage,
      searchMessage: searchMessage ?? this.searchMessage,
    );
  }

  @override
  List<Object?> get props => [
    postStatus,
    postList,
    errorMessage,
    tempPostList,
    searchMessage,
  ];
}
