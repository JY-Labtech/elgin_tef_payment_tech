package br.com.jylabtech.elgin_payment_tech.core;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


import br.com.jylabtech.elgin_payment_tech.licence.CheckLicenceTech;
import br.com.jylabtech.elgin_payment_tech.licence.LicenceResult;
import br.com.jylabtech.elgin_payment_tech.licence.LicenceRules;
import br.com.jylabtech.elgin_payment_tech.presenter.PaymentsPresenter;
import br.com.jylabtech.elgin_payment_tech.presenter.StylePresenter;
import br.com.jylabtech.elgin_payment_tech.BuildConfig;

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

    private CheckLicenceTech licenceTech;

    public static final String LICENCE_ERROR = "LICENCE_ERROR";
    public static final String ELGIN_ERROR = "ELGIN_ERROR";
    private static final String TAG = "ElginPaymentTech";

    /** Métodos que executam algo de negócio e por isso exigem licença válida. */
    static final Set<String> GATED_METHODS = new HashSet<>(Arrays.asList(
            ELGIN_SALE, CONFIGURE_PINPAD, ACTIVE_TERMINAL,
            PAYMENT_DEBIT, PAYMENT_CREDIT, PAYMENT_CREDIT_PARC, PAYMENT_PIX,
            REPRINTER_ELGIN, REFUND_ELGIN, REPORT_ELGIN,
            CONFIGURE_BACKGROUND, CONFIGURE_CUSTOM_HEADER, CONFIGURE_ICONS_CENTER, CLEAR_STYLE
    ));

    /** Validação de licença (disco/rede) fora da main thread, uma por vez. */
    private static final ExecutorService LICENCE_EXECUTOR = Executors.newSingleThreadExecutor();
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    public ElginPaymentTech(Context context, MethodChannel channel, Activity activity) {
        this.currentContext = context;
        this.mChannel = channel;
        this.mActivity = activity;
        this.licenceTech = new CheckLicenceTech(context);
    }

    /**
     * Ponto de entrada de todos os métodos do MethodChannel.
     *
     * Toda operação conhecida (pagamentos, estorno, reimpressão, relatório, ativação/configuração
     * do pinpad e personalização visual) passa pelo gate de licença antes de chamar o SDK da Elgin:
     * primeiro o cache local válido (sem rede) e, se não houver, o servidor oficial da JY Labtech.
     * A validação roda fora da main thread; a operação e a resposta ao Flutter rodam na main thread.
     * Licença inválida responde {@code result.error("LICENCE_ERROR", mensagem, null)} e o SDK não é chamado.
     * As operações que abrem o IDH com startActivityForResult são respondidas pelo plugin em
     * onActivityResult (uma operação por vez, ver {@link PendingOperation}).
     */
    public void initPayment(final MethodCall call, final MethodChannel.Result result) {
        if (!isKnownMethod(call.method)) {
            result.notImplemented();
            return;
        }

        final String licenceKeyLocal = BuildConfig.LICENCE_KEY;
        final String licenceInternalKey = BuildConfig.LICENCE_INTERNAL_KEY;

        LICENCE_EXECUTOR.execute(new Runnable() {
            @Override
            public void run() {
                final LicenceResult licenceResult = checkValidLicence(licenceKeyLocal, licenceInternalKey);
                mainHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (licenceResult == null || licenceResult.getResult() != LicenceRules.RESULT_SUCCESS) {
                            String message = licenceResult != null ? licenceResult.getErrorMessage() : null;
                            result.error(LICENCE_ERROR,
                                    message != null && !message.isEmpty() ? message : "Licença inválida.",
                                    null);
                            return;
                        }
                        try {
                            dispatch(call, result);
                        } catch (Exception e) {
                            Log.e(TAG, "Erro ao executar " + call.method, e);
                            String message = e.getMessage();
                            result.error(ELGIN_ERROR, message != null ? message : e.getClass().getSimpleName(), null);
                        }
                    }
                });
            }
        });
    }

    public static boolean isKnownMethod(String method) {
        return GATED_METHODS.contains(method);
    }

    private void dispatch(MethodCall call, MethodChannel.Result result) {
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
            // O IDH é aberto com startActivity (sem onActivityResult): responde ao abrir,
            // senão a chamada nunca completaria e manteria o canal ocupado (ELGIN_BUSY).
            result.success(true);
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

    /** Valida a licença (cache válido ou servidor). Faz acesso a disco/rede: não chame na main thread. */
    private LicenceResult checkValidLicence(String licenceKey, String licenceInternalKey)  {
        return licenceTech.validateLicence(licenceKey, licenceInternalKey);
    }
}
