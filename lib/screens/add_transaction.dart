// lib/screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/add_transaction_provider.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatelessWidget {
  static const String routeName = '/addTransaction';
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddTransactionProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: TBottomNavBar(
          currentSelected: 2,
        ),
        appBar: CustomAppBar(
          title: 'Andika Ibikorwa',
        ),
        body: Consumer<AddTransactionProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle between description-based and manual entry
                  SwitchListTile(
                    title: const Text(
                      'Shyiramo Umubare na Ibisobanuro Byihariye',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: provider.useManualEntry,
                    onChanged: (value) {
                      provider.setUseManualEntry(value);
                    },
                    activeColor: AppColors.primaryColor,
                    activeTrackColor: AppColors.primaryColor.withOpacity(0.5),
                    inactiveThumbColor: AppColors.textSecondary,
                    inactiveTrackColor:
                        AppColors.textSecondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  // Description field (now with multiple lines)
                  TextField(
                    controller: provider.descriptionController,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: provider.useManualEntry
                          ? 'Ibisobanuro (Urugero: Imyenda Yaguwe)'
                          : 'Ibisobanuro (Urugero: Yaguze imyenda 5000 amafranga)',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Manual entry fields
                  if (provider.useManualEntry) ...[
                    TextField(
                      controller: provider.amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Umubare (Urugero: 5000)',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: provider.dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Itariki (Urugero: 13/4/2025)',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
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
                        if (pickedDate != null) {
                          provider.setSelectedDate(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Income/Expense toggle
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => provider.setTransactionType(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: provider.isIncome
                                ? AppColors.lightGreen
                                : AppColors.textSecondary.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: provider.isIncome ? 5 : 0,
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => provider.setTransactionType(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !provider.isIncome
                                ? AppColors.secondaryOrange
                                : AppColors.textSecondary.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: !provider.isIncome ? 5 : 0,
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Category dropdown
                  DropdownButtonFormField<String>(
                    value: provider.selectedCategory,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        provider.setCategory(value);
                      }
                    },
                    items: [
                      if (provider.isIncome) ...[
                        const DropdownMenuItem(
                            value: 'Sales', child: Text('Kugurisha')),
                        const DropdownMenuItem(
                            value: 'Salary', child: Text('Umushahara')),
                        const DropdownMenuItem(
                            value: 'Rent Income',
                            child: Text('Kodesha Yinjiye')),
                        const DropdownMenuItem(
                            value: 'Dividend', child: Text('Umugabane')),
                        const DropdownMenuItem(
                            value: 'Interest', child: Text('Intere')),
                        const DropdownMenuItem(
                            value: 'Royalty', child: Text('Royalty')),
                        const DropdownMenuItem(
                            value: 'Commission', child: Text('Komisiyo')),
                        const DropdownMenuItem(
                            value: 'Bonus', child: Text('Bonuse')),
                        const DropdownMenuItem(
                            value: 'Income', child: Text('Amafaranga Yinjiye')),
                      ],
                      if (!provider.isIncome) ...[
                        const DropdownMenuItem(
                            value: 'Inventory', child: Text('Ibicuruzwa')),
                        const DropdownMenuItem(
                            value: 'Utilities', child: Text('Ibikoresho')),
                        const DropdownMenuItem(
                            value: 'Rent', child: Text('Kukodesha')),
                        const DropdownMenuItem(
                            value: 'Payroll',
                            child: Text('Umushahara Wabakozi')),
                        const DropdownMenuItem(
                            value: 'Loan', child: Text('Inguzanyo')),
                        const DropdownMenuItem(
                            value: 'Insurance', child: Text('Ubwishingizi')),
                        const DropdownMenuItem(
                            value: 'Tax', child: Text('Umutego')),
                        const DropdownMenuItem(
                            value: 'Fine', child: Text('Fine')),
                        const DropdownMenuItem(
                            value: 'Marketing', child: Text('Kwamamaza')),
                        const DropdownMenuItem(
                            value: 'Training', child: Text('Amasomo')),
                        const DropdownMenuItem(
                            value: 'Expense',
                            child: Text('Amafaranga Yasohotse')),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: OutlinedButton(
                  //         onPressed: () => Navigator.pop(context),
                  //         style: OutlinedButton.styleFrom(
                  //           padding: const EdgeInsets.symmetric(vertical: 16),
                  //           side: const BorderSide(
                  //             color: AppColors.textSecondary,
                  //             width: 1.5,
                  //           ),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //         ),
                  //         child: const Text(
                  //           'Hagarika',
                  //           style: TextStyle(
                  //             color: AppColors.textSecondary,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 16),
                  //     Expanded(
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           provider.addTransaction(context);
                  //           Navigator.pop(context);
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: AppColors.primaryColor,
                  //           padding: const EdgeInsets.symmetric(vertical: 16),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //           elevation: 5,
                  //         ),
                  //         child: Text(
                  //           provider.useManualEntry ? 'Bika' : 'Shyiraho',
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.addTransaction(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
