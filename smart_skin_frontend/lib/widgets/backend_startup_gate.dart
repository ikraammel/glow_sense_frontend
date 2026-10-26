import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../data/services/backend_wakeup_service.dart';

class BackendStartupGate extends StatefulWidget {
  const BackendStartupGate({
    super.key,
    required this.service,
    required this.builder,
  });

  final BackendWakeUpService service;
  final WidgetBuilder builder;

  @override
  State<BackendStartupGate> createState() => _BackendStartupGateState();
}

class _BackendStartupGateState extends State<BackendStartupGate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Future<bool> _wakeUp;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _wakeUp = widget.service.wakeUp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() => _wakeUp = widget.service.wakeUp());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _wakeUp,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _StartupMessage(
            animation: _animationController,
            title: 'GlowSense is getting ready...',
            description:
            "We're getting everything ready for you. "
                "This may take a few moments.",
            status: "Initializing services...",
          );
        }
        if (snapshot.data != true) {
          return _StartupMessage(
            animation: _animationController,
            title: 'GlowSense is taking a little longer',
            description:
                'We could not connect just yet. Please try again in a moment.',
            action: FilledButton(
              onPressed: _retry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.deepPink,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              child: const Text('Try Again'),
            ),
          );
        }
        return widget.builder(context);
      },
    );
  }
}

class _StartupMessage extends StatelessWidget {
  const _StartupMessage({
    required this.animation,
    required this.title,
    required this.description,
    this.status,
    this.action,
  });

  final Animation<double> animation;
  final String title;
  final String description;
  final String? status;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) => Transform.scale(
                      scale: 0.96 + animation.value * 0.06,
                      child: child,
                    ),
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withValues(alpha: .28),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textGrey,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (status != null) ...[
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.deepPink,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      status!,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.deepPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else
                    action!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
