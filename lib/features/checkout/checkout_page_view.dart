import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/common/layouts/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPageView extends StatelessWidget {
  const CheckoutPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtherPageAppBar(
        title: "Checkout",
        isLoading: false,
        showBackButton: true,
        onBackTap: () => context.read<NavigationCubit>().pop(),
      ),
      // body: ,
    );
  }
}
