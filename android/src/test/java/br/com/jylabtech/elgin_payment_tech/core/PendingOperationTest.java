package br.com.jylabtech.elgin_payment_tech.core;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import java.util.Arrays;
import java.util.Collections;

import io.flutter.plugin.common.MethodChannel;

public class PendingOperationTest {

    @Test
    public void secondOperationIsRejectedWhileFirstIsPending() {
        PendingOperation pending = new PendingOperation();
        RecordingResult first = new RecordingResult();
        RecordingResult second = new RecordingResult();

        assertNotNull(pending.start(first));
        assertTrue(pending.isBusy());
        assertNull(pending.start(second));

        // A resposta do IDH vai para a primeira chamada, nunca para a segunda.
        assertTrue(pending.success("{\"funcao\":\"credito\"}"));
        assertEquals(Collections.singletonList("success"), first.calls);
        assertEquals("{\"funcao\":\"credito\"}", first.value);
        assertTrue(second.calls.isEmpty());
        assertFalse(pending.isBusy());
    }

    @Test
    public void eachCallIsAnsweredOnlyOnce() {
        PendingOperation pending = new PendingOperation();
        RecordingResult first = new RecordingResult();
        MethodChannel.Result bound = pending.start(first);

        assertTrue(pending.success("a"));
        assertFalse(pending.success("b"));
        assertFalse(pending.error("X", "y", null));
        bound.success("c");
        bound.error("X", "y", null);
        bound.notImplemented();

        assertEquals(Collections.singletonList("success"), first.calls);
        assertEquals("a", first.value);
    }

    @Test
    public void staleBoundResultDoesNotAnswerNextOperation() {
        PendingOperation pending = new PendingOperation();
        RecordingResult first = new RecordingResult();
        RecordingResult second = new RecordingResult();

        MethodChannel.Result firstBound = pending.start(first);
        firstBound.error(ElginPaymentTech.ELGIN_ERROR, "Operação cancelada", null);
        assertFalse(pending.isBusy());

        assertNotNull(pending.start(second));
        // Resposta atrasada da primeira chamada é descartada.
        firstBound.success("atrasada");
        assertTrue(second.calls.isEmpty());
        assertTrue(pending.isBusy());

        assertTrue(pending.success("ok"));
        assertEquals(Collections.singletonList("error"), first.calls);
        assertEquals(Collections.singletonList("success"), second.calls);
        assertEquals("ok", second.value);
    }

    @Test
    public void boundResultReleasesChannel() {
        PendingOperation pending = new PendingOperation();
        RecordingResult first = new RecordingResult();
        pending.start(first).success(true);
        assertFalse(pending.isBusy());
        assertSame(Boolean.TRUE, first.value);
        assertNotNull(pending.start(new RecordingResult()));
    }

    @Test
    public void nothingPendingIsNoop() {
        PendingOperation pending = new PendingOperation();
        assertFalse(pending.success("x"));
        assertFalse(pending.error("X", "y", null));
        assertNull(pending.start(null));
    }

    @Test
    public void busyErrorCode() {
        assertEquals("ELGIN_BUSY", PendingOperation.ELGIN_BUSY);
    }

    @Test
    public void pickTefResponseKeepsSingleAnswer() {
        assertEquals("{\"funcao\":\"credito\"}", PendingOperation.pickTefResponse(
                Arrays.asList("0", "{\"funcao\":\"credito\"}", "{\"funcao\":\"outro\"}"), "{\"json\":1}"));
        assertEquals("{\"json\":1}", PendingOperation.pickTefResponse(Arrays.asList("0", null), "{\"json\":1}"));
        assertNull(PendingOperation.pickTefResponse(null, null));
    }
}
