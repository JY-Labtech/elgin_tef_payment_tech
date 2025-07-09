package br.com.jylabtech.elgin_payment_tech.core;

import android.app.Activity;
import android.content.Context;
import android.util.Log;


import br.com.jylabtech.elgin_payment_tech.presenter.PaymentsPresenter;
import br.com.jylabtech.elgin_payment_tech.presenter.StylePresenter;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ElginPaymentTech {
    final MethodChannel mChannel;

    // FUNCTIONS
    PaymentsPresenter payment;
    StylePresenter style;

    // METHODS
    private static final String ELGIN_SALE = "saleElgin";
    private static final String CONFIGURE_PINPAD = "configurePinpadElgin";
    private static final String ACTIVE_TERMINAL = "activeTerminalElgin";

    private static final String PAYMENT_DEBIT = "elginDebit";
    private static final String PAYMENT_CREDIT = "elginCredit";
    private static final String PAYMENT_CREDIT_PARC = "elginCreditParc";
    private static final String PAYMENT_PIX = "elginPix";

    private static final String REPRINTER_ELGIN = "reprinterElgin";
    private static final String REFUND_ELGIN = "refundElgin";
    private static final String REPORT_ELGIN = "reportElgin";

    //Style
    private static final String CONFIGURE_BACKGROUND = "configureBackground";
    private static final String CONFIGURE_CUSTOM_HEADER = "configureCustomHeader";
    private static final String CONFIGURE_ICONS_CENTER = "configureIconsCenter";
    private static final String CLEAR_STYLE = "clearAllStyle";
    
    final Context currentContext;
    private Activity mActivity;

    public ElginPaymentTech(Context context, MethodChannel channel, Activity activity) {
        this.currentContext = context;
        this.mChannel = channel;
        this.mActivity = activity;
    }

    public void initPayment(MethodCall call, MethodChannel.Result result) {
        if (this.payment == null) {
            this.payment = new PaymentsPresenter(this.mActivity);
        }

        if (this.style == null) {
            this.style = new StylePresenter(this.mActivity);
        }

        if (call.method.equals(ELGIN_SALE)) {
            this.payment.sale();
            return;
        }

        if (call.method.equals(CONFIGURE_PINPAD)) {
            this.payment.configurePinpad(call);
            return;
        }

        if (call.method.equals(ACTIVE_TERMINAL)) {
            this.payment.activeTerminal(call);
            return;
        }

        if (call.method.equals(PAYMENT_DEBIT)) {
            this.payment.debitCardTransaction(call);
            return;
        }

        if (call.method.equals(PAYMENT_CREDIT)) {
            this.payment.creditCardTransaction(call);
            return;
        }
        
        if(call.method.equals(PAYMENT_CREDIT_PARC)) {
            this.payment.creditCardParcTransaction(call);
            return;
        }

        if(call.method.equals(PAYMENT_PIX)) {
            this.payment.pixTransaction(call);
            return;
        }

        if(call.method.equals(REPRINTER_ELGIN)) {
            this.payment.reprintTransaction(call);
            return;
        }

        if(call.method.equals(REFUND_ELGIN)) {
            this.payment.refundTransaction(call);
            return;
        }

        if(call.method.equals(REPORT_ELGIN)){
            this.payment.reportTransaction(call);
            return;
        }

        if(call.method.equals(CONFIGURE_BACKGROUND)) {
            this.style.configureBackgroud(call);
            return;
        }

        if(call.method.equals(CONFIGURE_CUSTOM_HEADER)) {
            this.style.configureCustomHeader(call);
            return;
        }

        if(call.method.equals(CONFIGURE_ICONS_CENTER)) {
            this.style.configureIconsCenter(call);
            return;
        }

        if(call.method.equals(CLEAR_STYLE)) {
            this.style.clearAllStyle();
            return;
        }

        result.notImplemented();
    }
}
