final String tableNote = 'notes';

// buat identifikasi di table db nya
class NoteField {
  // buat query readnya berdasarkan listd dari sini
  static final List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    time
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title, description;
  final DateTime createdTime;

  Note({
    this.id,
    required this.createdTime,
    required this.description,
    required this.isImportant,
    required this.number,
    required this.title,
  });

  Note copy({
    int? id,
    DateTime? createdTime,
    String? description,
    bool? isImportant,
    int? number,
    String? title,
  }) =>
      Note(
        id: id ?? this.id,
        createdTime: createdTime ?? this.createdTime,
        description: description ?? this.description,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
      );

  Map<String, Object?> toJson() => {
        NoteField.id: id,
        NoteField.title: title,
        NoteField.isImportant: isImportant ? 1 : 0,
        NoteField.number: number,
        NoteField.description: description,
        NoteField.time: createdTime.toIso8601String(),
      };

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteField.id] as int?,
        createdTime: DateTime.parse(json[NoteField.time] as String),
        description: json[NoteField.description] as String,
        isImportant: json[NoteField.isImportant] == 1,
        number: json[NoteField.number] as int,
        title: json[NoteField.title] as String,
      );
}
