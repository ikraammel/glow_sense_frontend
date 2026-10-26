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
import 'data/services/backend_wakeup_service.dart';
import 'data/services/local_storage_service.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/onboarding/welcome_screen.dart';
import 'widgets/backend_startup_gate.dart';

final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GlowSenseBootstrap());
}

class GlowSenseBootstrap extends StatefulWidget {
  const GlowSenseBootstrap({super.key});

  @override
  State<GlowSenseBootstrap> createState() => _GlowSenseBootstrapState();
}

class _GlowSenseBootstrapState extends State<GlowSenseBootstrap> {
  final _wakeUpService = BackendWakeUpService();
  late final Future<GlowSenseDependencies> _dependencies;

  @override
  void initState() {
    super.initState();
    _dependencies = SharedPreferences.getInstance().then((prefs) {
      final storage = LocalStorageService(prefs: prefs);
      return GlowSenseDependencies(api: ApiService(storage), storage: storage);
    });
  }

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'GlowSense',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
    ),
    home: BackendStartupGate(
      service: _wakeUpService,
      builder: (context) => FutureBuilder<GlowSenseDependencies>(
        future: _dependencies,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("Unable to initialize the application."),
              ),
            );
          }

          final dependencies = snapshot.data;

          if (dependencies == null) {
            return const _LocalStorageLoading();
          }

          return GlowSenseApp(
            api: dependencies.api,
            storage: dependencies.storage,
          );
        },
      ),
    ),
  );
}
}

class GlowSenseDependencies {
  const GlowSenseDependencies({required this.api, required this.storage});

  final ApiService api;
  final LocalStorageService storage;
}

class _LocalStorageLoading extends StatelessWidget {
  const _LocalStorageLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primaryPink),
      ),
    );
  }
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
          BlocProvider(
              create: (_) => AuthBloc(api: api, storage: storage)
                ..add(const CheckAuthStatus())),
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
                    Text("Préparation de votre univers...",
                        style: TextStyle(color: AppColors.textGrey)),
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
              Navigator.of(ctx)
                  .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          );
        },
      ),
    );
  }
}
