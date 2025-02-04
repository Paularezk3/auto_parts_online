import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_page_event.dart';
import 'account_page_state.dart';

class AccountPageBloc extends Bloc<AccountPageEvent, AccountPageState> {
  AccountPageBloc() : super(AccountPageInitial()) {
    on<LoadAccountPage>(_loadAccountPage);
  }

  void _loadAccountPage(
      LoadAccountPage state, Emitter<AccountPageState> emit) {}
}
