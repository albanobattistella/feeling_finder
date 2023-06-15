import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tray_manager/tray_manager.dart';

import 'emoji/emoji_page.dart';
import 'localization/gen/app_localizations.dart';
import 'settings/cubit/settings_cubit.dart';
import 'settings/settings_page.dart';
import 'shortcuts/app_shortcuts.dart';
import 'theme/app_theme.dart';

/// The base widget that configures the application.
class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
    super.onTrayIconMouseDown();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
    super.onTrayIconRightMouseDown();
  }

  @override
  Widget build(BuildContext context) {
    // The BlocBuilder widget will rebuild the
    // MaterialApp whenever the ThemeMode is changed.
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background. This is a setting relevent to mobile devices.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('de', ''), // German, no country code
            Locale('it', ''), // Italian, no country code
            Locale('ru', ''), // Russian, no country code
            Locale('pt', ''), // Portuguese, no country code
            Locale('pt', 'BR'), // Brazilian Portuguese
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsCubit's state to display the correct theme.
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsPage.routeName:
                    return AppShortcuts(child: const SettingsPage());
                  default:
                    return AppShortcuts(child: const EmojiPage());
                }
              },
            );
          },
        );
      },
    );
  }
}
