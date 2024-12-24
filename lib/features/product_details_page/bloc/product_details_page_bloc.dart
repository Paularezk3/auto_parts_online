import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/product_details_page/bloc/product_details_page_event.dart';
import 'package:auto_parts_online/features/product_details_page/bloc/product_details_page_state.dart';
import 'package:auto_parts_online/features/product_details_page/mock_product_details_page_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPageBloc
    extends Bloc<ProductDetailsPageEvent, ProductDetailsPageState> {
  ILogger logger = getIt<ILogger>();
  IMockProductDetailsPageService productDetailsService =
      getIt<IMockProductDetailsPageService>();
  ProductDetailsPageBloc() : super(ProductDetailsPageInitial()) {
    on<LoadProductDetailsPage>(_onLoadProductDetailsPage);
    on<ReturnToInitialState>(
      (event, emit) => emit(ProductDetailsPageInitial()),
    );
  }

  Future<void> _onLoadProductDetailsPage(LoadProductDetailsPage event,
      Emitter<ProductDetailsPageState> emit) async {
    emit(ProductDetailsPageLoading());

    try {
      logger.trace(
          "Fetching Product with ID: ${event.productId}", StackTrace.empty);
      final productDetails = await productDetailsService
          .fetchProductDetailsPageData(event.productId);
      emit(ProductDetailsPageLoaded(productDetails));
    } catch (e) {
      emit(ProductDetailsPageError());
    }
  }
}
