

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/login_screen/cubit/cubit.dart';
import 'package:social_app/modules/login_screen/cubit/state.dart';
import 'package:social_app/modules/register_screen/register_screen.dart';
import 'package:social_app/shared/compoments/compoments.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {

  var _formKey= GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
        listener: (context,state){
          if(state is SocialLoginErrorState){
            ShowToast(text: state.eror, state: ToastStates.ERROR);
          }
          if(state is SocialLoginSuccessState){
            CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
            ).then((value){
              NavigatAndFinish(context, HomeScreen());
            });
          }
        },
        builder: (context,state){
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style: TextStyle(color: Colors.grey,fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty)
                              return 'Enter Your email Address';
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.8),
                            ),
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value){
                            if(value!.isEmpty)
                              return 'Enter Your Password';
                          },
                          onFieldSubmitted: (value){
                            if(_formKey.currentState!.validate()){
                          SocialLoginCubit.get(context).UserLogin(
                          email: emailController.text,
                          password: passwordController.text,
                          );}
                          },
                          obscureText: SocialLoginCubit.get(context).ispassword,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.8),
                            ),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: (){
                                SocialLoginCubit.get(context).ChangePasswordVisibility();
                              },
                              icon: Icon(SocialLoginCubit.get(context).suffix),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context)=> defaultbutton(
                            function: () {
                              if(_formKey.currentState!.validate()){
                            SocialLoginCubit.get(context).UserLogin(
                            email: emailController.text,
                            password: passwordController.text,
                            );
                            }
                            },
                            text: 'login',
                            isoppercase: true,
                            backgroundcolor:DefaultColor,
                          ),
                          fallback: (context)=> Center(child: CircularProgressIndicator()) ,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            defaultTextButton(
                              function: () {
                                NavigatTo(context, RegisterScreen());
                              },
                              text: 'register'.toUpperCase(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
