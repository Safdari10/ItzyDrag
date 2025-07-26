import 'package:flutter/material.dart';
import "package:audioplayers/audioplayers.dart";
import 'package:itzy_drag/widgets/animal_draggable.dart';
import 'package:itzy_drag/widgets/home_target.dart';

final List<Map<String, String>> animalHomePairs = [
  {"animal": "assets/images/cat.png", "home": "assets/images/house.png"},
  {"animal": "assets/images/dog.png", "home": "assets/images/kennel.png"},
  {"animal": "assets/images/bird.png", "home": "assets/images/nest.png"},
];

void main() {
  runApp(const MyApp());
}

// The root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drag-and-Drop Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Drag-and-Drop Game'),
    );
  }
}

// The main game screen
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDropped = false;
  List<String> matchedAnimals = []; // to store the matched animals
  static final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Game instructions or success message
            Text(
              _isDropped
                  ? 'Great job! You matched all the animals!'
                  : 'Drag the animal into its home.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            // Row with draggable box and target
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Draggable animals
                Column(
                  children: animalHomePairs.map((pair) {
                    if (matchedAnimals.contains(pair["animal"])) {
                      return const SizedBox(height: 80); // Hide matched animal
                    }
                    return AnimalDraggable(
                      imagePath: pair["animal"]!,
                      isMatched: matchedAnimals.contains(pair["animal"]),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 60),
                // Drop targets (homes)
                Column(
                  children: animalHomePairs.map((pair) {
                    return HomeTarget(
                      homeImage: pair["home"]!,
                      expectedAnimal: pair["animal"]!,
                      onMatched: (animal) async {
                        setState(() {
                          matchedAnimals.add(animal);
                          if (matchedAnimals.length == animalHomePairs.length) {
                            _isDropped = true;
                          }
                        });
                        if (matchedAnimals.length == animalHomePairs.length) {
                          await player.play(
                            AssetSource('sounds/levelfinish.mp3'),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Play Again button
            if (_isDropped)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isDropped = false;
                    matchedAnimals.clear();
                  });
                },
                child: const Text('Play Again'),
              ),
          ],
        ),
      ),
    );
  }
}
