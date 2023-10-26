import 'package:flutter/material.dart';

const colorTheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff830BCE),
  onPrimary: Colors.white,
  secondary: Color(0xff9586A8),
  onSecondary: Colors.white,
  error: Color(0xffF24E1E),
  onError: Colors.white,
  background: Color(0xffF6F5F5),
  onBackground: Colors.white,
  surface: Colors.white,
  onSurface: Color(0xff2D0C57),
  outline: Color(0xffD9D0E3)
);

final textTheme = TextTheme(
  headlineLarge: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 34,
    letterSpacing: 0.41,
    color: colorTheme.onSurface
  ),
  titleLarge: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30,
    letterSpacing: 0.41,
    color: colorTheme.onSurface
  ),
  titleMedium: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22,
    letterSpacing: -0.41,
    color: colorTheme.onSurface
  ),
  titleSmall: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: colorTheme.onSurface
  ),
  labelLarge: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 24,
    letterSpacing: -0.8,
    color: colorTheme.secondary
  ),
  bodyLarge: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 17,
    letterSpacing: -0.41,
    color: colorTheme.secondary
  ),
);

final cardTheme = CardTheme(
  color: colorTheme.surface,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    side: BorderSide(width: 0.5, color: colorTheme.outline)
  )
);

final listTileTheme = ListTileThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    side: BorderSide(width: 0.5, color: colorTheme.outline)
  )
);

final inputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: Colors.white,
  labelStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.41,
    color: colorTheme.secondary
  ),
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(width: 0.5, color: colorTheme.outline)
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(width: 0.5, color: colorTheme.outline)
  ),
  outlineBorder: BorderSide(width: 0.5, color: colorTheme.outline),
  suffixIconColor: colorTheme.secondary,
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    minimumSize: const Size(double.infinity, 56),
    backgroundColor: colorTheme.primary,
    foregroundColor: Colors.white,
    disabledBackgroundColor: colorTheme.primary,
    disabledForegroundColor: colorTheme.secondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    textStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
      letterSpacing: -0.01,
      color: Colors.white,
    ),
  )
);

final dialogTheme = DialogTheme(
  backgroundColor: colorTheme.surface,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    side: BorderSide(width: 0.5, color: colorTheme.outline)
  )
);

final snackBarTheme = SnackBarThemeData(
  backgroundColor: Colors.grey[900],
  showCloseIcon: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
  ),
);

final bottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: const Color(0xffF8F8F8),
  selectedItemColor: colorTheme.primary,
  unselectedItemColor: colorTheme.secondary
);

final theme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  colorScheme: colorTheme,
  textTheme: textTheme,
  cardTheme: cardTheme,
  listTileTheme: listTileTheme,
  inputDecorationTheme: inputDecorationTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  dialogTheme: dialogTheme,
  snackBarTheme: snackBarTheme,
  bottomNavigationBarTheme: bottomNavigationBarTheme,
);