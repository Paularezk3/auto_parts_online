import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/checkout/bloc/checkout_page_event.dart';
import 'package:auto_parts_online/features/checkout/bloc/checkout_page_state.dart';
import 'package:auto_parts_online/features/checkout/mock_checkout_page_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/setup_dependencies.dart';

class CheckoutPageBloc extends Bloc<CheckoutPageEvent, CheckoutPageState> {
  IMockCheckoutPageService checkoutPageService =
      getIt<IMockCheckoutPageService>();
  ILogger logger = getIt<ILogger>();
  CheckoutPageBloc() : super(CheckoutPageInitial()) {
    on<LoadCheckoutPage>(_loadCheckoutPage);
    on<UpdateAddress>(_updateAddress);
    on<UpdatePaymentMethod>(_updatePaymentMethod);
    on<UpdatePoints>(_updatePoints);
    on<UpdateWidgetData>(_updateWidgetData);
    on<LeaveCheckoutPage>((event, emit) => emit(CheckoutPageLeft()));
  }

  _loadCheckoutPage(
      LoadCheckoutPage event, Emitter<CheckoutPageState> emit) async {
    emit(CheckoutPageLoading());

    try {
      final checkoutPageData = await checkoutPageService.fetchCheckoutPageData(
          "", event.cartDetails);

      emit(CheckoutPageLoaded(checkoutPageModel: checkoutPageData));
    } catch (e) {
      logger.error("Error loading checkout page: $e", StackTrace.current);
      emit(CheckoutPageError(message: "Error loading checkout page"));
    }
  }

  _updateAddress(UpdateAddress event, Emitter<CheckoutPageState> emit) {
    emit(
      CheckoutPageLoaded(
        checkoutPageModel:
            (state as CheckoutPageLoaded).checkoutPageModel.copyWith(
                  accountAddress: event.address,
                ),
      ),
    );
  }

  _updatePaymentMethod(
      UpdatePaymentMethod event, Emitter<CheckoutPageState> emit) {
    emit(
      CheckoutPageLoaded(
        checkoutPageModel:
            (state as CheckoutPageLoaded).checkoutPageModel.copyWith(
                  widgetData: (state as CheckoutPageLoaded)
                      .checkoutPageModel
                      .widgetData
                      .copyWith(paymentWay: event.paymentWay),
                ),
      ),
    );
  }

  _updatePoints(UpdatePoints event, Emitter<CheckoutPageState> emit) {
    emit(
      (state as CheckoutPageLoaded).copyWith(
        checkoutPageModel:
            (state as CheckoutPageLoaded).checkoutPageModel.copyWith(
                  accountPoints: (state as CheckoutPageLoaded)
                          .checkoutPageModel
                          .accountPoints -
                      event.pointsUsed,
                ),
      ),
    );
  }

  _updateWidgetData(UpdateWidgetData event, Emitter<CheckoutPageState> emit) {
    emit(
      CheckoutPageLoaded(
        checkoutPageModel: (state as CheckoutPageLoaded)
            .checkoutPageModel
            .copyWith(widgetData: event.widgetData),
      ),
    );
  }
}
