import 'package:bloc/bloc.dart';
import 'package:flutter_blocs/apps/bloc/favourite_app/favourite_app_event.dart';
import 'package:flutter_blocs/apps/bloc/favourite_app/favourite_app_state.dart';
import 'package:flutter_blocs/models/favourite_item_model.dart';
import 'package:flutter_blocs/repository/favourite_repository.dart';

class FavouriteAppBloc extends Bloc<FavouriteAppEvent, FavouriteAppState> {
  List<FavouriteItemModel> favouriteList = [];
  List<FavouriteItemModel> tempFavouriteList = [];
  final FavouriteRepository _favouriteRepository;
  FavouriteAppBloc(this._favouriteRepository)
    : super(const FavouriteAppState()) {
    on<FetchAllItemListEvent>(fetchItemListHandler);
    on<AddFavouriteEvent>(_addFavouriteHandler);
    on<SelectItemEvent>(_selectItemHandler);
    on<UnSelectItemEvent>(_unselectItemHandler);
    on<DeleteItem>(_deleteItemHandler);
  }

  void fetchItemListHandler(
    FetchAllItemListEvent event,
    Emitter<FavouriteAppState> emit,
  ) async {
    favouriteList = await _favouriteRepository.fetchAllList();
    emit(
      state.copyWith(
        favouriteItemList: List.from(favouriteList),
        listStatus: ListStatus.success,
      ),
    );
  }

  void _addFavouriteHandler(
    AddFavouriteEvent event,
    Emitter<FavouriteAppState> emit,
  ) async {
    final index = favouriteList.indexWhere(
      (element) => element.id == event.item.id,
    );
    if (event.item.isFavourite) {
      if (tempFavouriteList.contains(favouriteList[index])) {
        tempFavouriteList.remove(favouriteList[index]);
        tempFavouriteList.add(event.item);
      }
    } else {
      if (tempFavouriteList.contains(favouriteList[index])) {
        tempFavouriteList.remove(favouriteList[index]);
        tempFavouriteList.add(event.item);
      }
    }
    favouriteList[index] = event.item;
    emit(
      state.copyWith(
        favouriteItemList: List.from(favouriteList),
        tempFavouriteItemList: List.from(tempFavouriteList),
      ),
    );
  }

  void _selectItemHandler(
    SelectItemEvent event,
    Emitter<FavouriteAppState> emit,
  ) async {
    tempFavouriteList.add(event.item);
    emit(state.copyWith(tempFavouriteItemList: List.from(tempFavouriteList)));
  }

  void _unselectItemHandler(
    UnSelectItemEvent event,
    Emitter<FavouriteAppState> emit,
  ) async {
    tempFavouriteList.remove(event.item);
    emit(state.copyWith(tempFavouriteItemList: List.from(tempFavouriteList)));
  }

  void _deleteItemHandler(
    DeleteItem event,
    Emitter<FavouriteAppState> emit,
  ) async {
    for (int i = 0; i < tempFavouriteList.length; i++) {
      favouriteList.remove(tempFavouriteList[i]);
    }
    tempFavouriteList.clear();
    emit(
      state.copyWith(
        favouriteItemList: List.from(favouriteList),
        tempFavouriteItemList: List.from(tempFavouriteList),
      ),
    );
  }
}
