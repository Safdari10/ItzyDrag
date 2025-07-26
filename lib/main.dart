import 'package:flutter/material.dart';

final List<Map<String, String>> animalHomePairs = [
  {"animal": "assets/images/cat.jpg", "home": "assets/images/house.jpg"},
  {"animal": "assets/images/dog.jpg", "home": "assets/images/kennel.jpg"},
  {"animal": "assets/images/bird.jpg", "home": "assets/images/nest.jpg"},
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
                  ? 'Great job! You dropped the box!'
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Draggable<String>(
                        data: pair['animal']!,
                        feedback: Image.asset(
                          pair['animal']!,
                          width: 80,
                          height: 80,
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: Image.asset(
                            pair['animal']!,
                            width: 80,
                            height: 80,
                          ),
                        ),
                        child: Image.asset(
                          pair['animal']!,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 60),
                // Drop targets (homes)
                Column(
                  children: animalHomePairs.map((pair) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DragTarget<String>(
                        builder: (context, candidateData, rejectedData) {
                          return Image.asset(
                            pair['home']!,
                            width: 80,
                            height: 80,
                          );
                        },
                        onAcceptWithDetails: (recievedAnimal) {
                          if (recievedAnimal.data == pair['animal']) {
                            setState(() {
                              matchedAnimals.add(recievedAnimal.data);
                              // Optionally, check if all animals are matched and show a message
                              if (matchedAnimals.length ==
                                  animalHomePairs.length) {
                                _isDropped = true;
                              }
                            });
                          } else {
                            // Optionally, show feedback for incorrect match
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Try again!')),
                            );
                          }
                        },
                      ),
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
