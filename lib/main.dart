import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madcamp_week1/screens/contact_screen.dart';
import 'package:madcamp_week1/screens/gallery_screen.dart';
import 'package:madcamp_week1/screens/game_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class IntroScreen extends StatelessWidget{

  const IntroScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/logo.png'),
              fit: BoxFit.cover,
            ),
            Text(
              'Contact / Gallery / Variety',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 1',
      theme: _buildThemeData(),
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3),
            () => "Intro Completed",
        ),
        builder: (context, snapshot){
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: _splashLoadingWidget(snapshot),
          );
        },
      ),
    );


  }

  ThemeData _buildThemeData() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      appBarTheme: const AppBarTheme(color: Colors.indigoAccent),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.indigoAccent,
        type: BottomNavigationBarType.fixed,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: GoogleFonts.ibmPlexSansKrTextTheme(
        base.textTheme.apply(bodyColor: Colors.black87),
      ),
    );
  }

  Widget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot){
    if(snapshot.hasError){
      return const Text("error");
    }
    else if(snapshot.hasData){
      return const MyHomePage();
    }
    else{
      return const IntroScreen();
    }
  }
}

final _currentIndexProvider = StateProvider((ref) => 0);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(_currentIndexProvider);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: const [
            ContactScreen(),
            GalleryScreen(),
            GameScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(_currentIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            label: 'Contact',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Gallery',
            icon: Icon(Icons.image),
          ),
          BottomNavigationBarItem(
            label: 'Game',
            icon: Icon(Icons.videogame_asset),
          ),
        ],
      ),
    );
  }
}
