package br.com.jylabtech.elgin_payment_tech.presenter;

import android.app.Activity;

import br.com.jylabtech.elgin_payment_tech.usecase.ElginCustomUsecase;

import io.flutter.plugin.common.MethodCall;

public class StylePresenter {
    private Activity mActivity;
    private ElginCustomUsecase mCustomUsecase;

    public StylePresenter(Activity activity) {
        this.mActivity = activity;
        this.mCustomUsecase = new ElginCustomUsecase(activity);
    }

    public void configureBackgroud(MethodCall call) {
        String logoPath = call.argument("logoPath");
        String backgroundColor = call.argument("backgroundColor");
        String gradientStartColor = call.argument("gradientStart");
        String gradientEndColor = call.argument("gradientEnd");

        mCustomUsecase.configureBackgroud(logoPath, backgroundColor, gradientStartColor, gradientEndColor);
    }

    public void configureCustomHeader(MethodCall call) {
        String buttonColor = call.argument("buttonColor");
        String iconColor = call.argument("iconColor");
        String fontColor = call.argument("fontColor");

        mCustomUsecase.configureCustomHeader(buttonColor, iconColor, fontColor);
    }

    public void configureIconsCenter(MethodCall call) {
        String buttonColor = call.argument("buttonColor");
        String iconColor = call.argument("iconColor");
        String fontColor = call.argument("fontColor");
        String fontMessageColor = call.argument("fontMessageColor");

        mCustomUsecase.configureIconsCenter(buttonColor, iconColor, fontColor, fontMessageColor);
    }

    public void clearAllStyle() {
        mCustomUsecase.customClear();
    }
}
