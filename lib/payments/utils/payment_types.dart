// ignore_for_file: constant_identifier_names
//fixed payment type to call from channel
enum PaymentTypeCall {
  CREDIT,
  CREDIT_PARC,
  DEBIT,
  PIX,
  REFOUND,
  REPRINTER,
  REPORT,
  ACTIVE_TERMINAL,
  CONFIGURE_PINPAD,
  SALE,
}

enum PaymentTypeTransaction { CREDIT, DEBIT, CREDIT_PARC, PIX }

enum PaymentTypeCredit { SALESMAN, CLIENT }

extension PaymentTypeTransactioneExt on PaymentTypeTransaction {
  get type {
    switch (this) {
      case PaymentTypeTransaction.CREDIT:
        return 1;
      case PaymentTypeTransaction.DEBIT:
        return 2;
      case PaymentTypeTransaction.PIX:
        return 3;
      case PaymentTypeTransaction.CREDIT_PARC:
        return 4;
    }
  }
}

extension PaymentTypeCreditExt on PaymentTypeCredit {
  get value {
    switch (this) {
      case PaymentTypeCredit.SALESMAN:
        return 2;
      case PaymentTypeCredit.CLIENT:
        return 3;
    }
  }
}

//Fixed method to call on methodChannel
extension PaymentTypeCallExt on PaymentTypeCall {
  get method {
    switch (this) {
      case PaymentTypeCall.CREDIT:
        return "elginCredit";
      case PaymentTypeCall.CREDIT_PARC:
        return "elginCreditParc";
      case PaymentTypeCall.DEBIT:
        return "elginDebit";
      case PaymentTypeCall.PIX:
        return "elginPix";
      case PaymentTypeCall.REFOUND:
        return "refundElgin";
      case PaymentTypeCall.REPRINTER:
        return "reprinterElgin";
      case PaymentTypeCall.REPORT:
        return "reportElgin";
      case PaymentTypeCall.ACTIVE_TERMINAL:
        return "activeTerminalElgin";
      case PaymentTypeCall.CONFIGURE_PINPAD:
        return "configurePinpadElgin";
      case PaymentTypeCall.SALE:
        return "saleElgin";
    }
  }
}
