import 'package:auto_parts_online/features/checkout/bloc/checkout_page_event.dart';
import 'package:auto_parts_online/features/checkout/bloc/checkout_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPageBloc extends Bloc<CheckoutPageEvent, CheckoutPageState> {
  CheckoutPageBloc() : super(CheckoutPageInitial()) {
    on<LoadCheckoutPage>(_loadCheckoutPage);
  }

  _loadCheckoutPage(LoadCheckoutPage event, Emitter<CheckoutPageState> emit) {}
}
