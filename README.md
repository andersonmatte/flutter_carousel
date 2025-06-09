# flutter_carousel_widget

A customizable and responsive carousel widget for Flutter. Easily display a list of items in a scrollable, paginated view with optional autoplay, navigation arrows, and responsive item counts.

![Flutter Version](https://img.shields.io/badge/flutter-%E2%89%A53.0.0-blue)
![Pub Version](https://img.shields.io/pub/v/flutter_carousel_widget.svg)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_carousel_widget: ^1.0.0

```

## 🚀 How to Use

Import in your Dart code:

```
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_carousel_widget/src/responsive_option.dart';
```

## 💡 Features

- ✅ Horizontal or vertical scrolling
- ✅ Custom number of visible items per page
- ✅ Autoplay support
- ✅ Infinite circular scrolling
- ✅ Responsive layout via breakpoints
- ✅ Pagination indicators and navigation arrows
- ✅ Generic type support for flexible item rendering

✅ Responsive Behavior

You can define how many items should be visible per screen width using ResponsiveOption:


```dart
responsiveOptions: [
  ResponsiveOption(maxWidth: 480, numVisible: 1),
  ResponsiveOption(maxWidth: 800, numVisible: 2),
  ResponsiveOption(maxWidth: double.infinity, numVisible: 3),
],
```
## ✨Demos

<img src="https://raw.githubusercontent.com/andersonmatte/flutter_carousel_widget/refs/heads/master/assets/fcarousel.png" width="500" height="844" alt="Flutter Icon Field Showcase" />

✅ Example

```dart
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
      child: FlutterCarouselWidget<Product>(
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
                        color: product.inventoryStatus == 'In Stock'
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
                            backgroundColor: isInCart
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
```

## 🤝 Contributing

Contributions are welcome! Open an issue or submit a pull request:
https://github.com/andersonmatte/flutter_carousel_widget

## 👨‍💻 Author

Anderson Matte
[GitHub](https://github.com/andersonmatte/) | [LinkedIn](https://www.linkedin.com/in/andersonmatte/)

## 📝 License

This project is licensed under the MIT License. See the LICENSE file for more details.
