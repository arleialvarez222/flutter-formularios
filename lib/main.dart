import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:formularios_app/screens/product_screen.dart';
import 'package:formularios_app/screens/screen.dart';
import 'package:formularios_app/services/services.dart';
 
void main() => runApp(AppState());


class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
      ],
      child: MyApp(),
    );
  }
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'registro': (_) => RegistroScreen(),
        'home': (_) => HomeScreen(),
        'product': (_) => ProductScreen(),
        'checking': (_) => CheckAuthScreen(),
      },
      //widget que me permite mostrar mensajes en cualquier lugar
      scaffoldMessengerKey: NotificationService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        ) 
      ),
    );
  }
}