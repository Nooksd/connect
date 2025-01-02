import 'package:connect/app/modules/post/data/repos/mongo_post_repo.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_cubit.dart';
import 'package:connect/app/modules/post/presentation/pages/feed_page.dart';
import 'package:connect/app/modules/post/presentation/pages/post_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PostModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => MongoPostRepo(http: i())),
    Bind.singleton((i) => PostCubit(postRepo: i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/feed',
      child: (_, __) => BlocProvider(
        create: (context) => Modular.get<PostCubit>(),
        child: const FeedPage(),
      ),
    ),
    ChildRoute(
      '/create',
      child: (_, __) => BlocProvider(
        create: (context) => Modular.get<PostCubit>(),
        child: const PostPage(),
      ),
    )
  ];
}
