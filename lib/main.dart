import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// ADDED: the data model
class StudentProfile {
  const StudentProfile({
    required this.name,
    required this.course,
    required this.school,
    required this.email,
    required this.phone,
    required this.location,
    required this.level,
    required this.aboutMe,
  });

  final String name;
  final String course;
  final String school;
  final String email;
  final String phone;
  final String location;
  final String level;
  final String aboutMe;

  // The default (dummy) data, shown when nothing is saved yet
  static const StudentProfile defaults = StudentProfile(
    name: 'Yasiri Temwa Gaston',
    course: 'Software Engineering',
    school: 'University of Buea',
    email: 'yasiritemwa233@gmail.com',
    phone: '+237 689 407 899',
    location: 'Buea, Cameroon',
    level: 'Level 500',
    aboutMe: 'I am a Level 500 software engineering student at the '
        'Faculty of Engineering and Technology, University of Buea. '
        'I am doing my final year internship at Telnet Cameroon in Buea, '
        'and I am learning mobile app development with Flutter and Dart.',
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Student Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: ProfileScreen(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

// CHANGED: now a StatefulWidget
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // The profile currently shown on screen
  StudentProfile _profile = StudentProfile.defaults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Student Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            tooltip: widget.isDark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 18),
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/gabe.jpg'),
              ),
              const SizedBox(height: 18),
              Text(
                _profile.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _profile.course,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                _profile.school,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              InfoCard(
                icon: Icons.email,
                label: 'Email',
                value: _profile.email,
              ),
              InfoCard(
                icon: Icons.phone,
                label: 'Phone',
                value: _profile.phone,
              ),
              InfoCard(
                icon: Icons.location_city,
                label: 'Location',
                value: _profile.location,
              ),
              InfoCard(
                icon: Icons.school,
                label: 'Level',
                value: _profile.level,
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Me',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(_profile.aboutMe),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contact button pressed!'),
                      ),
                    );
                  },
                  child: const Text('Contact Me'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 2),
                  Text(value, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}