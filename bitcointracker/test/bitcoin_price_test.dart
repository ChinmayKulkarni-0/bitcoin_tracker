import 'package:bitcointracker/Screens/tracker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Bitcoin price screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: BitcoinPriceScreen()));

    // Verify that the app bar displays the correct title
    expect(find.text('Bitcoin Prices'), findsOneWidget);

    // Verify that the initial selected currency is USD
    expect(find.text('USD'), findsOneWidget);

    // Verify that the initial bitcoin price is displayed correctly
    expect(find.text('\$29,120.2863'), findsOneWidget);

    // Tap the second currency (GBP)
    await tester.tap(find.text('GBP'));
    await tester.pump();

    // Verify that the selected currency has changed to GBP
    expect(find.text('GBP'), findsOneWidget);

    // Verify that the bitcoin price for GBP is displayed correctly
    expect(find.text('£24,332.6783'), findsOneWidget);

    // Tap the third currency (EUR)
    await tester.tap(find.text('EUR'));
    await tester.pump();

    // Verify that the selected currency has changed to EUR
    expect(find.text('EUR'), findsOneWidget);

    // Verify that the bitcoin price for EUR is displayed correctly
    expect(find.text('€28,367.4104'), findsOneWidget);
  });
}
