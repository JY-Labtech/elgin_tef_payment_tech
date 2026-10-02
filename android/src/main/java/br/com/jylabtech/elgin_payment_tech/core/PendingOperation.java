package br.com.jylabtech.elgin_payment_tech.core;

import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.plugin.common.MethodChannel;

/**
 * Guarda o {@link MethodChannel.Result} da única operação Elgin em andamento.
 *
 * O Elgin IDH processa uma operação por vez e a resposta chega depois, em
 * {@code onActivityResult}. Por isso:
 * <ul>
 *   <li>uma nova operação enquanto outra está pendente é recusada com {@link #ELGIN_BUSY}
 *   (a chamada anterior não é afetada);</li>
 *   <li>cada chamada é respondida exatamente uma vez, sempre no seu próprio {@code Result}:
 *   respostas repetidas ou atrasadas são descartadas.</li>
 * </ul>
 */
public final class PendingOperation {
    public static final String ELGIN_BUSY = "ELGIN_BUSY";
    public static final String BUSY_MESSAGE =
            "Já existe uma operação Elgin em andamento. Aguarde a resposta antes de iniciar outra.";

    private final AtomicReference<MethodChannel.Result> pending = new AtomicReference<>();

    /**
     * Reserva o canal para {@code result}.
     *
     * @return um {@code Result} vinculado a esta chamada (responde uma única vez e libera o canal),
     * ou {@code null} se já houver uma operação em andamento.
     */
    public MethodChannel.Result start(final MethodChannel.Result result) {
        if (result == null || !pending.compareAndSet(null, result)) {
            return null;
        }
        return new MethodChannel.Result() {
            @Override
            public void success(Object value) {
                if (pending.compareAndSet(result, null)) {
                    result.success(value);
                }
            }

            @Override
            public void error(String errorCode, String errorMessage, Object errorDetails) {
                if (pending.compareAndSet(result, null)) {
                    result.error(errorCode, errorMessage, errorDetails);
                }
            }

            @Override
            public void notImplemented() {
                if (pending.compareAndSet(result, null)) {
                    result.notImplemented();
                }
            }
        };
    }

    public boolean isBusy() {
        return pending.get() != null;
    }

    /** Responde com sucesso a operação pendente. Retorna {@code false} se não havia nenhuma. */
    public boolean success(Object value) {
        MethodChannel.Result result = pending.getAndSet(null);
        if (result == null) {
            return false;
        }
        result.success(value);
        return true;
    }

    /** Responde com erro a operação pendente. Retorna {@code false} se não havia nenhuma. */
    public boolean error(String errorCode, String errorMessage, Object errorDetails) {
        MethodChannel.Result result = pending.getAndSet(null);
        if (result == null) {
            return false;
        }
        result.error(errorCode, errorMessage, errorDetails);
        return true;
    }

    /**
     * Escolhe a resposta única de uma transação TEF: o primeiro extra que contém "funcao"
     * (comportamento histórico) ou, se não houver, o {@code jsonResp}. {@code null} se nenhum.
     */
    public static String pickTefResponse(List<String> extraValues, String jsonResp) {
        if (extraValues != null) {
            for (String value : extraValues) {
                if (value != null && value.contains("funcao")) {
                    return value;
                }
            }
        }
        return jsonResp;
    }
}
