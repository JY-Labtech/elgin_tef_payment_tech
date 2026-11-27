import 'package:elgin_payment_tech/elgin_payment_tech.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController moneyController = TextEditingController(text: '10.00');

  @override
  void initState() {
    super.initState();
    ElginPaymentTech.I.initPayment();
  }

  @override
  void dispose() {
    moneyController.dispose();
    super.dispose();
  }

  String get _value => moneyController.text.trim().replaceAll(',', '.');

  Future<void> _run(Future<ElginResponse?> Function() operation) async {
    String message;
    try {
      final response = await operation();
      message = response?.isTransactionValid == true
          ? 'Aprovada. NSU: ${response!.transaction!.nsu}'
          : (response?.mensagem ?? 'Sem resposta do Elgin IDH');
    } on PlatformException catch (e) {
      // ELGIN_BUSY: outra operação em andamento. ELGIN_ERROR: cancelada/sem resposta ou erro nativo.
      message = '${e.code}: ${e.message}';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final payment = ElginPaymentTech.I.payment;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Digite o valor (ex.: 10.00)"),
            controller: moneyController,
          ),
          const SizedBox(height: 20),
          const Text("Selecione o método de pagamento", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10.0,
            children: <Widget>[
              ElevatedButton(
                child: const Text("Débito"),
                onPressed: () => _run(() => payment.debitTransaction(value: _value)),
              ),
              ElevatedButton(
                child: const Text("Crédito"),
                onPressed: () => _run(() => payment.creditTransaction(value: _value)),
              ),
              ElevatedButton(
                child: const Text("Crédito Parc - 2"),
                onPressed: () => _run(() => payment.creditParcTransaction(value: _value, parc: '2', financ: '1')),
              ),
              ElevatedButton(
                child: const Text("PIX"),
                onPressed: () => _run(() => payment.pixTransaction(value: _value)),
              ),
              ElevatedButton(
                child: const Text("Reimprimir"),
                onPressed: () => _run(payment.reprinterLastTransaction),
              ),
              ElevatedButton(
                child: const Text("Ativar terminal"),
                onPressed: () => _run(() => payment.activeTerminal(companyDocument: '00000000000000')),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
