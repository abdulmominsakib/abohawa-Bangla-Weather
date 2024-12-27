import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/location_permission_provider.dart';

class LocationPermissionStatusWidget extends StatelessWidget {
  final VoidCallback onRequestPermission;
  final String errorMessage;

  const LocationPermissionStatusWidget({
    super.key,
    required this.onRequestPermission,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white70,
              decorationColor: Colors.white,
            ),
      ),
      child: _Information(
        errorMessage: errorMessage,
        onRequestPermission: onRequestPermission,
      ),
    );
  }
}

class _Information extends ConsumerWidget {
  const _Information({
    required this.errorMessage,
    required this.onRequestPermission,
  });

  final String errorMessage;
  final VoidCallback onRequestPermission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionStatus = ref.watch(locationPermissionProvider(context));

    void handlePermissionRequest() async {
      final permissionNotifier =
          ref.read(locationPermissionProvider(context).notifier);
      final result = await permissionNotifier.requestPermission();
      if (result) {
        onRequestPermission();
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.location_on,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'আপনার লোকেশন এর অনুমতি প্রয়োজন',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (permissionStatus == LocationPermissionStatus.deniedForever)
              FilledButton.icon(
                onPressed: () async {
                  await ref
                      .read(locationPermissionProvider(context).notifier)
                      .openLocationSettings();
                },
                icon: const Icon(Icons.settings),
                label: const Text('সেটিং খুলুন'),
              )
            else
              FilledButton.icon(
                onPressed: handlePermissionRequest,
                icon: const Icon(Icons.location_searching),
                label: const Text('লোকেশন এক্সেস দিন'),
              ),
            const Spacer(),
            const _PermissionInstructions(),
          ],
        ),
      ),
    );
  }
}

class _PermissionInstructions extends StatelessWidget {
  const _PermissionInstructions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'আমাদের কেন অবস্থান অ্যাক্সেস প্রয়োজন:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          _buildInstruction(
            context,
            'সঠিক আবহাওয়া',
            'আপনার নির্দিষ্ট অবস্থানের জন্য রিয়েল-টাইম আবহাওয়ার আপডেট দিতে',
            Icons.wb_sunny,
          ),
          const SizedBox(height: 8),
          _buildInstruction(
            context,
            'স্থানীয় পূর্বাভাস',
            'আপনার এলাকার সঠিক আবহাওয়ার পূর্বাভাস দেখানোর জন্য',
            Icons.calendar_today,
          ),
          const SizedBox(height: 8),
          _buildInstruction(
            context,
            'আবহাওয়া সতর্কতা',
            'আপনার অবস্থানের গুরুত্বপূর্ণ আবহাওয়ার পরিবর্তনের বিষয়ে আপনাকে জানাতে',
            Icons.notifications_active,
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
