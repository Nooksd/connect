import 'package:connect/custom/splash_screen.dart';
import 'package:connect/features/auth/data/firebase_auth_repo.dart';
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/features/auth/presentation/cubits/auth_states.dart';
import 'package:connect/features/auth/presentation/pages/login_page.dart';
import 'package:connect/features/navigation/presentation/pages/navigator_page.dart';
import 'package:connect/features/profile/data/firebase_profile_repo.dart';
import 'package:connect/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/router/router.dart';
import 'package:connect/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo();

  final profileRepo = FirebaseProfileRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepo: authRepo)),
        BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(profileRepo: profileRepo))
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        title: 'Connect',
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is Unauthenticated) {
              return const LoginPage();
            }
            if (authState is Authenticated) {
              return const NavigatorPage();
            } else {
              return const SplashScreen();
            }
          },
          listener: (context, authState) {
            if (authState is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(authState.error)));
            }
          },
        ),
        theme: lightMode,
        onGenerateRoute: (settings) {
          return generateRoute(settings);
        },
      ),
    );
  }
}
