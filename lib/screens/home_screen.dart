
import 'package:flutter/material.dart';
import 'package:formularios_app/models/models.dart';
import 'package:formularios_app/screens/screen.dart';
import 'package:formularios_app/services/services.dart';
import 'package:formularios_app/widgets/widgets.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if(productsService.isloading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Productos'),
        actions: [IconButton(
          icon: Icon(Icons.login_outlined),
          onPressed: (){
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),]
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () =>{
            productsService.selectedProduct = productsService.products[index].copy(),
            Navigator.pushNamed(context, 'product'),
          }, 
          child: ProductCard(product:productsService.products[index] ,),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          productsService.selectedProduct = Product(
            available: false, 
            price: 0,
            name: '',
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
   );
  }
}