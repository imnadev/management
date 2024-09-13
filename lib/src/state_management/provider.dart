import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

extension ReadContext on BuildContext {
  T read<T>() {
    return Provider.of<T>(this, listen: false);
  }
}
