import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/dashboard/dashboard_bloc.dart';
import 'bloc/analysis/analysis_bloc.dart';
import 'bloc/coach/coach_bloc.dart';
import 'bloc/notification/notification_bloc.dart';
import 'constants/colors.dart';
import 'data/services/api_service.dart';
import 'data/services/local_storage_service.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/onboarding/welcome_screen.dart';

final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorageService(prefs: prefs);
  final api = ApiService(storage);
  runApp(GlowSenseApp(api: api, storage: storage));
}

class GlowSenseApp extends StatelessWidget {
  final ApiService api;
  final LocalStorageService storage;

  const GlowSenseApp({super.key, required this.api, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiService>.value(value: api),
        RepositoryProvider<LocalStorageService>.value(value: storage),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(api: api, storage: storage)..add(const CheckAuthStatus())),
          BlocProvider(create: (_) => DashboardBloc(api: api)),
          BlocProvider(create: (_) => AnalysisBloc(api: api)),
          BlocProvider(create: (_) => CoachBloc(api: api)),
          BlocProvider(create: (_) => NotificationBloc(api: api)),
        ],
        child: MaterialApp(
          title: 'GlowSense',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: messengerKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPink),
            useMaterial3: true,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: AppColors.backgroundLight,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textDark,
              elevation: 0,
            ),
          ),
          home: const _AppRouter(),
        ),
      ),
    );
  }
}

class _AppRouter extends StatelessWidget {
  const _AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // Force le retour à l'écran de base lors de la déconnexion
      listenWhen: (prev, curr) => curr is AuthUnauthenticated,
      listener: (context, state) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (ctx, state) {
          // 1. CHARGEMENT / INITIALISATION
          if (state is AuthInitial || state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryPink),
                    SizedBox(height: 16),
                    Text("Préparation de votre univers...", style: TextStyle(color: AppColors.textGrey)),
                  ],
                ),
              ),
            );
          }

          // 2. UTILISATEUR CONNECTÉ
          if (state is AuthAuthenticated) {
            if (state.needsOnboarding) return const OnboardingFlow();
            return const HomeScreen();
          }

          // 3. PAR DÉFAUT : BIENVENUE
          return WelcomeScreen(
            onFinished: () {
              Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          );
        },
      ),
    );
  }
}
