import 'package:bloc/bloc.dart';
import 'package:flutter_blocs/apps/bloc/post/post_bloc_event.dart';
import 'package:flutter_blocs/apps/bloc/post/post_bloc_state.dart';
import 'package:flutter_blocs/models/post_model.dart';
import 'package:flutter_blocs/repository/post_repository.dart';
import 'package:flutter_blocs/utils/enums.dart';

class PostBloc extends Bloc<PostBlocEvent, PostBlocState> {
  final PostRepository _postRepository;
  List<PostModel> tempPostList = [];

  PostBloc(this._postRepository) : super(const PostBlocState()) {
    on<PostFetched>(fetchPostHandler);
    on<SearchItem>(_filterList);
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

  void _filterList(SearchItem event, Emitter<PostBlocState> emit) {
    if (event.searchTerm.isEmpty) {
      emit(state.copyWith(tempPostList: [], searchMessage: ''));
    } else {
      // tempPostList = state.postList
      //     .where((ele) => ele.email == event.searchTerm.toString())
      //     .toList();
      tempPostList = state.postList
          .where(
            (ele) => ele.email.toString().toLowerCase().contains(
              event.searchTerm.toLowerCase(),
            ),
          )
          .toList();
      if (tempPostList.isEmpty) {
        emit(
          state.copyWith(
            tempPostList: tempPostList,
            searchMessage: 'No Data Found',
          ),
        );
      } else {
        emit(state.copyWith(tempPostList: tempPostList, searchMessage: ''));
      }
    }
  }
}
