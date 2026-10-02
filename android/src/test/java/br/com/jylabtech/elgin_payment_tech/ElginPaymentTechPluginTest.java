package br.com.jylabtech.elgin_payment_tech;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import java.util.Collections;

import br.com.jylabtech.elgin_payment_tech.core.ElginPaymentTech;
import br.com.jylabtech.elgin_payment_tech.core.PendingOperation;
import br.com.jylabtech.elgin_payment_tech.core.RecordingResult;
import io.flutter.plugin.common.MethodCall;

/** Associação de cada resposta ao Result da sua chamada (sem Robolectric: sem Activity/Intent). */
public class ElginPaymentTechPluginTest {

    @Test
    public void newCallWhilePendingIsRejectedWithElginBusy() {
        ElginPaymentTechPlugin plugin = new ElginPaymentTechPlugin();
        RecordingResult first = new RecordingResult();
        assertNotNull(plugin.pendingOperation.start(first)); // operação em andamento no IDH

        RecordingResult second = new RecordingResult();
        plugin.onMethodCall(new MethodCall("elginDebit", null), second);

        assertEquals(Collections.singletonList("error"), second.calls);
        assertEquals(PendingOperation.ELGIN_BUSY, second.errorCode);
        assertTrue(first.calls.isEmpty());

        // Resultado do estilo vai para a primeira chamada, uma única vez.
        assertTrue(plugin.onActivityResult(987699, 0, null));
        assertTrue(plugin.onActivityResult(987699, 0, null));
        assertEquals(Collections.singletonList("success"), first.calls);
        assertEquals(1, second.calls.size());
    }

    @Test
    public void tefWithoutDataAnswersErrorOnceAndReleases() {
        ElginPaymentTechPlugin plugin = new ElginPaymentTechPlugin();
        RecordingResult first = new RecordingResult();
        plugin.pendingOperation.start(first);

        assertTrue(plugin.onActivityResult(9876, 0, null));
        assertTrue(plugin.onActivityResult(9876, 0, null));

        assertEquals(Collections.singletonList("error"), first.calls);
        assertEquals(ElginPaymentTech.ELGIN_ERROR, first.errorCode);
        assertFalse(plugin.pendingOperation.isBusy());
    }

    @Test
    public void unknownMethodDoesNotOccupyChannel() {
        ElginPaymentTechPlugin plugin = new ElginPaymentTechPlugin();
        RecordingResult result = new RecordingResult();
        plugin.onMethodCall(new MethodCall("foo", null), result);
        assertEquals(Collections.singletonList("notImplemented"), result.calls);
        assertFalse(plugin.pendingOperation.isBusy());
    }

    @Test
    public void notReadyAnswersErrorAndReleasesChannel() {
        ElginPaymentTechPlugin plugin = new ElginPaymentTechPlugin(); // sem engine/Activity
        RecordingResult first = new RecordingResult();
        RecordingResult second = new RecordingResult();
        plugin.onMethodCall(new MethodCall("elginCredit", null), first);
        plugin.onMethodCall(new MethodCall("elginCredit", null), second);

        assertEquals(ElginPaymentTech.ELGIN_ERROR, first.errorCode);
        assertEquals(ElginPaymentTech.ELGIN_ERROR, second.errorCode);
        assertEquals(1, first.calls.size());
        assertEquals(1, second.calls.size());
        assertFalse(plugin.pendingOperation.isBusy());
    }

    @Test
    public void otherRequestCodesAreIgnored() {
        ElginPaymentTechPlugin plugin = new ElginPaymentTechPlugin();
        RecordingResult first = new RecordingResult();
        plugin.pendingOperation.start(first);
        assertFalse(plugin.onActivityResult(1234, 0, null));
        assertTrue(first.calls.isEmpty());
        assertTrue(plugin.pendingOperation.isBusy());
    }
}
