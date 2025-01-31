import 'package:eventopia_app/controller/auth_controller.dart';
import 'package:eventopia_app/view/auth/login_view.dart';
import 'package:eventopia_app/view/auth/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: DefaultTabController(
        length: 2, // Two tabs: Login and Signup
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Eventopia',
              style: TextStyle(color: Colors.orange),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.orange),
            bottom: const TabBar(
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Signup'),
              ],
            ),
          ),
          body: Column(
            children: [
              // SVG Image Below Tab Bar
              Padding(
                padding: const EdgeInsets.only(top: 56.0),
                child: SvgPicture.asset(
                  'assets/images/auth_image.svg',
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.6,
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    LoginView(),
                    SignupView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
