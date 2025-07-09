package br.com.jylabtech.elgin_payment_tech.usecase;

import android.app.Activity;
import android.content.Intent;

public class ElginCustomUsecase {
    private final  String ELGIN_PATH = "com.elgin.e1.digitalhub.CUSTOM";

    private Activity mActivity;

    protected  final int ELGIN_REQUEST_CODE = 987699;

    public ElginCustomUsecase(Activity activity) {
        this.mActivity = activity;
    }

    public void configureBackgroud(String backgroundImage, String backgroundColor, String gradientStart, String gradientEnd) {
        Intent intent = new Intent(ELGIN_PATH);
        intent.putExtra("grupo", "application");

        if(backgroundImage != null) {
            intent.putExtra("logotipo", backgroundImage);
        }
        if(backgroundColor != null) {
            intent.putExtra("background", backgroundColor);
        }

        if(gradientStart != null) {
            intent.putExtra("gradienteInicio", gradientStart);
        }
        if(gradientEnd != null) {
            intent.putExtra("gradienteFim", gradientEnd);
        }
        mActivity.startActivity(intent);
    }

    public void configureCustomHeader(String buttonColor, String iconColor, String fontColor) {
        Intent intent = new Intent(ELGIN_PATH);
        intent.putExtra("grupo", "header");
        if(buttonColor != null) {
            intent.putExtra("corBotao", buttonColor);
        }
        if(iconColor != null) {
            intent.putExtra("corIcone", iconColor);
        }
        if(fontColor != null) {
            intent.putExtra("corFonte", fontColor);
        }

        mActivity.startActivityForResult(intent, ELGIN_REQUEST_CODE);
    }

    public void configureIconsCenter(String buttonColor, String iconColor, String fontColor, String fontColorMessage) {
        Intent intent = new Intent(ELGIN_PATH);
        intent.putExtra("grupo", "content");
        if(buttonColor != null) {
            intent.putExtra("corBotao", buttonColor);
        }
        if(iconColor != null) {
            intent.putExtra("corIcone", iconColor);
        }
        if(fontColor != null) {
            intent.putExtra("corFonte", fontColor);
        }
        if(fontColorMessage != null) {
            intent.putExtra("corFonteMensagem", fontColorMessage);
        }
        mActivity.startActivityForResult(intent, ELGIN_REQUEST_CODE);
    }

    public void customClear() {
        Intent intent = new Intent(ELGIN_PATH);
        intent.putExtra("funcao", "clear");
        mActivity.startActivityForResult(intent, ELGIN_REQUEST_CODE);
    }
}
