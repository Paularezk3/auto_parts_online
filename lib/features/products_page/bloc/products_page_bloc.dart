import 'package:auto_parts_online/features/products_page/bloc/products_page_event.dart';
import 'package:auto_parts_online/features/products_page/bloc/products_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPageBloc extends Bloc<ProductsPageEvent, ProductsPageState> {
  ProductsPageBloc() : super(ProductsPageInitial()) {
    on<LoadProductsPage>(_loadProductsPage);
  }
}

Future<void> _loadProductsPage(
    LoadProductsPage event, Emitter<ProductsPageState> emit) async {}
