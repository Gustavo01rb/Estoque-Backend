import 'package:mysql1/mysql1.dart';
import 'package:dotenv/dotenv.dart' show load, env;

class DataBase {
  // Pedrão de Projeto: Singleton
  static final DataBase _dataBase = DataBase._internal();

  factory DataBase() {
    load();
    return _dataBase;
  }

  DataBase._internal();
  // fim

  var settings = ConnectionSettings(
      host: 'localhost',
      port: int.parse(env['port'] ?? "3306"),
      user: env['user'],
      password: env['password'],
      db: 'estoque');

  late MySqlConnection conn;

  Future<MySqlConnection> connect() async {
    conn = await MySqlConnection.connect(settings);
    return conn;
  }

  Future<Results> login(String email) async {
    return await conn.query(
        'SELECT email, name, password, isADMIN FROM user WHERE email = ?',
        [email]);
  }

  Future<Results> registerUser(Map<String, dynamic> userMap) async {
    return await conn.query(
      'INSERT INTO estoque.user(cpf,name,entryDate, userType,email,isAdmin, password) VALUES (?,?,?,?,?,?,?)',
      [
        userMap["cpf"],
        userMap["name"],
        userMap["entryDate"],
        userMap["userType"],
        userMap["email"],
        userMap["isAdmin"],
        userMap["password"]
      ],
    );
  }

  Future<Results> getUsers() async {
    return await conn.query(
        'SELECT name, CAST(entryDate as CHAR) as entryDate, userType, email, isAdmin from user');
  }
}
