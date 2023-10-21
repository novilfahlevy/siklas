import 'package:flutter/material.dart';

const textTheme = TextTheme(
  headlineLarge: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 29,
    height: 1.24
  ),
  headlineMedium: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.28
  ),
  headlineSmall: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 19,
    height: 1.28
  ),
  bodyLarge: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 1.44
  ),
  bodyMedium: TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 18,
    height: 1.32,
    wordSpacing: 20
  ),
);

const cardTheme = CardTheme(
  shape: BeveledRectangleBorder()
);

const inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(),
);

const listTileTheme = ListTileThemeData(
  shape: BeveledRectangleBorder(
    side: BorderSide(
      color: Colors.grey,
      width: .5
    )
  )
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    shape: const BeveledRectangleBorder()
  )
);

final theme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  textTheme: textTheme,
  cardTheme: cardTheme,
  inputDecorationTheme: inputDecorationTheme,
  listTileTheme: listTileTheme,
  elevatedButtonTheme: elevatedButtonTheme,
);