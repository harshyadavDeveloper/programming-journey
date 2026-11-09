import 'package:equatable/equatable.dart';
import 'package:flutter_blocs/models/favourite_item_model.dart';

abstract class FavouriteAppEvent extends Equatable {
  const FavouriteAppEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllItemListEvent extends FavouriteAppEvent {}

class AddFavouriteEvent extends FavouriteAppEvent {
  final FavouriteItemModel item;
  const AddFavouriteEvent({required this.item});
}

class SelectItemEvent extends FavouriteAppEvent {
  final FavouriteItemModel item;
  const SelectItemEvent({required this.item});
}

class UnSelectItemEvent extends FavouriteAppEvent {
  final FavouriteItemModel item;
  const UnSelectItemEvent({required this.item});
}

class DeleteItem extends FavouriteAppEvent {}
