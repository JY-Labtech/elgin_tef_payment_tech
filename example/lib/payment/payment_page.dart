import 'package:flutter/material.dart';
import 'package:elgin_payment_tech/elgin_payment_tech.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double? saleValue;
  TextEditingController moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) => setState(() {}),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Digite o valor"),
            controller: moneyController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Selecione o método de pagamento",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 10.0,
            children: <Widget>[
              ElevatedButton(
                child: const Text("Débito"),
                onPressed: () {
                  ElginPaymentTech.instance.payment.debitTransaction(value: '10.54');
                },
              ),
              ElevatedButton(
                child: const Text("Crédito"),
                onPressed: () {
                  ElginPaymentTech.instance.payment.creditTransaction(value: '12.34');
                },
              ),
              ElevatedButton(
                child: const Text("Crédito Parc- 2"),
                onPressed: () {
                  ElginPaymentTech.instance.payment.creditParcTransaction(value: '98.30', parc: '2', financ: '1');
                },
              ),
              ElevatedButton(
                child: const Text("Voucher"),
                onPressed: () {
                  ElginPaymentTech.instance.payment.debitTransaction(value: '10.54');
                },
              ),
              ElevatedButton(
                child: const Text("ATIVAR PINPAD"),
                onPressed: () async {
                  ElginPaymentTech.instance.payment.activeTerminal(companyDocument: 'CNPJ da empresa');
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
