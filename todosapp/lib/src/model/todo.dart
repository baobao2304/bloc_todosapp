import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Todo extends Equatable {
   final String id;
    String title;
    String description;
    bool isCompleted;

  Todo({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();



  String get getTitle {
     return title;
   }
   set setTitle(String newTitle) {
     title = newTitle;
   }


   get getDescription {
     return description;
   }
   set setDescription(String newDescription) {
     description = newDescription;
   }

   get getIsCompleted {
     return isCompleted;
   }
   set setIsCompleted(bool newIsCompleted) {
     isCompleted = newIsCompleted;
   }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }



  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnDescription: description,
      columnIsComplete: isCompleted,
      columnId: id
    };

    return map;
  }

  factory Todo.fromMap(Map<dynamic, dynamic> map) {
    return Todo(
        id: map[columnId],
        title: map[columnTitle],
        description: map[columnDescription],
        isCompleted: map[columnIsComplete]);
  }

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json[columnId],
        title: json[columnTitle],
        description: json[columnDescription],
        isCompleted: json[columnIsComplete],
      );

  Map<String, dynamic> toJson() => {
        columnTitle: title,
        columnDescription: description,
        columnIsComplete: isCompleted,
        columnId: id
      };

  @override
  // TODO: implement props
  List<Object> get props => [id, title, description, isCompleted];


}

typedef JsonMap = Map<String, dynamic>;

const String tableStory = 'todo';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDescription = 'description';
const String columnIsComplete = 'iscomplete';
