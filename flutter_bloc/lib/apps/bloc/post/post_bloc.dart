import 'package:bloc/bloc.dart';
import 'package:flutter_blocs/apps/bloc/post/post_bloc_event.dart';
import 'package:flutter_blocs/apps/bloc/post/post_bloc_state.dart';
import 'package:flutter_blocs/repository/post_repository.dart';
import 'package:flutter_blocs/utils/enums.dart';

class PostBloc extends Bloc<PostBlocEvent, PostBlocState> {
  final PostRepository _postRepository;

  PostBloc(this._postRepository) : super(const PostBlocState()) {
    on<PostFetched>(fetchPostHandler);
  }

  Future<void> fetchPostHandler(
    PostFetched event,
    Emitter<PostBlocState> emit,
  ) async {
    try {
      final val = await _postRepository.fetchPost();
      emit(
        state.copyWith(
          postStatus: PostStatus.success,
          errorMessage: 'success',
          postList: val,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          postStatus: PostStatus.failure,
          errorMessage: err.toString(),
        ),
      );
    }
  }
}
