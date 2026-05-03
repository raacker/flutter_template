import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/core/auth/no_auth_repository.dart';

void main() {
  testWidgets('starts without Supabase when no auth repository is used', (
    tester,
  ) async {
    await tester.pumpWidget(App(authRepository: NoAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Flutter Template'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });
}
