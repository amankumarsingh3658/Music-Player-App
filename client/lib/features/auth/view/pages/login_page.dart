import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view%20model/auth_viewmodel.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewmodelProvider.select((val)=> val?.isLoading == true));

    ref.listen(authViewmodelProvider, (_, current) {
      current?.when(
          data: (data) {
            showSnackBar(context, "Login Successful");
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => const HomePage()), (_)=> false);
          },
          error: (error, stackTrace) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign In.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomField(
                      controller: emailController,
                      hintText: "Email",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomField(
                      isObsecure: true,
                      controller: passwordController,
                      hintText: "Password",
                    ),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      onTap: () async {
                        if(formKey.currentState!.validate()){
                          ref.read(authViewmodelProvider.notifier).loginUser(
                            email: emailController.text,
                            password: passwordController.text);
                        }
                      },
                      buttonText: "Sign In",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage())),
                      child: RichText(
                          text: TextSpan(
                              text: "Don't Have An Account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: const [
                            TextSpan(
                                text: "Sign Up",
                                style: TextStyle(color: Pallete.gradient2)),
                          ])),
                    )
                  ],
                ),
              ),
            ),
    );    
  }
}
