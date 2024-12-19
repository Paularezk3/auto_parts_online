import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

import 'key_state.dart';

class KeyBloc extends Cubit<KeyState> {
  KeyBloc() : super(KeysInitializedState({}));

  void initializeKey(KeyType keyType) {
    final currentKeys = (state as KeysInitializedState).keys;
    if (!currentKeys.containsKey(keyType)) {
      currentKeys[keyType] = GlobalKey();
      emit(KeysInitializedState(currentKeys));
    }
  }

  GlobalKey? getKey(KeyType keyType) {
    final currentKeys = (state as KeysInitializedState).keys;
    return currentKeys[keyType];
  }
}
