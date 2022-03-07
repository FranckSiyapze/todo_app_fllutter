import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_filter.dart';
import 'package:todo_app/providers/todo_list.dart';
import 'package:todo_app/providers/todo_search.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> fileteredTodos;
  const FilteredTodosState({
    required this.fileteredTodos,
  });

  factory FilteredTodosState.initial() {
    return const FilteredTodosState(fileteredTodos: []);
  }
  @override
  List<Object> get props => [fileteredTodos];

  @override
  bool get stringify => true;
  FilteredTodosState copyWith({
    List<Todo>? fileteredTodos,
  }) {
    return FilteredTodosState(
        fileteredTodos: fileteredTodos ?? this.fileteredTodos);
  }
}

class FilteredTodos with ChangeNotifier {
  //FilteredTodosState _state = FilteredTodosState.initial();
  late FilteredTodosState _state;
  final List<Todo> initialFilteredTodos;
  FilteredTodos({
    required this.initialFilteredTodos,
  }) {
    print('initialFilteredTodos : $initialFilteredTodos');
    _state = FilteredTodosState(fileteredTodos: initialFilteredTodos);
  }
  FilteredTodosState get state => _state;

  void update(TodoFilter todoFilter, TodoSearch todoSearch, TodoList todoList) {
    List<Todo> _filteredTodos;
    switch (todoFilter.state.filter) {
      case Filter.active:
        _filteredTodos =
            todoList.state.todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodos =
            todoList.state.todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
        _filteredTodos = todoList.state.todos;
        break;
    }
    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) =>
              todo.desc.toLowerCase().contains(todoSearch.state.searchTerm))
          .toList();
    }
    _state = _state.copyWith(fileteredTodos: _filteredTodos);
    notifyListeners();
  }
}
