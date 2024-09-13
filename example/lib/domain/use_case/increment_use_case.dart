import 'package:injectable/injectable.dart';

@lazySingleton
class IncrementUseCase {
  Future<int> call(int counter) async {
    await Future.delayed(const Duration(seconds: 1));
    return counter + 1;
  }
}
