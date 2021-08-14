
import 'package:flutter/material.dart';
import 'package:formularios_app/providers/login_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:formularios_app/ui/input_decoration.dart';
import 'package:formularios_app/widgets/widgets.dart';


class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 250,),

              CardContainer(
                child: Column(
                  children: [

                    SizedBox(height: 10,),

                    Text('Login', style: Theme.of(context).textTheme.headline4,),

                    SizedBox(height: 30,),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                   // _LoginForm(),
                  ],
                )
              ),

              SizedBox(height: 50,),

              Text('Crear nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

              SizedBox(height: 50,),
            ],
          ),
        )
      ),
   );
  }
}


class _LoginForm extends StatelessWidget {
  const _LoginForm({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(

        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          //lista de widgets de formularios
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'ejemplo@gmail.com',
                labelText: 'E-mail',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              onChanged: (value) => loginForm.email = value,
              validator:(value) {

                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                  ? null
                  : 'No es un correo valido';
              }
            ),

            SizedBox(height: 30),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value){
                return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe contener almenos 6 caracteres';
              },
            ),

            SizedBox(height: 30),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text( loginForm.isLoading ? 'Espere...' :'Ingresar', 
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: loginForm.isLoading ? null : () async {

                FocusScope.of(context).unfocus();

                if( !loginForm.isValidForm() ) return;

                loginForm.isLoading = true;

                await Future.delayed(Duration(seconds: 2));

                loginForm.isLoading = false;

                Navigator.pushReplacementNamed(context, 'home'); 
              
              }
            ),

          ],
        )
      ),
    );
  }
}