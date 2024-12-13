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

  void goToHomePage() {
    emit(NavigationHomePageState());
  }

  void goToProductPage() {
    emit(NavigationProductPageState());
  }

  @override
  NavigationState? fromJson(Map<String, dynamic> json) {
    final state = json['state'] as String?;
    if (state == 'NavigationProductPageState') {
      return NavigationProductPageState();
    }
    return NavigationHomePageState();
  }

  @override
  Map<String, dynamic>? toJson(NavigationState state) {
    return {'state': state.runtimeType.toString()};
  }
}
