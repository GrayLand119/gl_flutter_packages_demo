import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/gl_flutter_kit.dart';
// import 'test_app.dart';


void main() {
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    // expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });

  // test('test tapped', () {
  //   Tapped(child: Container(width: 50, height: 50,),);
  // });

  // testWidgets('Test GLWidgets', (WidgetTester tester) async {
  //   await tester.pumpWidget(test_app());
  //   var _tappedWidget = find.byWidget(Tapped());
  //   // var _tappedWidget = find.byWidget(Tapped());
  //   expect(_tappedWidget, findsOneWidget);
  //   // print('start tap 4 times');
  //   // tester.tap(_tappedWidget);
  //   // tester.tap(_tappedWidget);
  //   // tester.tap(_tappedWidget);
  //   // tester.tap(_tappedWidget);
  //
  // });
}
