import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

part 'controller.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_stateProvider);
    final stateController = ref.watch(_stateProvider.notifier);

    return Scaffold(
      body: InkWell(
        onTap: (state.isLoading) ? null : stateController.pickFile,
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.0,
                  1.0,
                ],
                colors: [
                  Color(0xff1a936f),
                  Color(0xff114b5f),
                ] //TODO: update based on theme
                ),
          ),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select Excel File for email Verification',
                    style: GoogleFonts.oswald(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  (state.isLoading)
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.add,
                        ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  (state.fileLocation != '')
                      ? Text(
                          'File Generated successfully at ${state.fileLocation}',
                          style: GoogleFonts.oswald(fontSize: 12.0),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 50.0,
                  ),
                  (state.hasError)
                      ? Text(
                          'Something went wrong.',
                          style: GoogleFonts.oswald(
                            fontSize: 14.0,
                            color: Colors.red,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
