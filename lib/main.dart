import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_list/products_data.dart';
import 'package:product_list/widgets/dynamic_app_bar.dart';
import 'package:product_list/widgets/product_item.dart';
import 'data_structures/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blueAccent,
        statusBarColor: Colors.blueAccent,
      ),
    );

    return MaterialApp(
      title: 'Product List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> _products = [];

  /// Полезная вещь, но в этой ситуации она не понадобилась.
  ScrollController _scrollController;

  @override
  void didChangeDependencies() {
    setState(() {
      _products = FAKE_PRODUCTS;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Мне не нравится, когда приложение залезает на системный статус-бар,
      // Поэтому предпочитаю использовать SafeArea.
      body: SafeArea(
        child: CustomScrollView(
          // Интересный эффект, но не в нашем случае
          // physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          slivers: [
            DynamicSliverAppBar(
              title: 'Product List',
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                // Align, чтобы элементы не растягивались
                (context, i) => Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ProductItem(
                      description: _products[i].description,
                      units: _products[i].units,
                      width: 100,
                      maxLines: 2,
                    ),
                  ),
                ),
                childCount: _products.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
