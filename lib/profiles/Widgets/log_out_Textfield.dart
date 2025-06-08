import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_cubit.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_states.dart';
import 'package:innovahub_app/Auth/login/login_screen.dart';
import 'package:innovahub_app/Auth/register/register_screen.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class LogoutTextField extends StatelessWidget {
  const LogoutTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is DeleteAccountSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account deleted successfully")),
            );
            Navigator.pushNamed(context, RegisterScreen.routeName);
          } else if (state is DeleteAccountErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              decoration: BoxDecoration(
                color: Constant.mainColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                onTap: () async {
                  final password = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      String input = '';
                      return AlertDialog(
                        title: const Text('Confirm Password'),
                        content: TextField(
                          obscureText: true,
                          onChanged: (value) => input = value,
                          decoration: const InputDecoration(
                              hintText: 'Enter your password'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, input),
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );

                  if (password != null && password.isNotEmpty) {
                    context.read<AuthCubit>().deleteAccount(password);
                  }
                },
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login_outlined, color: Constant.whiteColor),
                    SizedBox(width: 8),
                    Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 16,
                        color: Constant.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
