import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) =>
          DetailsPage(id: state.pathParameters['id']!),
    ),
  ],
);

void main() => runApp(MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    ));

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/details/5'), // go to a state/URL
          child: const Text('Open details 5'),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String id;
  const DetailsPage({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details $id')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Back home'),
        ),
      ),
    );
  }
}
