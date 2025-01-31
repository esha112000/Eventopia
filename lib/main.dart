import 'package:eventopia_app/controller/providers/favorites_provider.dart';
import 'package:eventopia_app/controller/providers/filter_provider.dart';
import 'package:eventopia_app/firebase_options.dart';
import 'package:eventopia_app/services/session_manager.dart';
import 'package:eventopia_app/view/dashboard/home_page.dart';
import 'package:eventopia_app/view/events/favourites_event_page.dart';
import 'package:eventopia_app/view/events/my_bookings_page.dart';
import 'package:eventopia_app/view/landing_page.dart';
import 'package:eventopia_app/view/auth/auth_view.dart';
import 'package:eventopia_app/view/profile/contact.dart';
import 'package:eventopia_app/view/profile/faq.dart';
import 'package:eventopia_app/view/profile/help_and_support.dart';
import 'package:eventopia_app/view/splash_screen.dart'; // ✅ Import SplashScreen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // ✅ Load environment variables
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize SessionManager and validate token
  final sessionManager = SessionManager();
  final isTokenValid = await sessionManager.validateToken();
  
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? ''; // Securely fetch key from .env

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        ChangeNotifierProvider<FilterProvider>(
          create: (context) => FilterProvider(),
        ),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (context) => FavoritesProvider(),
        ),
        Provider<SessionManager>.value(
          value: sessionManager, // Provide the session manager
        ),
      ],
      child: MyApp(isTokenValid: isTokenValid),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isTokenValid;

  const MyApp({Key? key, required this.isTokenValid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Save the token using SessionManager
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            user.getIdToken().then((token) {
              context.read<SessionManager>().saveToken(token!);
            });
          }

          // Navigate to HomePage when authenticated
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthUnauthenticated) {
          // Clear the token when unauthenticated
          context.read<SessionManager>().clearToken();

          // Navigate to AuthPage
          Navigator.pushReplacementNamed(context, '/auth');
        } else if (state is AuthError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash', // ✅ Start with SplashScreen
        routes: {
          '/splash': (context) => const SplashScreen(), // ✅ Add SplashScreen
          '/landing': (context) => const LandingPage(),
          '/auth': (context) => const AuthPage(),
          '/home': (context) => const HomePage(),
          '/myBookings': (context) => const MyBookingsPage(),
          '/myFavourites': (context) => const FavoriteEventsPage(),
          '/helpAndSupport': (context) => const HelpAndSupportPage(),
          '/faq': (context) => const FAQPage(),
          '/contactSupport': (context) => const ContactSupportPage(),
        },
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
    );
  }
}
