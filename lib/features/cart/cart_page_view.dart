import 'package:auto_parts_online/common/layouts/base_screen.dart';
import 'package:auto_parts_online/features/account/bloc/account_page_bloc.dart';
import 'package:auto_parts_online/features/account/bloc/account_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPageView extends StatelessWidget {
  const CartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedIndex: 2,
      child: BlocBuilder<AccountPageBloc, AccountPageState>(
          builder: (context, state) {
        return const Scaffold();
      }),
    );
  }
}
