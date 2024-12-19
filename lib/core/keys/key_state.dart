import 'package:flutter/material.dart';

abstract class KeyState {}

class KeysInitializedState extends KeyState {
  final Map<KeyType, GlobalKey> keys;

  KeysInitializedState(this.keys);
}

enum KeyType { searchBarAnimation, allHomeAppBarAnimation }
