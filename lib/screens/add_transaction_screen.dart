import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/product.dart';
import 'package:inkingi/providers/add_transaction_provider.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/providers/product_provider.dart';
import 'package:inkingi/screens/dashboard_screen.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatelessWidget {
  static const String routeName = '/addTransaction';
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddTransactionProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Builder(
        builder: (context) {
          final transactionProvider =
              Provider.of<AddTransactionProvider>(context, listen: false);
          final productProvider =
              Provider.of<ProductProvider>(context, listen: false);

          // Initialize category and amount based on selected product when it changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (transactionProvider.selectedProduct != null) {
              // Map the product's category to the full text value
              final productCategory =
                  transactionProvider.selectedProduct!.category;
              final mappedCategory = _mapCategoryToFullText(productCategory);
              if (transactionProvider.selectedCategory != mappedCategory) {
                transactionProvider.setCategory(mappedCategory);
              }
              if (transactionProvider.quantity != 1) {
                transactionProvider.setQuantity(1);
                transactionProvider.updateAmountBasedOnQuantity();
              }
            }
          });

          return Scaffold(
            backgroundColor: AppColors.background,
            bottomNavigationBar: TBottomNavBar(currentSelected: 2),
            appBar: CustomAppBar(title: 'Andika Ibikorwa'),
            body: Consumer2<AddTransactionProvider, ProductProvider>(
              builder: (context, transactionProvider, productProvider, child) {
                final dashboardProvider =
                    Provider.of<DashboardProvider>(context, listen: false);

                final List<DropdownMenuItem<String>> categoryItems = [
                  const DropdownMenuItem(
                      value: 'Kugurisha', child: Text('Kugurisha 🏷️')),
                  const DropdownMenuItem(
                      value: 'Umushahara', child: Text('Umushahara 💸')),
                  const DropdownMenuItem(
                      value: 'Kodesha Yinjiye', child: Text('Kodesha Yinjiye')),
                  const DropdownMenuItem(
                      value: 'Umugabane', child: Text('Umugabane ꗈ')),
                  const DropdownMenuItem(
                      value: 'Intere', child: Text('Intere %')),
                  const DropdownMenuItem(
                      value: 'Royalty', child: Text('Royalty')),
                  const DropdownMenuItem(
                      value: 'Komisiyo', child: Text('Komisiyo')),
                  const DropdownMenuItem(
                      value: 'Bonuse', child: Text('Bonuse')),
                  const DropdownMenuItem(
                      value: 'Amafaranga Yinjiye',
                      child: Text('Amafaranga Yinjiye 📥')),
                  const DropdownMenuItem(
                      value: 'Ibicuruzwa', child: Text('Ibicuruzwa 📦')),
                  const DropdownMenuItem(
                      value: 'Ibikoresho', child: Text('Ibikoresho 🧱')),
                  const DropdownMenuItem(
                      value: 'Kukodesha', child: Text('Kukodesha')),
                  const DropdownMenuItem(
                      value: 'Umushahara Wabakozi',
                      child: Text('Umushahara Wabakozi')),
                  const DropdownMenuItem(
                      value: 'Inguzanyo', child: Text('Inguzanyo')),
                  const DropdownMenuItem(
                      value: 'Ubwishingizi', child: Text('Ubwishingizi')),
                  const DropdownMenuItem(
                      value: 'Umutego', child: Text('Umutego')),
                  const DropdownMenuItem(value: 'Fine', child: Text('Fine')),
                  const DropdownMenuItem(
                      value: 'Kwamamaza', child: Text('Kwamamaza')),
                  const DropdownMenuItem(
                      value: 'Amasomo', child: Text('Amasomo')),
                  const DropdownMenuItem(
                      value: 'Amafaranga Yasohotse',
                      child: Text('Amafaranga Yasohotse 📤')),
                ];

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        title: const Text(
                          'Shyiramo Umubare na Ibisobanuro Byihariye',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: transactionProvider.useManualEntry,
                        onChanged: (value) {
                          transactionProvider.setUseManualEntry(value);
                        },
                        activeColor: AppColors.primaryColorBlue,
                        activeTrackColor:
                            const Color.fromARGB(255, 91, 104, 119)
                                .withOpacity(0.5),
                        inactiveThumbColor: AppColors.textSecondary,
                        inactiveTrackColor:
                            AppColors.textSecondary.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      if (transactionProvider.useManualEntry) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/addProduct');
                            },
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
                                  'Ongera Igicuruzwa',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<Product>(
                          value: transactionProvider.selectedProduct,
                          isExpanded: true,
                          style: GoogleFonts.outfit(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Hitamo Igicuruzwa',
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
                              transactionProvider.setSelectedProduct(value);
                            }
                          },
                          items: productProvider.products.map((product) {
                            return DropdownMenuItem<Product>(
                              value: product,
                              child: Text(
                                '${product.name}',
                                style: GoogleFonts.outfit(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                    transactionProvider.amountController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.outfit(color: Colors.white),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintText:
                                      'Umubare (${transactionProvider.amountController.text.isEmpty ? (transactionProvider.selectedProduct?.price ?? 0) : int.parse(transactionProvider.amountController.text).toString()} RWF)',
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
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.greyColor500, width: 1.5),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: AppColors.greyColor300),
                                    onPressed: transactionProvider.quantity > 1
                                        ? () {
                                            transactionProvider.setQuantity(
                                                transactionProvider.quantity -
                                                    1);
                                          }
                                        : null,
                                    color: transactionProvider.quantity > 1
                                        ? AppColors.primaryColorBlue
                                        : AppColors.greyColor500,
                                  ),
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      transactionProvider.quantity.toString(),
                                      style: GoogleFonts.outfit(
                                          color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: AppColors.primaryColorBlue),
                                    onPressed: () {
                                      transactionProvider.setQuantity(
                                          transactionProvider.quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: transactionProvider.dateController,
                          readOnly: true,
                          style: GoogleFonts.outfit(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: 'Italiki',
                            hintStyle:
                                GoogleFonts.outfit(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.grey[900],
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
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            transactionProvider
                                .setSelectedDate(pickedDate ?? DateTime.now());
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      TextField(
                        controller: transactionProvider.descriptionController,
                        maxLines: 5,
                        minLines: 3,
                        style: GoogleFonts.outfit(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: transactionProvider.useManualEntry
                              ? 'Ibisobanuro (Urugero: Imyenda Yaguzwe)'
                              : 'Ibisobanuro (Urugero: Naguze imyenda 5000 amafaranga)',
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
                      if (transactionProvider.useManualEntry)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: transactionProvider.isIncome
                                      ? LinearGradient(
                                          colors: [
                                            const Color.fromARGB(
                                                255, 40, 100, 86),
                                            const Color.fromARGB(
                                                255, 36, 77, 70),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : LinearGradient(
                                          colors: [
                                            Colors.grey[900]!.withOpacity(0.2),
                                            Colors.grey[900]!.withOpacity(0.2),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: !transactionProvider.isIncome
                                      ? Border.all(
                                          color: AppColors.greyColor500,
                                          width: 1.0)
                                      : null,
                                ),
                                child: ElevatedButton(
                                  onPressed: () => transactionProvider
                                      .setTransactionType(true),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation:
                                        transactionProvider.isIncome ? 5 : 0,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Yinjiye',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: !transactionProvider.isIncome
                                      ? LinearGradient(
                                          colors: [
                                            const Color.fromARGB(
                                                255, 96, 38, 38),
                                            const Color.fromARGB(
                                                255, 85, 41, 41),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : LinearGradient(
                                          colors: [
                                            Colors.grey[900]!.withOpacity(0.2),
                                            Colors.grey[900]!.withOpacity(0.2),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: transactionProvider.isIncome
                                      ? Border.all(
                                          color: AppColors.greyColor500,
                                          width: 1.0)
                                      : null,
                                ),
                                child: ElevatedButton(
                                  onPressed: () => transactionProvider
                                      .setTransactionType(false),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation:
                                        !transactionProvider.isIncome ? 5 : 0,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Yasohotse',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      if (transactionProvider.useManualEntry)
                        DropdownButtonFormField<String>(
                          value: transactionProvider.selectedCategory,
                          isExpanded: true,
                          style: GoogleFonts.outfit(color: Colors.white),
                          decoration: InputDecoration(
                            hintText:
                                'Ikiciro (Default: ${transactionProvider.selectedProduct?.category ?? 'None'})',
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
                              transactionProvider.setCategory(value);
                            }
                          },
                          items: categoryItems,
                        ),
                      if (transactionProvider.useManualEntry)
                        const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            transactionProvider.addTransaction(context);
                            if (dashboardProvider.error == null) {
                              Navigator.push(
                                context,
                                AppTransitions.fadeNamed(
                                  DashboardScreen.routeName,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColorBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Bika Ibikorwa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (dashboardProvider.error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          dashboardProvider.error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Helper function to map old category values to new full text values
  String _mapCategoryToFullText(String category) {
    const categoryMap = {
      'Sales': 'Kugurisha',
      'Salary': 'Umushahara',
      'Rent Income': 'Kodesha Yinjiye',
      'Dividend': 'Umugabane',
      'Interest': 'Intere',
      'Royalty': 'Royalty',
      'Commission': 'Komisiyo',
      'Bonus': 'Bonuse',
      'Income': 'Amafaranga Yinjiye',
      'Inventory': 'Ibicuruzwa',
      'Utilities': 'Ibikoresho',
      'Rent': 'Kukodesha',
      'Payroll': 'Umushahara Wabakozi',
      'Loan': 'Inguzanyo',
      'Insurance': 'Ubwishingizi',
      'Tax': 'Umutego',
      'Fine': 'Fine',
      'Marketing': 'Kwamamaza',
      'Training': 'Amasomo',
      'Expense': 'Amafaranga Yasohotse',
    };
    return categoryMap[category] ??
        category; // Return mapped value or original if not found
  }
}
