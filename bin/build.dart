import 'dart:io';

void main(List<String> args) async {
  final path = args[0];
  final files = [
    path.replaceAll('.dart', '.freezed.dart'),
    // path.replaceAll('.dart', '.g.dart')
  ];
  final workingDirectory = path.substring(0, path.indexOf('/lib'));
  final r1 = await Process.run('cd', [workingDirectory]);
  print('R!: ${r1.exitCode}');
  final result = await Process.run('pwd', [], workingDirectory: workingDirectory);
  print(result.stdout);
  print('WD: $workingDirectory');
  for (final file in files) {
    print('FILE: $file');
    final result = await Process.run(
      'dart',
      [
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs',
        '--build-filter="$file"'
      ],
      workingDirectory: workingDirectory,
    );
    print(result.stdout);
  }
}
