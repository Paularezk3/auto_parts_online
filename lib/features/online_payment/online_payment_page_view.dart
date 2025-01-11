import 'dart:io';

import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/common/layouts/default_appbar.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/core/constants/app_colors.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/checkout/checkout_page_model.dart';
import 'package:auto_parts_online/features/online_payment/bloc/online_payment_page_bloc.dart';
import 'package:auto_parts_online/features/online_payment/bloc/online_payment_page_state.dart';
import 'package:auto_parts_online/features/online_payment/online_payment_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app/setup_dependencies.dart';
import '../../common/layouts/error_page.dart';
import 'bloc/online_payment_page_event.dart';

class OnlinePaymentPageView extends StatelessWidget {
  final PaymentWay paymentWay;
  final double paymentAmount;
  const OnlinePaymentPageView(
      {required this.paymentAmount, required this.paymentWay, super.key});

  @override
  Widget build(BuildContext context) {
    final ILogger logger = getIt<ILogger>();

    context
        .read<OnlinePaymentPageBloc>()
        .add(LoadOnlinePaymentPage(paymentWay, paymentAmount));
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        logger.info("Pop Scope Invoked", StackTrace.empty);
        context.read<OnlinePaymentPageBloc>().add(LeaveOnlinePaymentPage());
      },
      child: Scaffold(
        appBar: OtherPageAppBar(
          title: "Online Payment",
          isLoading: false,
          onBackTap: () {
            context.read<NavigationCubit>().pop();
            context.read<OnlinePaymentPageBloc>().add(LeaveOnlinePaymentPage());
          },
          showBackButton: true,
        ),
        body: BlocBuilder<OnlinePaymentPageBloc, OnlinePaymentPageState>(
            buildWhen: (previous, current) =>
                (current is OnlinePaymentPageLeft) ? false : true,
            builder: (context, state) {
              logger.trace("current state is $state", StackTrace.empty);
              if (state is OnlinePaymentPageInitial) {
                return SkeletonLoader();
              } else if (state is OnlinePaymentPageLoading) {
                return SkeletonLoader();
              } else if (state is OnlinePaymentPageLoaded) {
                final onlinePaymentData = state.onlinePaymentData;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildPaymentAmountSection(
                                    context, paymentAmount),
                                const SizedBox(height: 16),
                                if (onlinePaymentData.paymentWay ==
                                    PaymentWay.vodafoneCash)
                                  _buildVodafoneCashSection(
                                      context,
                                      onlinePaymentData.vadafoneCashNumber,
                                      _getPaymentMethodDetails(
                                          state.onlinePaymentData.paymentWay)!,
                                      state.onlinePaymentData
                                          .vadafoneCashNumberLink!),
                                if (onlinePaymentData.paymentWay ==
                                    PaymentWay.instapay)
                                  _buildInstaPaySection(
                                      context,
                                      onlinePaymentData.instapayUrl!,
                                      _getPaymentMethodDetails(
                                          state.onlinePaymentData.paymentWay)!),
                                const SizedBox(height: 16),
                                _buildUploadReferenceSection(
                                  context,
                                  state.onlinePaymentData.widgetData.image,
                                  (image) => context
                                      .read<OnlinePaymentPageBloc>()
                                      .add(UpdateOnlinePaymentPage(
                                          onlinePaymentData.copyWith(WidgetData(
                                              isReferenceUploaded: true,
                                              image: image)))),
                                  () => context
                                      .read<OnlinePaymentPageBloc>()
                                      .add(UpdateOnlinePaymentPage(
                                          onlinePaymentData.copyWith(WidgetData(
                                              isReferenceUploaded: false,
                                              image: null)))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (state
                            .onlinePaymentData.widgetData.isReferenceUploaded)
                          PrimaryButton(
                            onPressed: () {
                              context
                                  .read<NavigationCubit>()
                                  .push(NavigationOrderPlacedSuccessfullyState(
                                    paymentWay,
                                  ));
                            },
                            logger: logger,
                            text: "Place Order",
                          )
                      ]),
                );
              } else if (state is OnlinePaymentPageError) {
                return ErrorPage(
                  state.errorMessage,
                  logger: logger,
                  onButtonPressed: () => context
                      .read<OnlinePaymentPageBloc>()
                      .add(LoadOnlinePaymentPage(paymentWay, paymentAmount)),
                );
              }
              return ErrorPage(
                "Unknown State",
                logger: logger,
                onButtonPressed: () => context
                    .read<OnlinePaymentPageBloc>()
                    .add(LoadOnlinePaymentPage(paymentWay, paymentAmount)),
              );
            }),
      ),
    );
  }

  Widget _buildPaymentAmountSection(
      BuildContext context, double paymentAmount) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Amount",
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            Text(
              "E£ ${paymentAmount.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVodafoneCashSection(BuildContext context, String? cashNumber,
      Widget info, String vodafoneCashNumberLink) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Vodafone Cash Number",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                if (cashNumber != null) {
                  Clipboard.setData(ClipboardData(text: cashNumber));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Number copied to clipboard"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cashNumber ?? "Not Available",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const Icon(
                      Icons.copy,
                      color: AppColors.primaryLight,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                await launchUrlString(vodafoneCashNumberLink);
              },
              style: ButtonStyle(
                  elevation: WidgetStatePropertyAll(5),
                  side: WidgetStatePropertyAll(BorderSide(color: Colors.grey))),
              icon: const Icon(Icons.open_in_browser),
              label: const Text("Pay with Vodafone Cash"),
            ),
            const SizedBox(height: 4),
            info,
          ],
        ),
      ),
    );
  }

  Widget _buildInstaPaySection(
      BuildContext context, String instapayUrl, Widget info) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "InstaPay Payment",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(instapayUrl))) {
                  await launchUrl(Uri.parse(instapayUrl));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to launch InstaPay")),
                  );
                }
              },
              style: ButtonStyle(
                  elevation: WidgetStatePropertyAll(5),
                  side: WidgetStatePropertyAll(BorderSide(color: Colors.grey))),
              icon: const Icon(Icons.open_in_browser),
              label: const Text("Pay with InstaPay"),
            ),
            const SizedBox(height: 4),
            info,
          ],
        ),
      ),
    );
  }

  Widget _buildUploadReferenceSection(
      BuildContext context,
      XFile? uploadedImage,
      Function(XFile) onReferenceUploaded,
      VoidCallback onReferenceDeleted) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Upload Payment Reference",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 12),
            if (uploadedImage == null) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    onReferenceUploaded(image);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Uploaded: ${image.name}"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.upload),
                label: const Text("Upload Reference"),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    onReferenceUploaded(image);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Captured: ${image.name}"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Capture Reference"),
              ),
            ] else ...[
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(uploadedImage.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blueAccent),
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? newImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (newImage != null) {
                                onReferenceUploaded(newImage);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Updated: ${newImage.name}"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () {
                              onReferenceDeleted();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Image deleted"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Current Image: ${uploadedImage.name}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget? _getPaymentMethodDetails(PaymentWay method) {
    switch (method) {
      case PaymentWay.instapay:
        return _buildNote(
            "Use the InstaPay link to complete your payment securely. Don't worry, our team will verify the payment.",
            method);
      case PaymentWay.vodafoneCash:
        return _buildNote(
            "Copy the Vodafone Cash number and send the amount. Rest assured, our team will confirm the transaction.",
            method);
      default:
        return null;
    }
  }

  Widget _buildNote(String message, PaymentWay method) {
    switch (method) {
      case PaymentWay.instapay:
        return Container(
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.green),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(message, style: TextStyle(color: Colors.green))),
            ],
          ),
        );
      default:
        return Container(
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(message, style: TextStyle(color: Colors.blue))),
            ],
          ),
        );
    }
  }
}
