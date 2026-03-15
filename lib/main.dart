import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Screens/Happy_screen.dart';
import '/Screens/artists_screen.dart';
import '/Screens/raag_screen.dart';
import '/Screens/tanpura_screen.dart';
//import 'Screens/raag_taal_screen.dart';
import 'Screens/screens.dart';
import 'models/artist_model.dart';
import 'models/raag_model.dart';


// RIO PR bot test: small edit to trigger API endpoint discovery
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home:const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/song', page: () => const SongScreen()),
        GetPage(name: '/playlist', page: () => const PlaylistScreen()),
        GetPage(name: '/raag', page: () => const DetScreen()),
        GetPage(name: '/taal', page: () => const TaalScreen()),
        GetPage(name: '/tanpura', page: () => const TanpuraScreen()),
        GetPage(name: '/mood', page: () => const HappyScreen()),
        GetPage(name: '/artist', page: () =>  ArtistScreen(artist: Artist.artists[0])),
        GetPage(name: '/raag_scr', page: () =>  RaagScreen(raag: Raag.ragas[1],)),

      ],
    );
  }
}
