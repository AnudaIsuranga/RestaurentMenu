import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Menu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 18),
        ),
      ),
      home: const MyHomePage(title: 'Restaurant Menu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> categories = ['Appetizers', 'Main Course', 'Desserts', 'Drinks'];
  final List<Map<String, dynamic>> foodItems = [
    {'image': 'assets/burger.png', 'name': 'Burger', 'price': 1500.0, 'rating': 4.5},
    {'image': 'assets/pizza.png', 'name': 'Pizza', 'price': 2500.0, 'rating': 4.8},
    {'image': 'assets/rice.png', 'name': 'Rice', 'price': 500.0, 'rating': 5.0},
    {'image': 'assets/ramen.png', 'name': 'Ramen', 'price': 700.0, 'rating': 4.0},
    {'image': 'assets/spaghetti.png', 'name': 'Spaghetti', 'price': 700.0, 'rating': 3.0},
    {'image': 'assets/smoothie.png', 'name': 'Smoothie', 'price': 700.0, 'rating': 5.0},
  ];

  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Category Selector
          CategorySelector(
            categories: categories,
            selectedIndex: selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() {
                selectedCategoryIndex = index;
              });
            },
          ),
          // Food Grid
          Expanded(
            child: FoodGrid(foodItems: foodItems),
          ),
        ],
      ),
    );
  }
}

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.orange,
                ),
              ),
              selected: isSelected,
              selectedColor: Colors.orange,
              backgroundColor: Colors.orange[100],
              onSelected: (_) => onCategorySelected(index),
            ),
          );
        },
      ),
    );
  }
}

class FoodGrid extends StatelessWidget {
  final List<Map<String, dynamic>> foodItems;

  const FoodGrid({super.key, required this.foodItems});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.8,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailPage(food: foodItems[index]),
                ),
              ),
              child: FoodItemCard(
                imageUrl: foodItems[index]['image'],
                name: foodItems[index]['name'],
                price: foodItems[index]['price'],
                rating: foodItems[index]['rating'],
              ),
            );
          },
        );
      },
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double rating;

  const FoodItemCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imageUrl,
              height: 150.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.grey[700]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> food;

  const FoodDetailPage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food['name']),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(food['image'], height: 200.0),
            ),
            const SizedBox(height: 16.0),
            Text(food['name'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text('\$${food['price'].toStringAsFixed(2)}', style: TextStyle(color: Colors.orange[700], fontSize: 20)),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(food['rating'].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}