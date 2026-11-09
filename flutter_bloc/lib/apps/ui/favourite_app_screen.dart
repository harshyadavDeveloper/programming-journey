import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/favourite_app/favourite_app_bloc.dart';
import 'package:flutter_blocs/apps/bloc/favourite_app/favourite_app_event.dart';
import 'package:flutter_blocs/apps/bloc/favourite_app/favourite_app_state.dart';
import 'package:flutter_blocs/models/favourite_item_model.dart';

class FavouriteAppScreen extends StatefulWidget {
  const FavouriteAppScreen({super.key});

  @override
  State<FavouriteAppScreen> createState() => _FavouriteAppScreenState();
}

class _FavouriteAppScreenState extends State<FavouriteAppScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavouriteAppBloc>().add(FetchAllItemListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite App'),
        actions: [
          BlocBuilder<FavouriteAppBloc, FavouriteAppState>(
            builder: (context, state) {
              return Visibility(
                visible: state.tempFavouriteItemList.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    context.read<FavouriteAppBloc>().add(DeleteItem());
                  },
                  icon: Icon(Icons.delete),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<FavouriteAppBloc, FavouriteAppState>(
            builder: (context, state) {
              switch (state.listStatus) {
                case ListStatus.loading:
                  return const CircularProgressIndicator();
                case ListStatus.faliure:
                  return const Text('Something went wrong');
                case ListStatus.success:
                  return ListView.builder(
                    itemCount: state.favouriteItemList.length,
                    itemBuilder: (context, index) {
                      final item = state.favouriteItemList[index];
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: state.tempFavouriteItemList.contains(item)
                                ? true
                                : false,
                            onChanged: (val) {
                              if (val!) {
                                context.read<FavouriteAppBloc>().add(
                                  SelectItemEvent(item: item),
                                );
                              } else {
                                context.read<FavouriteAppBloc>().add(
                                  UnSelectItemEvent(item: item),
                                );
                              }
                            },
                          ),
                          title: Text(item.value.toString()),
                          trailing: IconButton(
                            onPressed: () {
                              FavouriteItemModel favouriteItem =
                                  FavouriteItemModel(
                                    id: item.id,
                                    value: item.value,
                                    isFavourite: item.isFavourite
                                        ? false
                                        : true,
                                  );
                              context.read<FavouriteAppBloc>().add(
                                AddFavouriteEvent(item: favouriteItem),
                              );
                            },
                            icon: Icon(
                              item.isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                          ),
                        ),
                      );
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
