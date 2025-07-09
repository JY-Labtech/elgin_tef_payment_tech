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


import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
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

  public static MethodChannel.Result _result;

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
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    _result = result;
    checkElginPaymentTech();
    if(elginPayment != null) {
      elginPayment.initPayment(call, result);
    } 
  }
  
  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
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
        checkTefResponse();

        if(requestCode == RequestCode.PERFORM_ELGIN_STYLE) {
            _result.success(true);
        }
        if(requestCode == RequestCode.PERFORM_TRANSACTION_ELGIN) {
          try {
        assert data != null;
        String retorno = data.getStringExtra("retorno");
    } catch (Exception e) {
    
    }
            try {
            if(data != null ) {
                respMSitefToJson(data);
                String json = getGson().toJson(tefResponse);
                String testeData = data.getDataString();
                if (data.getStringExtra("retorno").equals("0")) {
                if (data.getStringExtra("erro") != null) {
                    String errorElgin = data.getStringExtra("erro");
                } else {
                    String elginMessage = data.getStringExtra("mensagem");
                }
            } else {
                String elginMessage = data.getStringExtra("mensagem");
            }
                String elginMessage3 = data.getStringExtra("funcao");
                String elginMessage4 = data.getStringExtra("resultado");
                String elginMessage5 = data.getStringExtra("CODRESP");
                
         


                Bundle extras = data.getExtras();
            if (extras != null) {
                for (String key : extras.keySet()) {
                    Object value = extras.get(key);
                    String responseElgin = String.valueOf(value);
                    Log.d("IntentData","****ValueObject: " + responseElgin);
                    if(responseElgin.contains("funcao")) {
                        _result.success(responseElgin);
                    }
                }
            }
            String jsonResponse = data.getStringExtra("jsonResp");
            if (jsonResponse != null) {
                _result.success(jsonResponse);
            } 
            }
            } catch (Exception e) {
                e.printStackTrace();
            }

            return true;
        }

        if (requestCode == 4713) {
            if (resultCode == RESULT_OK && data != null) {
                _result.success(data.getStringExtra("jsonResp"));
                handlerELgin(data.getStringExtra("jsonResp"));
            } else {
                _result.notImplemented();
            }
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
