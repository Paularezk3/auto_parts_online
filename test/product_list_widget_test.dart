import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/widgets/product_list.dart';
import 'package:my_app/services/product_service.dart';

class MockProductService extends Mock implements ProductService {}

void main() {
  testWidgets('displays a list of products', (WidgetTester tester) async {
    // Arrange
    final mockService = MockProductService();
    when(mockService.getProducts()).thenAnswer((_) async => [
          {'id': 1, 'name': 'Brake Pad', 'price': 50},
          {'id': 2, 'name': 'Oil Filter', 'price': 25},
        ]);

    // Act
    await tester.pumpWidget(ProductList(service: mockService));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Brake Pad'), findsOneWidget);
    expect(find.text('Oil Filter'), findsOneWidget);
  });
}
