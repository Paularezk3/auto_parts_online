// lib\app\routes\navigation_cubit.dart

import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../core/utils/app_logger.dart';
import 'navigation_state.dart';

class NavigationCubit extends HydratedCubit<List<NavigationState>> {
  final ILogger logger;

  NavigationCubit({required this.logger}) : super([NavigationHomePageState()]);

  NavigationState get currentState => state.last;

  void push(NavigationState state) {
    final updatedStack = List<NavigationState>.from(this.state)..add(state);
    logger.debug('Pushed to stack: $state', StackTrace.empty);
    emit(updatedStack);
  }

  void pop() {
    if (state.last.runtimeType == NavigationSearchPageState) {
      if (state[0].runtimeType == NavigationHomePageState) {
        emit([NavigationHomePageState()]);
      }
    }
    if (state.length > 1) {
      final updatedStack = List<NavigationState>.from(state)..removeLast();
      logger.debug(
          'Popped from stack, new top: ${updatedStack.last}', StackTrace.empty);
      emit(updatedStack);
    } else {
      logger.debug(
          'Cannot pop from stack, already at base state', StackTrace.empty);
    }
  }

  void navigateTo(NavigationState state) {
    emit([state]);
  }

  @override
  List<NavigationState>? fromJson(Map<String, dynamic> json) {
    final stack = (json['stack'] as List<dynamic>?)
        ?.map((item) => _mapStringToState(item as Map<String, dynamic>))
        .toList();
    return stack ?? [NavigationHomePageState()];
  }

  @override
  Map<String, dynamic>? toJson(List<NavigationState> state) {
    return {
      'stack': state.map((s) => _mapStateToString(s)).toList(),
    };
  }

  NavigationState _mapStringToState(Map<String, dynamic> json) {
    final state = json['state'] as String?;
    switch (state) {
      case 'NavigationProductPageState':
        return NavigationProductPageState();
      case 'NavigationAccountPageState':
        return NavigationAccountPageState();
      case 'NavigationCartPageState':
        return NavigationCartPageState();
      case 'NavigationSearchPageState':
        return NavigationSearchPageState();
      case 'NavigationProductDetailsPageState':
        return NavigationProductDetailsPageState.fromJson(json['arguments']);
      case 'NavigationCheckoutPageState':
        return NavigationCheckoutPageState.fromJson(json['arguments']);
      default:
        return NavigationHomePageState();
    }
  }

  Map<String, dynamic> _mapStateToString(NavigationState state) {
    if (state is NavigationProductDetailsPageState) {
      return {
        'state': state.runtimeType.toString(),
        'arguments': state.toJson(),
      };
    } else if (state is NavigationCheckoutPageState) {
      return {
        'state': state.runtimeType.toString(),
        'arguments': state.toJson()
      };
    }
    return {'state': state.runtimeType.toString()};
  }
}
