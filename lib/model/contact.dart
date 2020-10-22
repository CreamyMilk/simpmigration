import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 1 )
class Contact {
  @HiveField(0)
  final Map<String,dynamic> data;

  

  Contact(this.data);
}