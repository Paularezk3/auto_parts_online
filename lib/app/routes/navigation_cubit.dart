import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../core/utils/app_logger.dart';
import 'navigation_state.dart';

class NavigationCubit extends HydratedCubit<NavigationState> {
  final ILogger logger;

  NavigationCubit({required this.logger}) : super(NavigationHomePageState());

  @override
  void emit(NavigationState state) {
    logger.debug('State Emitted: $state');
    super.emit(state);
  }

  void navigateTo(NavigationState state) {
    emit(state);
  }

  @override
  NavigationState? fromJson(Map<String, dynamic> json) {
    final state = json['state'] as String?;
    switch (state) {
      case 'NavigationProductPageState':
        return NavigationProductPageState();
      case 'NavigationAccountPageState':
        return NavigationAccountPageState();
      case 'NavigationCartPageState':
        return NavigationCartPageState();
      default:
        return NavigationHomePageState();
    }
  }

  @override
  Map<String, dynamic>? toJson(NavigationState state) {
    return {'state': state.runtimeType.toString()};
  }
}
