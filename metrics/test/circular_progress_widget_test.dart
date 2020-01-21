//command to run this test:
//flutter test ./test/circular_progress_widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/main.dart';

void main() {

  testWidgets('Circular Progress Bar Test One pass when progress is 50%.', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    final titlePercent = find.text('50%');
    expect(titlePercent, findsOneWidget);
  });

   testWidgets('Circular Progress Bar Test Two will pass only when coverage percent is 60%.', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    final titlePercent= find.text('60%');
     expect(titlePercent, findsOneWidget);    
  });

  

 
}
