
import 'package:sqflite/sqflite.dart';

const String tableName = "Users";

class User{
  int? id;
  String? name, phone, email;

  User({required this.name, this.phone, this.id, this.email});

  factory User.FromJson(Map<String, dynamic> json){
    return User(name: json['name'],
        id: json['id'],
        email: json['email'],
        phone: json['phone']);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'email': email,
    'phone': phone
  };
}

class DatabaseHelper{
  Database? database;
  String? _path;

  Future<String?> _getDatabasePath(String databaseName)async{
    String p = await getDatabasesPath();
    String path = '$p/$databaseName';
    _path = path;
    return _path;
  }

  Future<Database?> open() async{
    String? _path = await _getDatabasePath("Users.db");
    database = await openDatabase(
      _path!,
      version: 1,
      onCreate: (db, version){
        db.execute('CREATE TABLE $tableName (id INTEGER PRIMARY KEY, name TEXT, phone TEXT, email TEXT)');
      }
    );
    return database;
  }

  Future<int> insert(User user) async{
    int id = await database!.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO $tableName (name, phone, email) VALUES (?,?,?)', [user.name, user.phone, user.email]);
      return id;
    });
    return id;
  }

  Future<int> update(User newUser, int id) async{
    int count = await database!.transaction((txn) async{
      int count = await txn.rawUpdate(
        'Update $tableName set name = ?, phone = ?, email = ? where id = ?',[newUser.name, newUser.phone, newUser.email, id]
      );
      return count;
    });
    return count;
  }

  Future<int> delete(int id) async {
    int count = await database!.rawDelete(
      'delete from $tableName where id = ?',[id]
    );
    return count;
  }

  Future<List<User>> getUsers() async{
    List<Map> list = await database!.rawQuery('select * from $tableName');
    return list.map((userJson) => User.FromJson(userJson as Map<String, dynamic>)).toList();
  }

  void closeDatabase() async {
   await database!.close();
  }

  void deleteDatabase(String path){
    deleteDatabase(path);
  }

}