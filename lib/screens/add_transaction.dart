import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/add_transaction_provider.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
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
            final dashboardProvider =
                Provider.of<DashboardProvider>(context, listen: false);

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
                    activeColor: AppColors.primaryColorBlue,
                    activeTrackColor: const Color.fromARGB(255, 91, 104, 119)
                        .withOpacity(0.5),
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
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: provider.useManualEntry
                          ? 'Ibisobanuro (Urugero: Imyenda Yaguzwe)'
                          : 'Ibisobanuro (Urugero: Naguze imyenda 5000 amafaranga)',
                      hintStyle: GoogleFonts.outfit(
                        color: Colors.white70,
                      ),
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
                  // Manual entry fields
                  if (provider.useManualEntry) ...[
                    TextField(
                      controller: provider.amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Umubare urugero (5000)',
                        hintStyle: GoogleFonts.outfit(
                          color: Colors.white70,
                        ),
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
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: provider.dateController,
                      readOnly: true,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Italiki',
                        hintStyle: GoogleFonts.outfit(
                          color: Colors.white70,
                        ),
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
                        if (pickedDate != null) {
                          provider.setSelectedDate(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Income/Expense toggle
                  if (provider.useManualEntry)
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
                  const SizedBox(height: 16),
                  // Category dropdown
                  if (provider.useManualEntry)
                    DropdownButtonFormField<String>(
                      value: provider.selectedCategory,
                      isExpanded: true,
                      style: GoogleFonts.outfit(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ikiciro',
                        hintStyle: GoogleFonts.outfit(
                          color: Colors.white70,
                        ),
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
                              value: 'Income',
                              child: Text('Amafaranga Yinjiye')),
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
                  if (provider.useManualEntry) const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.addTransaction(context);
                        if (dashboardProvider.error == null) {
                          Navigator.pop(context);
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
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
