import '../online_payment_page_model.dart';

abstract class OnlinePaymentPageState {}

class OnlinePaymentPageInitial extends OnlinePaymentPageState {}

class OnlinePaymentPageLoading extends OnlinePaymentPageState {}

class OnlinePaymentPageLoaded extends OnlinePaymentPageState {
  final OnlinePaymentPageModel onlinePaymentData;
  OnlinePaymentPageLoaded(this.onlinePaymentData);
}

class OnlinePaymentPageError extends OnlinePaymentPageState {
  final String errorMessage;
  OnlinePaymentPageError(this.errorMessage);
}

class OnlinePaymentPageLeft extends OnlinePaymentPageState {}
