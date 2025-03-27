import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  static final _lightTheme = ThemeData(
    primaryColor: Color(0xFF1E88E5),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF1E88E5),
      secondary: Color(0xFFBBDEFB),
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E88E5),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(color: Colors.white, elevation: 2),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black87),
    ),
    iconTheme: IconThemeData(color: Colors.black87),
    dividerColor: Colors.grey[300],
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[50],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF1E88E5)),
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF1E88E5),
      unselectedItemColor: Colors.grey[600],
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF1E88E5),
      foregroundColor: Colors.white,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black87),
      contentTextStyle: TextStyle(color: Colors.black87),
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.black87,
      iconColor: Colors.black87,
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: MaterialStateProperty.all(
        Color(0xFF1E88E5).withOpacity(0.1),
      ),
      dataRowColor: MaterialStateProperty.all(Colors.white),
      headingTextStyle: TextStyle(color: Colors.black87),
      dataTextStyle: TextStyle(color: Colors.black87),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: Colors.white,
      textColor: Colors.black87,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: Colors.black87),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Color(0xFF1E88E5)),
      trackColor: MaterialStateProperty.all(Color(0xFF1E88E5).withOpacity(0.5)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(Color(0xFF1E88E5)),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(Color(0xFF1E88E5)),
    ),
  );

  static final _darkTheme = ThemeData(
    primaryColor: Color(0xFF1E88E5),
    scaffoldBackgroundColor: Color(0xFF050505),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF1E88E5),
      secondary: Color(0xFFBBDEFB),
      surface: Color(0xFF121212),
      background: Color(0xFF050505),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      surfaceVariant: Color(0xFF1E1E1E),
      onSurfaceVariant: Colors.white70,
      outline: Color(0xFF2C2C2C),
      shadow: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF101010),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF151515),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    dividerColor: Color(0xFF2A2A2A),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xFF1A1A1A),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF2A2A2A)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF2A2A2A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF1E88E5)),
      ),
      labelStyle: TextStyle(color: Colors.white70),
      hintStyle: TextStyle(color: Colors.white38),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorColor: Color(0xFF1E88E5),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0A0A0A),
      selectedItemColor: Color(0xFF1E88E5),
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF1E88E5),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF151515),
      titleTextStyle: TextStyle(color: Colors.white),
      contentTextStyle: TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
      tileColor: Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: MaterialStateProperty.all(Color(0xFF1E1E1E)),
      dataRowColor: MaterialStateProperty.all(Color(0xFF151515)),
      headingTextStyle: TextStyle(color: Colors.white),
      dataTextStyle: TextStyle(color: Colors.white),
      dividerThickness: 1,
      horizontalMargin: 16,
      columnSpacing: 24,
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: Color(0xFF1A1A1A),
      textColor: Colors.white,
      iconColor: Colors.white,
      collapsedBackgroundColor: Color(0xFF151515),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF1A1A1A),
      labelStyle: TextStyle(color: Colors.white),
      secondaryLabelStyle: TextStyle(color: Colors.white70),
      secondarySelectedColor: Color(0xFF1E88E5).withOpacity(0.1),
      selectedColor: Color(0xFF1E88E5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.all(8),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Color(0xFF1E88E5)),
      trackColor: MaterialStateProperty.all(Color(0xFF1E88E5).withOpacity(0.5)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(Color(0xFF1E88E5)),
      checkColor: MaterialStateProperty.all(Colors.white),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(Color(0xFF1E88E5)),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Color(0xFF151515),
      headerBackgroundColor: Color(0xFF1E1E1E),
      headerForegroundColor: Colors.white,
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Color(0xFF1E88E5);
        }
        return null;
      }),
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.white;
      }),
      todayBackgroundColor: MaterialStateProperty.all(
        Color(0xFF1E88E5).withOpacity(0.2),
      ),
      todayForegroundColor: MaterialStateProperty.all(Colors.white),
      yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Color(0xFF1E88E5);
        }
        return null;
      }),
      yearForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.white;
      }),
      surfaceTintColor: Colors.transparent,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Color(0xFF151515),
      hourMinuteTextColor: Colors.white,
      dayPeriodTextColor: Colors.white,
      dialBackgroundColor: Color(0xFF1A1A1A),
      dialHandColor: Color(0xFF1E88E5),
      dialTextColor: Colors.white,
      entryModeIconColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF1E88E5)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Color(0xFF1E88E5),
      inactiveTrackColor: Color(0xFF2A2A2A),
      thumbColor: Color(0xFF1E88E5),
      overlayColor: Color(0xFF1E88E5).withOpacity(0.2),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Color(0xFF1E88E5),
      linearTrackColor: Color(0xFF2A2A2A),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Color(0xFF1E88E5);
          }
          return Color(0xFF1A1A1A);
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.white70;
        }),
      ),
    ),
  );
}
