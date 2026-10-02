package br.com.jylabtech.elgin_payment_tech.core;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/**
 * Garante que todo método de negócio exposto ao Dart (lib/payments/utils/payment_types.dart e
 * lib/payments/style.dart) passa pelo gate de licença em ElginPaymentTech.initPayment.
 */
public class LicenceGateMethodsTest {
    private static final String[] DART_METHODS = {
            // Payment
            "elginCredit", "elginCreditParc", "elginDebit", "elginPix",
            "refundElgin", "reprinterElgin", "reportElgin",
            "activeTerminalElgin", "configurePinpadElgin", "saleElgin",
            // ElginStyle
            "configureBackground", "configureCustomHeader", "configureIconsCenter", "clearAllStyle",
    };

    @Test
    public void everyDartMethodIsGated() {
        for (String method : DART_METHODS) {
            assertTrue(method, ElginPaymentTech.isKnownMethod(method));
        }
        assertEquals(DART_METHODS.length, ElginPaymentTech.GATED_METHODS.size());
    }

    @Test
    public void unknownMethodIsNotDispatched() {
        assertFalse(ElginPaymentTech.isKnownMethod("foo"));
        assertFalse(ElginPaymentTech.isKnownMethod(null));
    }

    @Test
    public void errorCodeIsLicenceError() {
        assertEquals("LICENCE_ERROR", ElginPaymentTech.LICENCE_ERROR);
    }
}
