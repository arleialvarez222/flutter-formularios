
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formularios_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-varios-2de30-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  late Product selectedProduct;

  final storage =  FlutterSecureStorage();

  File? newPictureFile;

  bool isloading = true;
  bool isSaving = false;

  ProductsService(){
    this.loadProducts();
  }

  Future<List<Product>> loadProducts()async{

    this.isloading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });

    this.isloading = false;
    notifyListeners();

    return this.products;

  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if(product.id == null){
      await this.createProduct(product);
    }else{
      this.updateProduct(product);
    }


    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {

    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.put(url, body: product.toJson(),);
    final decodeData = resp.body;

    //actualizar el lstado de productos
    final index = this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;

    return product.id!;

  }

  Future<String> createProduct(Product product) async {

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.post(url, body: product.toJson());
    final decodeData = json.decode(resp.body);

    product.id = decodeData['name'];

    //actualiza la lista de productos
    this.products.add(product);

    return product.id!;

  }

  void updateSelectedProductImage(String path){

    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();

  }

  Future<String?> uploadImage()async{

    if(this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/deliveryarlei/image/upload?upload_preset=wzjpvzb6');

    final imageUpLoadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUpLoadRequest.files.add(file);

    final streamResponse = await imageUpLoadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;

    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];
    
  }

}