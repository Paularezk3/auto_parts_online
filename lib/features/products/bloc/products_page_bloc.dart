import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/products/bloc/products_page_event.dart';
import 'package:auto_parts_online/features/products/bloc/products_page_state.dart';
import 'package:auto_parts_online/features/products/mock_products_page_service.dart';
import 'package:auto_parts_online/features/products/products_page_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPageBloc extends Bloc<ProductsPageEvent, ProductsPageState> {
  ILogger logger = getIt<ILogger>();

  IMockProductsPageService productsPageService =
      getIt<IMockProductsPageService>();
  ProductsPageBloc() : super(ProductsPageInitial()) {
    on<LoadProductsPage>(_onLoadProductsPage);
    on<UpdateFilterUI>(_updateFilterUI);
  }

  Future<void> _onLoadProductsPage(
      LoadProductsPage event, Emitter<ProductsPageState> emit) async {
    logger.trace("onLoadProducts BLoC Invoked", null);
    emit(ProductsPageLoading());

    try {
      final productsPageData =
          await productsPageService.fetchProductsPageData();
      emit(ProductsPageLoaded(productsPageData));
    } catch (e) {
      logger.error("onLoadProducts Failed: $e", StackTrace.current);
      ProductsPageError();
    }
  }

  void _updateFilterUI(UpdateFilterUI event, Emitter<ProductsPageState> emit) {
    ProductsPageData? currentProducts;

    if (state is ProductsPageLoaded) {
      currentProducts = (state as ProductsPageLoaded).products;
    } else if (state is FilterUIUpdated) {
      currentProducts = (state as FilterUIUpdated).products;
    }
    if (currentProducts == null) {
      logger.error("currentProducts is NULL!!", StackTrace.current);
    }
    emit(FilterUIUpdated(
      selectedFilterData: event.selectedFilterData,
      products: currentProducts!, // Preserve current products
    ));
  }
}
