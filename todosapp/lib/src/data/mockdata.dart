

import 'package:uuid/uuid.dart';

import '../model/todo.dart';

 List<Todo> lstMockData = [
  Todo( id: const Uuid().v4(),title: "title1",description: "description1" ,isCompleted: false),
   Todo( id: const Uuid().v4(),title: "title2",description: "description2" ,isCompleted: false),
   Todo( id: const Uuid().v4(),title: "title3",description: "description3" ,isCompleted: false),
   Todo( id: const Uuid().v4(),title: "title4",description: "description4" ,isCompleted: true),
   Todo( id: const Uuid().v4(),title: "title5",description: "description5" ,isCompleted: true),
   Todo( id: const Uuid().v4(),title: "title6",description: "description6" ,isCompleted: false),
   Todo( id: const Uuid().v4(),title: "title7",description: "description7" ,isCompleted: false),

];