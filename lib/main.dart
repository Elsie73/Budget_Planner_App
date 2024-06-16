import 'package:flutter/material.dart';

void main() {
  runApp(BudgetPlannerApp());
}

class BudgetPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Planner',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey,
        primarySwatch: Colors.pink,
      ),
      home: BudgetScreen(),
    );
  }
}

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  List<Expense> expenses = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Expense Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                addExpense();
              },
              child: Text('Add Expense'),
            ),
            SizedBox(height: 20),
            Text(
              'Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(expenses[index].title),
                      trailing: Text(
                          '₹ ${expenses[index].amount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double totalAmount = calculateTotal();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Total Expenses'),
                      content:
                          Text('Total: ₹ ${totalAmount.toStringAsFixed(2)}'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                        )
                      ],
                    );
                  },
                );
              },
              child: Text('Calculate Total'),
            ),
          ],
        ),
      ),
    );
  }

  void addExpense() {
    String title = titleController.text;
    double amount = double.tryParse(amountController.text) ?? 0.0;

    if (title.isNotEmpty && amount > 0) {
      setState(() {
        expenses.add(Expense(title: title, amount: amount));
        titleController.clear();
        amountController.clear();
      });
    }
  }

  double calculateTotal() {
    double total = 0;
    for (var expense in expenses) {
      total += expense.amount;
    }
    return total;
  }
}

class Expense {
  final String title;
  final double amount;

  Expense({required this.title, required this.amount});
}
