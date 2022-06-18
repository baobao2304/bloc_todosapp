
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:todosapp/src/ui/todo_page.dart';

import 'src/data/local_storage_todo.dart';
import 'src/data/todo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );

  final todosRepository = TodosRepository(todosApi: todosApi);
  runZonedGuarded(
        () async {
      await BlocOverrides.runZoned(
            () async => runApp(
              MyApp(todosRepository: todosRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
        (error, stackTrace) => Logger().i(error.toString()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.todosRepository}) : super(key: key);

  final TodosRepository todosRepository;
  @override
  Widget build(BuildContext context) {
    return  RepositoryProvider.value(
      value: todosRepository,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movie App',
            // initialRoute: Routes.HOME_MOVIE,
            // onGenerateRoute: (settings) {
            //   return route(settings);
            // },
            home: TodosPage(),
          );
        },
      ),
    )

      ;
  }
}
class AppBlocObserver extends BlocObserver {

  @override
  void onEvent(Bloc bloc, Object? event) {
    Logger().i('BLOC EVENT', event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Logger().i('BLOC ERROR', error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Logger().i('BLOC TRANSITION', transition.event);
    super.onTransition(bloc, transition);
  }
}

