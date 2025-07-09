package br.com.jylabtech.elgin_payment_tech.usecase;


import android.app.Activity;
import android.content.Intent;
import android.util.Log;

public class ElginTefUsecase {

    private Intent intentElgin;
    private Activity mActivity;

     private final int ELGIN_REQUEST_CODE = 9876;


    public ElginTefUsecase(Activity activity) {
        this.mActivity = activity;
    }


    private void inicializeIntentElgin() {
        if (intentElgin == null) {
            try {
                intentElgin = new Intent("com.elgin.e1.digitalhub.TEF");
            } catch (Exception e) {
            }
        }

        intentElgin = new Intent("com.elgin.e1.digitalhub.TEF");
    }

    public void setActivity(Activity activity) {
        this.mActivity = activity;
    }

    public void configurePinpad(String name, String version, String textPinpad) {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "configurar");
        intentElgin.putExtra("nome", name);
        intentElgin.putExtra("versao", version);
        intentElgin.putExtra("textoPinpad", textPinpad);
        mActivity.startActivityForResult(intentElgin, ELGIN_REQUEST_CODE);
    }

    public void activeTerminal(String companyDocument) {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "ativar");
        intentElgin.putExtra("cnpjCpf", companyDocument);
        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }

    public void creditCardParcTransaction(String value, String parc, String financ) {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "credito");
        intentElgin.putExtra("valor", value);
        intentElgin.putExtra("numParcelas", parc);
        intentElgin.putExtra("financiamento", financ);
        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }

    public void creditCardTransaction(String value) {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "credito");
        intentElgin.putExtra("valor", value);
        intentElgin.putExtra("transacoesHabilitadas", "26");
        intentElgin.putExtra("numParcelas", "1");
        intentElgin.putExtra("tipoPinpad", "ANDROID_USB");
        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }

    public void debitCardTransaction(String value) {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "debito");
        intentElgin.putExtra("valor", value);
        intentElgin.putExtra("transacoesHabilitadas", "16");
        intentElgin.putExtra("numParcelas", "");
       intentElgin.putExtra("tipoPinpad", "ANDROID_USB");
        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }

    public void pixTransaction(String value) {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "pix");
        intentElgin.putExtra("valor", value);

        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }

    public void refundTransaction(String value, String nsu, String date) {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "cancelar");
        intentElgin.putExtra("valor", value);
        intentElgin.putExtra("NSU_SITEF", nsu);
        intentElgin.putExtra("data", date);
        intentElgin.putExtra("modalidade", "200");
        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }

    public void reprintTransaction() {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "reimprimir");
        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }

    public void reportTransaction() {
        inicializeIntentElgin();

        intentElgin.putExtra("funcao", "relatorio");
        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }

    public void sale() {
        inicializeIntentElgin();
        intentElgin.putExtra("funcao", "vender");
        mActivity.startActivityForResult(intentElgin,ELGIN_REQUEST_CODE);
    }
}
