import 'package:sqflite/sqflite.dart';
import 'package:sqflite_01/Note.dart';
import 'package:path/path.dart';

class SqlDatabase {
  static final SqlDatabase instance = SqlDatabase._init();

  static Database? _database;

  SqlDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOL NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableNote 
      (
        ${NoteField.id} $idType,
        ${NoteField.isImportant} $boolType,
        ${NoteField.number} $integerType,
        ${NoteField.title} $textType,
        ${NoteField.description} $textType,
        ${NoteField.time} $textType
      )
      ''');
  }

  Future close() async {
    final db = await instance.database;

    db!.close();
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    // method ini sama aja kalau kita mau insert berdasarkan value masing2, sama seperti method copy yang dibawah
    // mulai
    // final json = note.toJson();
    // final column =
    //     '${NoteField.title}, ${NoteField.description}, ${NoteField.time}';

    // final values =
    //     '${json[NoteField.title]},${json[NoteField.description]}, ${json[NoteField.time]}} ';

    // final id = await db.rawInsert('INSERT INTO table_name ($columns) VALUES ($values) ');
    // selesai

    final id = await db!.insert(tableNote, note.toJson());

    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db!.query(tableNote,
        columns: NoteField.values,
        where: '${NoteField.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteField.time} ASC';

    final result = await db!.query(tableNote, orderBy: orderBy);
    print(result);
    return result.map((e) => Note.fromJson(e)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    return db!.update(
      tableNote,
      note.toJson(),
      where: '${NoteField.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    return await db!.delete(
      tableNote,
      where: '${NoteField.id} = ?',
      whereArgs: [id],
    );
  }
}
