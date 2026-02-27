import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:Dewa/main.dart';
import 'package:Dewa/screens/splash_screen.dart';

void main() {
  testWidgets('PaymentApp launches with splash screen', (tester) async {
    await tester.pumpWidget(const PaymentApp());

    // First frame
    expect(find.byType(GetMaterialApp), findsOneWidget);

    // Splash should be visible initially
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}