import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/features/online_payment/bloc/online_payment_page_event.dart';
import 'package:auto_parts_online/features/online_payment/bloc/online_payment_page_state.dart';
import 'package:auto_parts_online/features/online_payment/mock_online_payment_page_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlinePaymentPageBloc
    extends Bloc<OnlinePaymentPageEvent, OnlinePaymentPageState> {
  IMockOnlinePaymentPage onlinePaymentService = getIt<IMockOnlinePaymentPage>();
  OnlinePaymentPageBloc() : super(OnlinePaymentPageInitial()) {
    on<LoadOnlinePaymentPage>(_onLoadOnlinePayment);
    on<LeaveOnlinePaymentPage>(_onLeaveOnlinePayment);
    on<UpdateOnlinePaymentPage>(_onUpdateOnlinePayment);
  }

  Future<void> _onLoadOnlinePayment(
      LoadOnlinePaymentPage event, Emitter<OnlinePaymentPageState> emit) async {
    emit(OnlinePaymentPageLoading());

    try {
      final onlinePaymentData = await onlinePaymentService
          .loadOnlinePaymentPage(event.paymentWay, event.paymentAmount);
      emit(OnlinePaymentPageLoaded(onlinePaymentData));
    } catch (e) {
      emit(OnlinePaymentPageError(e.toString()));
    }
  }

  _onLeaveOnlinePayment(
      LeaveOnlinePaymentPage event, Emitter<OnlinePaymentPageState> emit) {
    emit(OnlinePaymentPageLeft());
  }

  _onUpdateOnlinePayment(
      UpdateOnlinePaymentPage event, Emitter<OnlinePaymentPageState> emit) {
    emit(OnlinePaymentPageLoaded(event.onlinePaymentData));
  }
}
