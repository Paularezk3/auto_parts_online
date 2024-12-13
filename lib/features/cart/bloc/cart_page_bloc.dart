import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_page_event.dart';
import 'cart_page_state.dart';

class CartPageBloc extends Bloc<CartPageEvent, CartPageState> {
  CartPageBloc() : super(CartPageInitial()) {
    on<LoadCartPage>(_loadCartPage);
  }

  void _loadCartPage(LoadCartPage state, Emitter<CartPageState> emit) {}
}
