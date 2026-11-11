import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/post/post_bloc.dart';
import 'package:flutter_blocs/apps/bloc/post/post_bloc_event.dart';
import 'package:flutter_blocs/apps/bloc/post/post_bloc_state.dart';
import 'package:flutter_blocs/utils/enums.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(PostFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloc Api Example')),
      body: BlocBuilder<PostBloc, PostBlocState>(
        builder: (context, state) {
          switch (state.postStatus) {
            case PostStatus.loading:
              return Center(child: CircularProgressIndicator());
            case PostStatus.failure:
              return Center(child: Text(state.errorMessage.toString()));
            case PostStatus.success:
              return Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search by email',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      context.read<PostBloc>().add(SearchItem(val));
                      print(state.tempPostList.length);
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.tempPostList.isEmpty
                          ? state.postList.length
                          : state.tempPostList.length,
                      itemBuilder: (context, index) {
                        final item = state.postList[index];
                        return ListTile(
                          title: Text(item.name.toString()),
                          subtitle: Text(item.email.toString()),
                        );
                      },
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
