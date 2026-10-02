package br.com.jylabtech.elgin_payment_tech.core;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;

/** MethodChannel.Result de teste que registra cada resposta recebida. */
public class RecordingResult implements MethodChannel.Result {
    public final List<String> calls = new ArrayList<>();
    public Object value;
    public String errorCode;
    public String errorMessage;

    @Override
    public void success(Object result) {
        calls.add("success");
        value = result;
    }

    @Override
    public void error(String code, String message, Object details) {
        calls.add("error");
        errorCode = code;
        errorMessage = message;
    }

    @Override
    public void notImplemented() {
        calls.add("notImplemented");
    }
}
