// lib/features/cart/bloc/cart_page_bloc.dart
import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_cubit.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_state.dart';
import 'package:auto_parts_online/features/cart/mock_cart_page_service.dart';
import 'package:auto_parts_online/features/cart/models/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_page_event.dart';
import 'cart_page_state.dart';

class CartPageBloc extends Bloc<CartPageEvent, CartPageState> {
  final CartCubit cartCubit;
  final IMockCartPageService cartPageService = getIt<IMockCartPageService>();

  CartPageBloc(this.cartCubit) : super(CartPageInitial()) {
    // cartCubit.stream.listen((cartItemCount) {
    //   if(state is State)
    //   add(LoadCartPage(cartItemCount));
    // });
    on<LoadCartPage>(_loadCartPage);
    on<AddItemToCart>(_addItemToCart);
    on<RemoveItemFromCart>(_removeItemFromCart);
    on<ClearCart>(_clearCart);
    on<ReduceItemFromCart>(_reduceItemFromCart);
    on<AddPromocode>(_addPromocode);
    on<RemovePromocode>(_removePromocode);
    on<ChangeDeliveryMode>(_changeDeliveryMode);
    on<LeaveCartPage>((event, emit) => emit(CartPageLeft()));
  }

  void _loadCartPage(LoadCartPage event, Emitter<CartPageState> emit) async {
    emit(CartPageLoading());

    if (_isEmptyCart()) {
      emit(CartPageEmpty());
      return;
    } else if (cartCubit.state is CartLoadingState) {
      state is CartPageLoading ? null : emit(CartPageLoading());
      return;
    }

    emit(CartPageLoaded(cartPageData: cartCubit.state.cartPageItems));
  }

  Future<void> _addPromocode(
      AddPromocode event, Emitter<CartPageState> emit) async {
    emit(CartPageEditLoading(cartPageData: cartCubit.state.cartPageItems));

    final promocodeDetails =
        await cartPageService.checkPromoCode(event.promocode);
    if (promocodeDetails != null) {
      cartCubit.state.cartPageItems!.promocodeDetails.add(promocodeDetails);

      cartCubit.state.cartPageItems!.cartTotal =
          cartPageService.updateCartTotal(
              cartCubit.state.cartPageItems!.cartItems,
              cartCubit.state.cartPageItems!.deliveryStatus,
              cartCubit.state.cartPageItems!.promocodeDetails);
    }

    emit(CartPageLoaded(
      cartPageData: cartCubit.state.cartPageItems,
    ));
  }

  Future<void> _removePromocode(
      RemovePromocode event, Emitter<CartPageState> emit) async {
    emit(CartPageEditLoading(cartPageData: cartCubit.state.cartPageItems));

    cartCubit.state.cartPageItems!.promocodeDetails
        .removeAt(event.promocodeIndex);

    cartCubit.state.cartPageItems!.cartTotal = cartPageService.updateCartTotal(
        cartCubit.state.cartPageItems!.cartItems,
        cartCubit.state.cartPageItems!.deliveryStatus,
        cartCubit.state.cartPageItems!.promocodeDetails);

    emit(CartPageLoaded(
      cartPageData: cartCubit.state.cartPageItems,
    ));
  }

  Future<void> _changeDeliveryMode(
      ChangeDeliveryMode event, Emitter<CartPageState> emit) async {
    cartCubit.state.cartPageItems!.deliveryStatus.isFastDelivery =
        event.isFastDelivery;

    cartCubit.state.cartPageItems!.cartTotal = cartPageService.updateCartTotal(
        cartCubit.state.cartPageItems!.cartItems,
        cartCubit.state.cartPageItems!.deliveryStatus,
        cartCubit.state.cartPageItems!.promocodeDetails);

    emit(CartPageLoaded(cartPageData: cartCubit.state.cartPageItems));
  }

  Future<void> _addItemToCart(
      AddItemToCart event, Emitter<CartPageState> emit) async {
    _emitLoadingForEditingCart(emit);

    await cartCubit
        .addToCart(CartItem(quantity: 1, productId: event.item.productId));
    if (_isEmptyCart()) {
      emit(CartPageEmpty());
      return;
    }
    emit(CartPageLoaded(cartPageData: cartCubit.state.cartPageItems));
  }

  Future<void> _removeItemFromCart(
      RemoveItemFromCart event, Emitter<CartPageState> emit) async {
    _emitLoadingForEditingCart(emit);

    await cartCubit.removeFromCart(event.itemId);

    if (_isEmptyCart()) {
      emit(CartPageEmpty());
      return;
    }
    emit(CartPageLoaded(cartPageData: cartCubit.state.cartPageItems));
  }

  Future<void> _reduceItemFromCart(
      ReduceItemFromCart event, Emitter<CartPageState> emit) async {
    _emitLoadingForEditingCart(emit);

    await cartCubit.reduceItemFromCart(event.itemId, event.quantity);
    if (_isEmptyCart()) {
      emit(CartPageEmpty());
      return;
    }
    emit(CartPageLoaded(cartPageData: cartCubit.state.cartPageItems));
  }

  Future<void> _clearCart(ClearCart event, Emitter<CartPageState> emit) async {
    _emitLoadingForEditingCart(emit);

    cartCubit.clearCart();
    if (_isEmptyCart()) {
      emit(CartPageEmpty());
      return;
    }
    emit(CartPageLoaded(cartPageData: cartCubit.state.cartPageItems));
  }

  void _emitLoadingForEditingCart(Emitter<CartPageState> emit) {
    emit(CartPageEditLoading(
        cartPageData: state is CartPageLoaded
            ? (state as CartPageLoaded).cartPageData
            : (state as CartPageEditLoading).cartPageData));
  }

  bool _isEmptyCart() {
    return cartCubit.state is CartLoadingState
        ? false
        : (cartCubit.state.cartPageItems == null ||
            cartCubit.state.cartPageItems!.cartItems.isEmpty);
  }
}
