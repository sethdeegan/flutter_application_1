import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }
  runApp(FirestoreExampleApp());
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class FirestoreExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example App',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Sample"),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  var query = await FirebaseFirestore.instance
                      .collection('courses')
                      .get(GetOptions(source: Source.server));
                  print(query.metadata.isFromCache);
                  query.docs.forEach((element) {
                    print(element.data());
                  });
                },
                child: const Text("Get collection server"),
              ),
              ElevatedButton(
                onPressed: () async {
                  var query = await FirebaseFirestore.instance
                      .collection('courses')
                      .get(GetOptions(source: Source.cache));
                  print(query.metadata.isFromCache);
                  query.docs.forEach((element) {
                    print(element.data());
                  });
                },
                child: const Text("Get collection cache"),
              ),
              ElevatedButton(
                onPressed: () async {
                  var query = await FirebaseFirestore.instance
                      .doc('courses/CaCN8Ai2rKoXfbrRqVoQ')
                      .get(GetOptions(source: Source.server));
                  print(query.metadata.isFromCache);
                  print(query.data());
                },
                child: const Text("Get doc server"),
              ),
              ElevatedButton(
                onPressed: () async {
                  var query = await FirebaseFirestore.instance
                      .doc('courses/CaCN8Ai2rKoXfbrRqVoQ')
                      .get(GetOptions(source: Source.cache));
                  print(query.metadata.isFromCache);
                  print(query.data());
                },
                child: const Text("Get doc cache"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
