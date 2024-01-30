import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class  Product {
    String search_image;
    String stylied;
    String brands_filter_facet;
    String price;
    String product_additional_info;

    Product({
      required this.search_image,
      required this.stylied,
      required this.brands_filter_facet,
      required this.price,
      required this.product_additional_info,
  });
}

// edit activity

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenStage createState() => _ProductListScreenStage();

}

class _ProductListScreenStage extends State<ProductListScreen> {
  late List<Product> products;
  @override
  void initState() {
    super.initState();
    products = [];
    fetchProducts();
  }
  Future<void> fetchProducts() async {
      final response = await http.get(Uri.parse("http://172.19.200.229/aserver/api.php"));
      if(response.statusCode==200)
      {
        final Map<String,dynamic> data=json.decode(response.body);
        setState(() {
          products=convertMapToList(data);
        });
      }else {
        throw Exception('khong load duoc du lieu');
      }
  }
  List<Product> convertMapToList(Map<String, dynamic> data)
  {
    List<Product> productList = [];
    data.forEach((key, value) {
      for(int i=0;i<value.length; i++) {
        Product product = Product(
          search_image: value[i]['search_image'] ?? '',
          stylied: value[i]['stylied'] ?? 0,
          brands_filter_facet: value[i]['brands_filter_facet'] ?? '',
          price: value[i]['price'] ?? 0,
          product_additional_info: value[i]['product_additional_info'] ?? '');
        productList.add(product);
      }
    });
    return productList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('danh sach san pham'),
        ),
        body: products != null ?
            ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(products[index].brands_filter_facet),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ${products[index].price}'),
                        Text('product_additional_info: ${products[index].product_additional_info}'),
                      ],
                    ),
                    leading: Image.network(
                      products[index].search_image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  );
                })
                : Center(
                  child: CircularProgressIndicator(),
            )
        );
      }
    }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Danh sach san pham',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
       ),
      home: ProductListScreen(),
    );
  }
}




