import 'package:isar/isar.dart';


part 'db.g.dart';

@collection
class HesapVerileri{
  Id id = Isar.autoIncrement;
  String? title;
  int? price; 
  String? description;
  DateTime? tarih;
  String? category; 
  bool? type; // true: gelir, false: gider
}