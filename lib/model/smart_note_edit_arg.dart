import '../model/smart_notes_model.dart';
typedef VoidCallback = void Function(bool isNewNote);

class SmartNoteEditArg {
   final String currentUserDepartmentName;
  final String currentUserName;
final SmartNotesModel smartNotesModel;
  final VoidCallback callbackForNewNote;

  SmartNoteEditArg({
    this.currentUserDepartmentName,
    this.currentUserName,
    this.smartNotesModel,
    this.callbackForNewNote
  });
}