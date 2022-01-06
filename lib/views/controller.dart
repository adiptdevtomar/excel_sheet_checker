// Created by Adipt on 06/01/2022

part of './view.dart';

final _stateProvider =
    StateNotifierProvider.autoDispose<_StateController, _State>((ref) {
  final stateController = _StateController();

  return stateController;
});

class _State {
  final bool isLoading;
  final bool hasError;
  final String fileLocation;

  _State({
    required this.isLoading,
    required this.hasError,
    required this.fileLocation,
  });

  _State.initial()
      : this(
          isLoading: false,
          hasError: false,
          fileLocation: '',
        );

  _State copyWith({
    bool? isLoading,
    bool? hasError,
    String? fileLocation,
  }) {
    return _State(
      hasError: hasError ?? this.hasError,
      isLoading: isLoading ?? this.isLoading,
      fileLocation: fileLocation ?? this.fileLocation,
    );
  }
}

class _StateController extends StateNotifier<_State> {
  _StateController() : super(_State.initial());

  Future<void> pickFile() async {
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      fileLocation: '',
    );

    try {
      // File Picker
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (result != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        // Create new Excel File
        var newExcel = Excel.createExcel();
        Sheet sheetObject = newExcel['student_new_data'];
        newExcel.setDefaultSheet('student_new_data');

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]?.rows ?? []) {
            // Validate Email Id
            if (!EmailValidator.validate(row[3])) {
              sheetObject.appendRow(row);
            }
          }
        }

        // Get External Directory for Storage
        Directory? path = await getExternalStorageDirectory();
        if (path != null) {
          String newPath = path.path + '/new_student_data.xlsx';

          file = File(newPath);
          if (await file.exists()) {
            file.delete();
          }

          newExcel.encode().then((onValue) {
            File(newPath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(onValue);
          }).whenComplete(() {
            state = state.copyWith(
              fileLocation: newPath,
            );
          });
        }
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print(e.toString());
      state = state.copyWith(
        hasError: true,
      );
    } finally {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }
}
