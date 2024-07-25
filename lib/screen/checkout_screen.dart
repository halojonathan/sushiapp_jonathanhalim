import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_mobile_app/provider/cart.dart';
import 'package:sushi_mobile_app/screen/va.dart';
import 'dart:math';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'E-Wallet';

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, value, child) {
      double price = 0;
      double totalPrice = 0;
      double taxAndService = 0;
      double totalPayment = 0;

      String generateRandomAccountNumber() {
        final random = Random();
        final accountNumber =
            List.generate(12, (index) => random.nextInt(10)).join('');
        return accountNumber;
      }

      for (var cartModel in value.cart) {
        price = int.parse(cartModel.quantity.toString()) *
            int.parse(cartModel.price.toString()).toDouble();
        totalPrice += double.parse(price.toString());
        taxAndService = (totalPrice * 0.11).toDouble();
        totalPayment = totalPrice + taxAndService.toDouble();
      }

      taxAndService = totalPrice * 0.11;
      totalPayment = totalPrice + taxAndService;

      return Scaffold(
        appBar: AppBar(
          title: const Text("Checkout"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.cart.length,
                itemBuilder: (context, index) {
                  final food = value.cart[index];
                  return ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        food.imagePath.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      food.name.toString(),
                    ),
                    subtitle: Text(
                      "${food.quantity}x${food.price} IDR",
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Price"),
                            Text("IDR $totalPrice"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Tax and Service"),
                            Text("IDR $taxAndService"),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Price",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'IDR $totalPayment',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "*Double check your order before Payment",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Payment Method",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  RadioListTile<String>(
                    title: const Text('Bank Transfer'),
                    value: 'Bank Transfer',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('E-Wallet'),
                    value: 'E-Wallet',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(20),
                    borderRadius: BorderRadius.circular(30),
                    onPressed: () {
                      final randomAccountNumber = generateRandomAccountNumber();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Va(accountNumber: randomAccountNumber),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
