import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kosfinder_mini/main.dart';

void main() {
  testWidgets('displays the KosFinder list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('KosFinder Mini'), findsOneWidget);
    expect(find.text('Kos Melati'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    expect(find.text('Kos Dahlia'), findsOneWidget);
  });

  testWidgets('filters kos by name and toggles favorite',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'melati');
    await tester.pump();

    expect(find.text('Kos Melati'), findsOneWidget);
    expect(find.text('Kos Mawar'), findsNothing);

    final favoriteButton = find.byTooltip('Tambah ke favorit');
    await tester.tap(favoriteButton);
    await tester.pump();

    expect(find.byTooltip('Hapus dari favorit'), findsOneWidget);
  });

  testWidgets('shows an empty state for an unknown kos',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'Tidak Ada');
    await tester.pump();

    expect(find.text('Kos tidak ditemukan'), findsOneWidget);
  });
}
