package br.com.jylabtech.elgin_payment_tech;

import static android.app.Activity.RESULT_CANCELED;
import static android.app.Activity.RESULT_OK;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.gson.Gson;
import br.com.jylabtech.elgin_payment_tech.core.ElginPaymentTech;
import br.com.jylabtech.elgin_payment_tech.core.PendingOperation;

import java.util.ArrayList;
import java.util.List;


import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;

public class ElginPaymentTechPlugin
  implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  private static final String CHANNEL_NAME = "elgin_payment_tech";

  private TefResponse tefResponse;
  private MethodChannel channel;
  private MethodChannel mChannelNotification;
  private Context context;
  private Activity activity;
  private ElginPaymentTech elginPayment;

  /** Result da operação em andamento: uma por vez, respondida uma única vez. */
  final PendingOperation pendingOperation = new PendingOperation();

  private int startModalidade;

  Gson gson = null;

    protected class RequestCode {
        protected static final int PERFORM_TRANSACTION_ELGIN = 9876;
        protected static final int PERFORM_ELGIN_STYLE = 987699;
    }

    private static final int PERMISSION_ANDROID = 1000;
    public static int ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE = 5469;
    
  public ElginPaymentTechPlugin() {}

  public void checkElginPaymentTech() {
    if(context != null  && channel != null && activity != null) {
      if(elginPayment == null) {
      elginPayment = new ElginPaymentTech(context, channel, activity);
    }
  }
  }

  private Gson getGson() {
    if (gson == null) {
      gson = new Gson();
    }
    return gson;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
    mChannelNotification = new MethodChannel(binding.getBinaryMessenger(), "samples.flutter.dev/flutterGBot");
    context = binding.getApplicationContext();
    channel.setMethodCallHandler(this);

    checkElginPaymentTech();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    binding.addActivityResultListener(this);
    Log.d("ElginPaymentTechPlugin", "**** onAttachedToActivity: Listener registrado");
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    this.activity = null;
    // Recria com a nova Activity no próximo uso (a operação pendente continua aguardando o resultado).
    this.elginPayment = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
    this.elginPayment = null;
    pendingOperation.error(ElginPaymentTech.ELGIN_ERROR, "Activity encerrada antes da resposta do Elgin IDH.", null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (!ElginPaymentTech.isKnownMethod(call.method)) {
        result.notImplemented();
        return;
    }

    // O TEF processa uma operação por vez: recusa uma nova enquanto outra aguarda resposta,
    // sem afetar a chamada em andamento.
    final Result operationResult = pendingOperation.start(result);
    if (operationResult == null) {
        result.error(PendingOperation.ELGIN_BUSY, PendingOperation.BUSY_MESSAGE, null);
        return;
    }

    try {
        checkElginPaymentTech();
        if(elginPayment != null) {
            // Chama o Elgin IDH direto; a resposta chega em onActivityResult.
            elginPayment.initPayment(call, operationResult);
        } else {
            operationResult.error(ElginPaymentTech.ELGIN_ERROR, "Plugin Elgin não está pronto (Activity não anexada).", null);
        }
    } catch (Exception e) {
        Log.e("ElginPaymentTechPlugin", "Erro em " + call.method, e);
        operationResult.error(ElginPaymentTech.ELGIN_ERROR, e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName(), null);
    }
  }
  
  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    pendingOperation.error(ElginPaymentTech.ELGIN_ERROR, "Plugin desanexado antes da resposta do Elgin IDH.", null);
    channel.setMethodCallHandler(null);
    channel = null;
    mChannelNotification = null;
    tefResponse = null;
    elginPayment = null;
  }

  public void respMSitefToJson(Intent data) {
    tefResponse.setResultCodeMsitef(data.getStringExtra("CODRESP"));
    tefResponse.setTransactionConfirmation(data.getStringExtra("COMP_DADOS_CONF"));
    tefResponse.setTefCodAuthorization(data.getStringExtra("COD_AUTORIZACAO"));
    tefResponse.setTefNSUSitef(data.getStringExtra("NSU_SITEF"));
    tefResponse.setTefNSUAuthorizing(data.getStringExtra("NSU_HOST"));
    tefResponse.setEstablishmentReceipt(data.getStringExtra("VIA_ESTABELECIMENTO"));
    tefResponse.setCustomerReceipt(data.getStringExtra("VIA_CLIENTE"));
    tefResponse.setTefCodPayment(data.getStringExtra("CODTRANS"));
    tefResponse.setTypeFields(data.getStringExtra("TIPO_CAMPOS"));
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if(requestCode == RequestCode.PERFORM_ELGIN_STYLE) {
            pendingOperation.success(true);
            return true;
        }

        if(requestCode == RequestCode.PERFORM_TRANSACTION_ELGIN) {
            String response = null;
            try {
                if(data != null) {
                    checkTefResponse();
                    respMSitefToJson(data);

                    List<String> extraValues = new ArrayList<>();
                    Bundle extras = data.getExtras();
                    if (extras != null) {
                        for (String key : extras.keySet()) {
                            String responseElgin = String.valueOf(extras.get(key));
                            Log.d("IntentData","****ValueObject: " + responseElgin);
                            extraValues.add(responseElgin);
                        }
                    }
                    response = PendingOperation.pickTefResponse(extraValues, data.getStringExtra("jsonResp"));
                }
            } catch (Exception e) {
                Log.e("ElginPaymentTechPlugin", "Erro ao ler resposta do Elgin IDH", e);
            }

            // Sempre responde uma única vez: sem resposta (ex.: cancelado no IDH) vira ELGIN_ERROR.
            if (response != null) {
                pendingOperation.success(response);
            } else {
                pendingOperation.error(ElginPaymentTech.ELGIN_ERROR,
                        "Operação cancelada ou sem resposta do Elgin IDH.", null);
            }
            return true;
        }

        if (requestCode == 4713) {
            if (resultCode == RESULT_OK && data != null) {
                pendingOperation.success(data.getStringExtra("jsonResp"));
                handlerELgin(data.getStringExtra("jsonResp"));
            } else {
                pendingOperation.error(ElginPaymentTech.ELGIN_ERROR,
                        "Operação cancelada ou sem resposta do Elgin IDH.", null);
            }
            return true;
        }
        return false;
    }

  private void handlerELgin(String value) {
    mChannelNotification.invokeMethod("onFinishedResponse", value);
  }

    private void checkTefResponse() {
        if(tefResponse == null) {
            tefResponse = new TefResponse();
        }
    }
}
