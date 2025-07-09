package br.com.jylabtech.elgin_payment_tech.presenter;

import android.app.Activity;
import android.content.Context;


import br.com.jylabtech.elgin_payment_tech.usecase.ElginTefUsecase;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;

public class PaymentsPresenter {

    private ElginTefUsecase mUseCase;

    public PaymentsPresenter(Activity activity) {
        this.mUseCase = new ElginTefUsecase(activity);
    }

    public void configurePinpad(MethodCall call) {
        String name = call.argument("name");
        String version = call.argument("version");
        String textPinpad = call.argument("textPinpad");
        mUseCase.configurePinpad(name, version, textPinpad);
    }

    public void activeTerminal(MethodCall call) {
        String companyDocument = call.argument("companyDocument");
        mUseCase.activeTerminal(companyDocument);
    }

    public void creditCardTransaction(MethodCall call) {
        String value = call.argument("value");
        mUseCase.creditCardTransaction(value);
    }

    public void creditCardParcTransaction(MethodCall call) {
        String value = call.argument("value");
        String parc = call.argument("parc");
        String financ = call.argument("financ");
        mUseCase.creditCardParcTransaction(value, parc, financ);
    }

    public void debitCardTransaction(MethodCall call) {
        String value = call.argument("value");
        mUseCase.debitCardTransaction(value);
    }

    public void pixTransaction(MethodCall call) {
        String value = call.argument("value");
        mUseCase.pixTransaction(value);
    }

    public void refundTransaction(MethodCall call) {
        String value = call.argument("value");
        String nsu = call.argument("nsu");
        String date = call.argument("date");
        mUseCase.refundTransaction(value, nsu, date);
    }

    public void reprintTransaction(MethodCall call) {
        mUseCase.reprintTransaction();
    }

    public void reportTransaction(MethodCall call) {
        mUseCase.reportTransaction();
    }

    public void sale() {
        mUseCase.sale();
    }
}
