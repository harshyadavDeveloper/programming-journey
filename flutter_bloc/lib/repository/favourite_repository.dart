import 'package:flutter_blocs/models/favourite_item_model.dart';

class FavouriteRepository {
  Future<List<FavouriteItemModel>> fetchAllList() async {
    await Future.delayed(Duration(seconds: 3));
    return List.of(_generatedList(10));
  }

  List<FavouriteItemModel> _generatedList(int length) {
    return List.generate(
      length,
      (index) => FavouriteItemModel(id: index.toString(), value: 'Item $index'),
    );
  }
}
