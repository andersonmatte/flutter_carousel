import 'package:flutter/material.dart';
import 'package:flutter_carousel/src/flutter_carousel.dart';
import 'package:flutter_carousel/src/responsive_option.dart';
import 'product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Carousel',
      debugShowCheckedModeBanner: false,
      home: DemoCarouselPage(),
    );
  }
}

class DemoCarouselPage extends StatefulWidget {
  const DemoCarouselPage({super.key});

  @override
  State<DemoCarouselPage> createState() => _DemoCarouselPageState();
}

class _DemoCarouselPageState extends State<DemoCarouselPage> {
  final List<Product> products = [
    Product(
      image: 'assets/red.png',
      name: 'Adidas Response Runner Shoes - Red',
      price: 65,
      inventoryStatus: 'In Stock',
    ),
    Product(
      image: 'assets/yellow.png',
      name: 'Adidas Response Runner Shoes - Yellow',
      price: 72,
      inventoryStatus: 'In Stock',
    ),
    Product(
      image: 'assets/pink.png',
      name: 'Adidas Response Runner Shoes - Pink',
      price: 79,
      inventoryStatus: 'Low Stock',
    ),
    Product(
      image: 'assets/black.png',
      name: 'Adidas Response Runner Shoes - Black',
      price: 29,
      inventoryStatus: 'In Stock',
    ),
    Product(
      image: 'assets/white.png',
      name: 'Adidas Response Runner Shoes - White',
      price: 65,
      inventoryStatus: 'In Stock',
    ),
    Product(
      image: 'assets/grey.png',
      name: 'Adidas Response Runner Shoes - Grey',
      price: 72,
      inventoryStatus: 'In Stock',
    ),
  ];

  final Set<String> cartItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Carousel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FlutterCarousel<Product>(
          items: products,
          numVisible: 2,
          numScroll: 2,
          circular: false,
          autoplayInterval: const Duration(seconds: 3),
          responsiveOptions: [
            ResponsiveOption(1024, 2, 2),
            ResponsiveOption(768, 2, 2),
            ResponsiveOption(560, 1, 1),
            ResponsiveOption(390, 2, 1),
          ],
          showPaginator: true,
          itemBuilder: (context, product) {
            final bool isInCart = cartItems.contains(product.name);

            return Card(
              color: Colors.white,
              margin: const EdgeInsets.all(8.0),
              shadowColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  // Evita overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        product.image,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('\$${product.price.toStringAsFixed(2)}'),
                      const SizedBox(height: 4),
                      Text(
                        product.inventoryStatus,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              product.inventoryStatus == 'In Stock'
                                  ? Colors.green
                                  : product.inventoryStatus == 'Low Stock'
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              isInCart
                                  ? Icons.remove_shopping_cart
                                  : Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            label: Text(
                              isInCart ? 'Remove' : 'Add to Cart',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isInCart
                                      ? Colors.redAccent
                                      : Colors.blueAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isInCart) {
                                  cartItems.remove(product.name);
                                } else {
                                  cartItems.add(product.name);
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isInCart
                                        ? '${product.name} removed from cart.'
                                        : '${product.name} Add to Cart.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.payment,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Buy',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Buying ${product.name}...'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
