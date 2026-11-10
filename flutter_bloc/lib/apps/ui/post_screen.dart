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
              return CircularProgressIndicator();
            case PostStatus.failure:
              return Text(state.errorMessage.toString());
            case PostStatus.success:
              return ListView.builder(
                itemCount: state.postList.length,
                itemBuilder: (context, index) {
                  final item = state.postList[index];
                  return ListTile(
                    title: Text(item.name.toString()),
                    subtitle: Text(item.email.toString()),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
