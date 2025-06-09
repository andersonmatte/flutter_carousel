import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_carousel_flutter/widget_carousel_flutter.dart';

void main() {
  // Helper: creates a basic carousel for testing
  Widget createTestCarousel({
    Duration? autoplayInterval,
    bool circular = false,
    bool showPaginator = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: WidgetCarouselFlutter(
          items: List.generate(6, (index) => 'Item $index'),
          itemBuilder: (context, item) => Text(item),
          numVisible: 2,
          numScroll: 2,
          circular: circular,
          autoplayInterval: autoplayInterval,
          scrollDirection: Axis.horizontal,
          showPaginator: showPaginator,
        ),
      ),
    );
  }

  testWidgets('renders FlutterCarousel with items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestCarousel());

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });

  testWidgets('navigates to next page when forward button is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestCarousel());

    // Wait for the initial layout
    await tester.pumpAndSettle();

    // Tap the forward button
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    expect(find.text('Item 2'), findsOneWidget);
    expect(find.text('Item 3'), findsOneWidget);
  });

  testWidgets('navigates to previous page when back button is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestCarousel());

    await tester.pumpAndSettle();

    // Go first
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    // Then come back
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });

  testWidgets('autoplay navigates automatically', (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestCarousel(autoplayInterval: const Duration(seconds: 1)),
    );

    await tester.pumpAndSettle();

    // Wait for autoplay time (1 second + animation)
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Item 2'), findsOneWidget);
  });

  testWidgets('paginator is hidden when showPaginator is false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestCarousel(showPaginator: false));
    expect(find.byType(Container), findsNothing);
  });
}
