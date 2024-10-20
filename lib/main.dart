import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/base/base_widget.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Solaiman', useMaterial3: false),
        home: BanglaWeather(),
        locale: Locale('bn', 'BD'),
      ),
    ),
  );
}
