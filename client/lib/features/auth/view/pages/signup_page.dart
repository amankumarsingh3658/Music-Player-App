import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view%20model/auth_viewmodel.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewmodelProvider.select((val) => val?.isLoading == true));

    ref.listen(authViewmodelProvider, (_, current) {
      current?.when(
          data: (data) {
            showSnackBar(context, "Account Created Successfully! Please Login");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
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
                      "Sign Up.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomField(
                      controller: nameController,
                      hintText: "Name",
                    ),
                    const SizedBox(
                      height: 15,
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
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          ref.read(authViewmodelProvider.notifier).signUpUser(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text);
                        }
                      },
                      buttonText: "Sign Up",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: RichText(
                          text: TextSpan(
                              text: "Already Have An Account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: const [
                            TextSpan(
                                text: "Sign In",
                                style: TextStyle(color: Pallete.gradient2))
                          ])),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
