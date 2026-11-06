import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('TaskFlow home screen test', (WidgetTester tester) async {
    // Lancer notre application
    await tester.pumpWidget(const TaskFlowApp());

    // Vérifier le titre de l'application
    expect(find.text('TaskFlow'), findsOneWidget);

    // Vérifier le message de bienvenue
    expect(find.text('Bonjour ! 👋'), findsOneWidget);

    // Vérifier la section des tâches
    expect(find.text('Mes tâches'), findsOneWidget);

    // Vérifier le message lorsqu'il n'y a aucune tâche
    expect(
      find.text('Aucune tâche pour le moment.'),
      findsOneWidget,
    );

    // Vérifier la présence du bouton d'ajout
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}