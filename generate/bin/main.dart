import 'dart:io';

void main() async {
  stdout.write("Name: ");
  final name = stdin.readLineSync()!;

  final contents = FileContents(name);
  final operations = [
    ('./$name/management/${name}_management.dart', contents.management),
    ('./$name/management/${name}_manager.dart', contents.manager),
    ('./$name/${name}_page.dart', contents.page),
  ];
  for (final operation in operations) {
    final file = File(operation.$1);
    await file.create(recursive: true);
    await file.writeAsString(operation.$2);
  }
}

class FileContents {
  final String name;

  FileContents(this.name);

  String get className => name.split('_').map((e) => e.capitalize()).join();

  late final manager = """
import 'package:injectable/injectable.dart';
import 'package:management/management.dart';

import '${name}_management.dart';

@injectable
class ${className}Manager extends Manager<${className}State, ${className}Effect> {
  ${className}Manager() : super(const ${className}State());

}
""";

  late final management =
  """import 'package:freezed_annotation/freezed_annotation.dart';

part '${name}_management.freezed.dart';

@freezed
class ${className}State with _\$${className}State {
  const factory ${className}State() = _${className}State;
}

@freezed
class ${className}Effect with _\$${className}Effect {
  const factory ${className}Effect() = _${className}Effect;
}
""";

  late final page = """import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:management/management.dart';

import 'management/${name}_management.dart';
import 'management/${name}_manager.dart';

@RoutePage()
class ${className}Page extends Managed<${className}Manager, ${className}State, ${className}Effect> {
  const ${className}Page({super.key});
  
  @override
  void init(context, manager) {}
  
  @override
  void listener(context, manager, effect) {}

  @override
  Widget builder(context, manager, state) {
    return Container();
  }
}
""";
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

