import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultSwitchListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final Function(bool)? onChanged;

  const DefaultSwitchListTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // Cupertino version for iOS
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              thumbColor: Colors.white,
            ),
          ],
        ),
      );
    } else {
      // Material version for Android or other platforms
      return SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: Theme.of(context).colorScheme.primary,
        // activeThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey.shade300,
        inactiveThumbColor: Colors.grey,
      );
    }
  }
}
