import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/category.dart';
import 'package:inkingi/providers/category_provider.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatelessWidget {
  static const String routeName = '/addCategory';
  final TextEditingController _nameController = TextEditingController();
  final List<IconData> _availableIcons = [
    Icons.store,
    Icons.money,
    Icons.attach_money,
    Icons.share,
    Icons.percent,
    Icons.star,
    Icons.handshake,
    Icons.card_giftcard,
    Icons.arrow_upward,
    Icons.inventory,
    Icons.build,
    Icons.home,
    Icons.work,
    Icons.local_atm,
    Icons.shield,
    Icons.gavel,
    Icons.campaign,
    Icons.school,
    Icons.arrow_downward,
  ];

  AddCategoryScreen({super.key});

  void _showAddCategoryModal(BuildContext context, CategoryProvider provider,
      {Category? categoryToEdit}) {
    _nameController.text = categoryToEdit?.name ?? '';

    final defaultIcon = _availableIcons.first;

    IconData? initialIcon;
    if (categoryToEdit?.icon != null &&
        _availableIcons
            .any((icon) => icon.codePoint == categoryToEdit!.icon.codePoint)) {
      initialIcon = categoryToEdit!.icon;
    } else {
      initialIcon = defaultIcon;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            IconData? selectedIcon = initialIcon;

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
                      hintText: 'Izina ry\'ikiciro (Urugero: Ishati)',
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
                  DropdownButtonFormField<IconData>(
                    value: _availableIcons.contains(selectedIcon)
                        ? selectedIcon
                        : defaultIcon,
                    isExpanded: true,
                    style: GoogleFonts.outfit(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Hitamo Icon',
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
                    dropdownColor: Colors.grey[850],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedIcon = value;
                        });
                      }
                    },
                    items: _availableIcons.map((icon) {
                      return DropdownMenuItem<IconData>(
                        value: icon,
                        child: Row(
                          children: [
                            Icon(icon, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(icon.toString().split('.').last,
                                style: GoogleFonts.outfit(color: Colors.white)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = _nameController.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Injiza izina ry\'ikiciro'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        final iconToSave = selectedIcon ?? defaultIcon;
                        if (categoryToEdit == null) {
                          await provider.addCategory(name, iconToSave);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ikiciro cyongewemo neza'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Handle edit if needed
                        }
                        _nameController.clear();
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
                      child: const Text(
                        'Ongera Ikiciro',
                        style: TextStyle(
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        // bottomNavigationBar: TBottomNavBar(currentSelected: 2),
        appBar: CustomAppBar(title: 'Ikiciro (Category)'),
        body: Consumer<CategoryProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _showAddCategoryModal(context, provider),
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
                          'Ongera Ikiciro',
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
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        return ListTile(
                          title: Text(category.name,
                              style: GoogleFonts.outfit(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(category.icon, color: Colors.white),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await provider.deleteCategory(category.id);
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
