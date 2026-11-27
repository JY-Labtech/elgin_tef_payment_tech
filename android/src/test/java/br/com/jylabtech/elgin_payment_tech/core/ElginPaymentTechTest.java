package br.com.jylabtech.elgin_payment_tech.core;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import android.app.Activity;
import android.content.Intent;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;

/**
 * Cada método exposto ao Dart (lib/payments/utils/payment_types.dart e lib/payments/style.dart)
 * chama o Elgin IDH direto, sem nenhuma validação prévia.
 *
 * Roda na JVM com o android.jar "mockable" (unitTests.returnDefaultValues = true): a Activity
 * falsa só registra como o IDH foi aberto.
 */
public class ElginPaymentTechTest {
    private static final int TEF_REQUEST = 9876;
    private static final int STYLE_REQUEST = 987699;
    private static final int START_ACTIVITY = -1;

    private static final String[] PAYMENT_METHODS = {
            "elginCredit", "elginCreditParc", "elginDebit", "elginPix",
            "refundElgin", "reprinterElgin", "reportElgin",
            "activeTerminalElgin", "configurePinpadElgin", "saleElgin",
    };
    private static final String[] STYLE_METHODS = {
            "configureCustomHeader", "configureIconsCenter", "clearAllStyle",
    };

    /** Activity que registra o requestCode de cada abertura do IDH. */
    static class FakeActivity extends Activity {
        final List<Integer> requests = new ArrayList<>();

        @Override
        public void startActivityForResult(Intent intent, int requestCode) {
            requests.add(requestCode);
        }

        @Override
        public void startActivity(Intent intent) {
            requests.add(START_ACTIVITY);
        }
    }

    private static MethodCall call(String method) {
        Map<String, Object> args = new HashMap<>();
        args.put("value", "1000");
        args.put("parc", "2");
        args.put("financ", "1");
        args.put("nsu", "123");
        args.put("date", "01/10/2026");
        args.put("companyDocument", "00000000000000");
        args.put("name", "app");
        args.put("version", "1");
        args.put("textPinpad", "oi");
        args.put("buttonColor", "#000000");
        args.put("backgroundColor", "#FFFFFF");
        return new MethodCall(method, args);
    }

    @Test
    public void everyDartMethodIsKnown() {
        for (String method : PAYMENT_METHODS) {
            assertTrue(method, ElginPaymentTech.isKnownMethod(method));
        }
        for (String method : STYLE_METHODS) {
            assertTrue(method, ElginPaymentTech.isKnownMethod(method));
        }
        assertTrue(ElginPaymentTech.isKnownMethod("configureBackground"));
        assertEquals(PAYMENT_METHODS.length + STYLE_METHODS.length + 1, ElginPaymentTech.KNOWN_METHODS.size());
    }

    @Test
    public void unknownMethodIsNotDispatched() {
        assertFalse(ElginPaymentTech.isKnownMethod("foo"));
        assertFalse(ElginPaymentTech.isKnownMethod(null));

        FakeActivity activity = new FakeActivity();
        RecordingResult result = new RecordingResult();
        new ElginPaymentTech(null, null, activity).initPayment(new MethodCall("foo", null), result);
        assertEquals(Collections.singletonList("notImplemented"), result.calls);
        assertTrue(activity.requests.isEmpty());
    }

    @Test
    public void paymentMethodsOpenTefDirectlyAndWaitForActivityResult() {
        for (String method : PAYMENT_METHODS) {
            FakeActivity activity = new FakeActivity();
            RecordingResult result = new RecordingResult();
            new ElginPaymentTech(null, null, activity).initPayment(call(method), result);

            // Abre o IDH na hora (sem etapa assíncrona antes) e só responde em onActivityResult.
            assertEquals(method, Collections.singletonList(TEF_REQUEST), activity.requests);
            assertTrue(method, result.calls.isEmpty());
        }
    }

    @Test
    public void styleMethodsOpenCustomDirectly() {
        for (String method : STYLE_METHODS) {
            FakeActivity activity = new FakeActivity();
            RecordingResult result = new RecordingResult();
            new ElginPaymentTech(null, null, activity).initPayment(call(method), result);

            assertEquals(method, Collections.singletonList(STYLE_REQUEST), activity.requests);
            assertTrue(method, result.calls.isEmpty());
        }
    }

    @Test
    public void configureBackgroundAnswersTrueWhenIdhOpens() {
        FakeActivity activity = new FakeActivity();
        RecordingResult result = new RecordingResult();
        new ElginPaymentTech(null, null, activity).initPayment(call("configureBackground"), result);

        assertEquals(Collections.singletonList(START_ACTIVITY), activity.requests);
        assertEquals(Collections.singletonList("success"), result.calls);
        assertEquals(Boolean.TRUE, result.value);
    }

    @Test
    public void failureToOpenIdhAnswersElginErrorOnce() {
        RecordingResult result = new RecordingResult();
        // Sem Activity: abrir o IDH falha e a chamada responde ELGIN_ERROR uma única vez.
        new ElginPaymentTech(null, null, null).initPayment(call("elginCredit"), result);
        assertEquals(Collections.singletonList("error"), result.calls);
        assertEquals(ElginPaymentTech.ELGIN_ERROR, result.errorCode);
    }
}
