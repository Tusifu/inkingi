import 'dart:io';

import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:inkingi/providers/dashboard_provider.dart';

class MessageReaderScreen extends StatefulWidget {
  static const String routeName = '/messageReaderScreen';
  const MessageReaderScreen({super.key});

  @override
  _MessageReaderScreenState createState() => _MessageReaderScreenState();
}

class _MessageReaderScreenState extends State<MessageReaderScreen> {
  final List<Transaction> _transactions = [];
  final Telephony telephony = Telephony.instance;
  bool _isSelectMode = false;
  final Map<int, bool> _selectedTransactions = {};
  bool _isLoading = false;
  final DateTime _today = DateTime.now();
  final DateTime _last7Days = DateTime.now().subtract(const Duration(days: 7));
  final DateTime _monthStart =
      DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndLoadMessages();
  }

  Future<void> _checkPermissionsAndLoadMessages() async {
    setState(() => _isLoading = true);
    if (Platform.isIOS) {
      setState(() => _isLoading = false);
      return;
    }

    PermissionStatus status = await Permission.sms.request();
    if (status.isGranted) {
      await _loadMessages();
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Ntibyakunze kubona uruhusa rwo gusoma ubutumwa bugufi, butangire muri settings'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Settings',
            textColor: Colors.white,
            onPressed: _openAppSettings,
          ),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Hakenewe uburenganzira, ngo dusome ubutumwa bugufi mufitemo, bikorerwa muri settings.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Settings',
            textColor: Colors.white,
            onPressed: _openAppSettings,
          ),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  Future<void> _loadMessages() async {
    try {
      final smsList = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals('M-Money'),
      );

      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      final existingIds =
          dashboardProvider.transactions.map((t) => t.id).toSet();

      final newTransactions = smsList
          .map((sms) {
            final body = sms.body ?? '';
            if (body.contains('transferred to')) {
              final amountMatch =
                  RegExp(r'\*165\*S\*(\d+) RWF').firstMatch(body);
              final nameMatch =
                  RegExp(r'transferred to ([\w\s]+)\s\(').firstMatch(body);
              final timeMatch =
                  RegExp(r'at (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})')
                      .firstMatch(body);
              final transactionIdMatch = RegExp(r'\*EN#(\d+)').firstMatch(body);

              return Transaction(
                id: transactionIdMatch?.group(1) ?? 'N/A',
                description: nameMatch?.group(1) ?? 'Unknown',
                category: 'M-Money',
                amount: double.tryParse(amountMatch?.group(1) ?? '0') ?? 0.0,
                isIncome: false,
                date: DateTime.tryParse(timeMatch?.group(1) ?? '') ??
                    DateTime.now(),
                productName: null,
              );
            } else if (body.contains('You have received')) {
              final amountMatch =
                  RegExp(r'You have received (\d+) RWF').firstMatch(body);
              final nameMatch = RegExp(r'from ([\w\s]+)\s\(').firstMatch(body);
              final timeMatch =
                  RegExp(r'at (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})')
                      .firstMatch(body);
              final transactionIdMatch =
                  RegExp(r'Financial Transaction Id: (\d+)').firstMatch(body);

              return Transaction(
                id: transactionIdMatch?.group(1) ?? 'N/A',
                description: nameMatch?.group(1) ?? 'Unknown',
                category: 'M-Money',
                amount: double.tryParse(amountMatch?.group(1) ?? '0') ?? 0.0,
                isIncome: true,
                date: DateTime.tryParse(timeMatch?.group(1) ?? '') ??
                    DateTime.now(),
                productName: null,
              );
            } else if (body.contains('BK Pay')) {
              final amountMatch = RegExp(r'Amount:RWF (\d+)').firstMatch(body);
              final nameMatch =
                  RegExp(r'Beneficiary: ([\w\s]+)').firstMatch(body);
              final timeMatch =
                  RegExp(r'Date: ([\w\s]+ \d{2} \d{2}:\d{2}:\d{2} CAT \d{4})')
                      .firstMatch(body);
              final transactionIdMatch =
                  RegExp(r'Event #:(\w+)').firstMatch(body);

              final timeStr = timeMatch?.group(1)?.replaceAll('CAT', '').trim();
              DateTime? parsedDate;
              if (timeStr != null) {
                parsedDate =
                    DateFormat('EEE MMM dd HH:mm:ss yyyy').parse(timeStr);
              }

              return Transaction(
                id: transactionIdMatch?.group(1) ?? 'N/A',
                description: nameMatch?.group(1) ?? 'Unknown',
                category: 'BKeBank',
                amount: double.tryParse(amountMatch?.group(1) ?? '0') ?? 0.0,
                isIncome: false,
                date: parsedDate ?? DateTime.now(),
                productName: null,
              );
            }
            return null;
          })
          .whereType<Transaction>()
          .where((t) => !existingIds.contains(t.id))
          .toList();

      setState(() {
        _transactions.clear();
        _transactions.addAll(newTransactions);
        _selectedTransactions.clear();
      });
    } catch (e) {
      print('Error loading messages: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nitbyakunze gusoma message: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _toggleSelectMode() {
    setState(() {
      _isSelectMode = !_isSelectMode;
      if (!_isSelectMode) {
        _selectedTransactions.clear();
      }
    });
  }

  void _showSaveDialog() {
    if (!_isSelectMode || _selectedTransactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enable select mode and choose transactions to save.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Select Transactions to Save',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._transactions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final transaction = entry.value;
                      return CheckboxListTile(
                        title: Text(
                          '${transaction.category}: ${transaction.description} - ${NumberFormat.decimalPattern().format(transaction.amount)} RWF',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        value: _selectedTransactions[index] ?? false,
                        onChanged: (value) {
                          setState(() {
                            _selectedTransactions[index] = value!;
                          });
                        },
                        activeColor: AppColors.primaryColorBlue,
                        checkColor: Colors.white,
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTransactions.clear();
                          for (int i = 0; i < _transactions.length; i++) {
                            _selectedTransactions[i] = true;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColorBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Select All',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.primaryColorBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final dashboardProvider =
                    Provider.of<DashboardProvider>(context, listen: false);
                final savedIndices = <int>[];
                _selectedTransactions.forEach((index, selected) {
                  if (selected) {
                    final transaction = _transactions[index];
                    dashboardProvider.addTransaction(transaction);
                    savedIndices.add(index);
                  }
                });
                setState(() {
                  for (var index in savedIndices.reversed) {
                    _transactions.removeAt(index);
                    _selectedTransactions.remove(index);
                  }
                  _isSelectMode = false; // Exit select mode after saving
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transactions saved successfully'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColorBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save Selected',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Ubutumwa Bugufi',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _checkPermissionsAndLoadMessages,
          ),
          IconButton(
            icon: Icon(
                _isSelectMode ? Icons.checklist : Icons.checklist_outlined,
                color: Colors.white),
            onPressed: _toggleSelectMode,
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _showSaveDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(color: AppColors.primaryColorBlue),
            )
          : Platform.isIOS
              ? const Center(
                  child: Text(
                    'Service not available on iOS',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        children: [
                          _buildSection(
                              'Today',
                              _transactions
                                  .where((t) => isSameDay(t.date, _today))
                                  .toList()),
                          _buildSection(
                              'Last 7 Days',
                              _transactions
                                  .where((t) =>
                                      t.date.isAfter(_last7Days) &&
                                      !isSameDay(t.date, _today))
                                  .toList()),
                          _buildSection(
                              'This Month',
                              _transactions
                                  .where((t) =>
                                      t.date.isAfter(_monthStart) &&
                                      !t.date.isAfter(_today) &&
                                      !t.date.isAfter(_last7Days))
                                  .toList()),
                        ],
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: TBottomNavBar(
        currentSelected: 4,
      ),
    );
  }

  Widget _buildSection(String title, List<Transaction> transactions) {
    if (transactions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
        ...transactions
            .map((transaction) => Card(
                  color: AppColors.cardBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(
                      transaction.isIncome
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: transaction.isIncome
                          ? AppColors.incomeColor
                          : AppColors.expensesColor,
                    ),
                    title: Text(
                      '${transaction.category}: ${transaction.description}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount: ${NumberFormat.decimalPattern().format(transaction.amount)} RWF',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.date)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Transaction ID: ${transaction.id}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    trailing: _isSelectMode
                        ? Checkbox(
                            value: _selectedTransactions[
                                    _transactions.indexOf(transaction)] ??
                                false,
                            onChanged: (value) {
                              setState(() {
                                _selectedTransactions[_transactions
                                    .indexOf(transaction)] = value!;
                              });
                            },
                            activeColor: AppColors.primaryColorBlue,
                            checkColor: Colors.white,
                          )
                        : Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: transaction.isIncome
                                  ? AppColors.incomeColor.withOpacity(0.2)
                                  : AppColors.expensesColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              transaction.isIncome ? 'Income' : 'Expense',
                              style: TextStyle(
                                color: transaction.isIncome
                                    ? AppColors.incomeColor
                                    : AppColors.expensesColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildColorKey({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
