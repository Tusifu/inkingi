import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/product.dart';
import 'package:inkingi/providers/product_provider.dart';
import 'package:inkingi/providers/category_provider.dart';
import 'package:inkingi/screens/category/add_category_screen.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatelessWidget {
  static const String routeName = '/addProduct';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  AddProductScreen({super.key});

  void _showAddProductModal(BuildContext context,
      ProductProvider productProvider, CategoryProvider categoryProvider,
      {Product? productToEdit}) {
    _nameController.text = productToEdit?.name ?? '';
    _priceController.text = productToEdit?.price.toString() ?? '';
    _categoryController.text = productToEdit?.category ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                style: GoogleFonts.outfit(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Izina ry\'igicuruzwa (Urugero: Ishati)',
                  hintStyle: GoogleFonts.outfit(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.greyColor500,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.greyColor500,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.greyColor300,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.outfit(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Igiciro (Urugero: 5000)',
                  hintStyle: GoogleFonts.outfit(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.greyColor500,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.greyColor500,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.greyColor300,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  print(
                      'Categories available: ${categoryProvider.categories.length}'); // Debug output
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _categoryController.text.isNotEmpty &&
                                  categoryProvider.categories.any(
                                      (c) => c.name == _categoryController.text)
                              ? _categoryController.text
                              : null,
                          isExpanded: true,
                          style: GoogleFonts.outfit(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Hitamo Ikiciro',
                            hintStyle:
                                GoogleFonts.outfit(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor500,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor500,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor300,
                                width: 2,
                              ),
                            ),
                          ),
                          dropdownColor: Colors.grey[850],
                          onChanged: (value) {
                            if (value != null) {
                              _categoryController.text = value;
                              print(
                                  'Selected category: $value'); // Debug output
                            }
                          },
                          items: categoryProvider.categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Row(
                                children: [
                                  Icon(category.icon, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(category.name,
                                      style: GoogleFonts.outfit(
                                          color: Colors.white)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AddCategoryScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColorBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final priceText = _priceController.text.trim();
                    final category = _categoryController.text;

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Injiza izina ry\'igicuruzwa'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    double price;
                    try {
                      price = double.parse(priceText);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Injiza igiciro rishoboka'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Igiciro kigomba kuba kirenze 0'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (productToEdit == null) {
                      await productProvider.addProduct(name, price, category);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Igicuruzwa cyongewemo neza'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      final updatedProduct = Product(
                        id: productToEdit.id,
                        name: name,
                        price: price,
                        category: category,
                      );
                      await productProvider.updateProduct(updatedProduct);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('amakuru yahinduwe neza'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }

                    _nameController.clear();
                    _priceController.clear();
                    _categoryController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColorBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    productToEdit == null
                        ? 'Ongera igicuruzwa'
                        : 'Hindura igicuruzwa',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        // bottomNavigationBar: TBottomNavBar(currentSelected: 2),
        appBar: CustomAppBar(title: 'Ibicuruzwa (Products)'),
        body: Consumer2<ProductProvider, CategoryProvider>(
          builder: (context, productProvider, categoryProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _showAddProductModal(
                        context, productProvider, categoryProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColorBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Ongera ibicuruzwa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.products[index];
                        return ListTile(
                          title: Text(product.name,
                              style: GoogleFonts.outfit(color: Colors.white)),
                          subtitle: Text(
                              'Igiciro: ${product.price} RWF, Ikiciro: ${product.category}',
                              style: GoogleFonts.outfit(color: Colors.white70)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showAddProductModal(
                                    context, productProvider, categoryProvider,
                                    productToEdit: product),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await productProvider
                                      .deleteProduct(product.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
