import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:body_mass_index/main.dart'; // Replace 'YOUR_PROJECT_NAME' with the actual name of your project

void main() {
  testWidgets('Test BMI Calculator', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterApp());

    // Verify that certain widgets are present in the app
    expect(find.text('BMI'), findsOneWidget);
    expect(find.text('Enter your Weight in kgs'), findsOneWidget);
    expect(find.text('Centimeters'), findsOneWidget);

    // You can add more test cases here to validate the behavior of your app

    // For example, to test the BMI calculation and result display
    // Enter weight, height, age, and tap the Calculate button
    await tester.enterText(find.byKey(const Key('weightField')), '70');
    await tester.enterText(find.byKey(const Key('heightField')), '170');
    await tester.enterText(find.byKey(const Key('ageField')), '30');
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    // Check if the result is displayed correctly
    expect(find.textContaining('Your BMI is: 24.22'), findsOneWidget);
    expect(find.textContaining("You're Normal weight!"), findsOneWidget);
  });
}
