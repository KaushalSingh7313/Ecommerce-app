import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ChangeNotifier.dart';

class ProductDetailScreen extends StatelessWidget {
  final Apicall product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? 'Product Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Hero(
              tag: product.image ?? '',
              child: Image.network(
                product.image ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name ?? 'No Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Price: \$${product.price?.toStringAsFixed(2) ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add to Cart functionality
              // You can also add this button to the HomeScreen
              final provider = Provider.of<ProductProvider>(context, listen: false);
              provider.addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart!'),
                ),
              );
            },
            child: const Text('Add to Cart'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
