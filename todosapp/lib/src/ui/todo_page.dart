import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../data/todo_repository.dart';
import 'components/todo_listtitle.dart';
import 'edit_todo_page.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosOverviewSubscriptionRequested()),
      child: const TodosOverviewView(),
    );
  }
}
class TodosOverviewView extends StatefulWidget {
  const TodosOverviewView({Key? key}) : super(key: key);

  @override
  State<TodosOverviewView> createState() => _TodosOverviewViewState();
}

class _TodosOverviewViewState extends State<TodosOverviewView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<TodosOverviewBloc>().add(const TodosOverviewMockData());
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditTodoPage.route()),

        child: const Icon(Icons.add),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
            previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("fail"),
                    ),
                  );
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
            previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      "Delete  ${deletedTodo.title}",
                    ),
                    action: SnackBarAction(
                      label: "undo request delete item",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodosOverviewBloc>()
                            .add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {

                return Center(
                  child: Text(
                    "todo page empty",
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  return  TodoListTile(
                    todo: state.todos[index],
                    onToggleCompleted: (isCompleted) {
                      context.read<TodosOverviewBloc>().add(
                        TodosOverviewTodoCompletionToggled(
                          todo: state.todos[index],
                          isCompleted: isCompleted,
                        ),
                      );
                    },
                    onDismissed: (_) {
                      context
                          .read<TodosOverviewBloc>()
                          .add(TodosOverviewTodoDeleted(state.todos[index]));
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        EditTodoPage.route(initialTodo: state.todos[index]),
                      ).then((value) =>    context.read<TodosOverviewBloc>().add(const TodosOverviewSubscriptionRequested()));
                    },
                  );
                },),
            );
          },
        ),
      ),
    );
  }
}
