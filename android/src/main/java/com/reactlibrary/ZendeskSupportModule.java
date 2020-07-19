package com.reactlibrary;

import android.content.Context;
import android.content.Intent;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;
import com.zendesk.service.ErrorResponse;
import com.zendesk.service.ZendeskCallback;
import zendesk.core.Zendesk;
import zendesk.core.Identity;
import zendesk.core.AnonymousIdentity;
import zendesk.core.JwtIdentity;
import zendesk.support.Support;
import zendesk.support.request.RequestActivity;
import zendesk.support.requestlist.RequestListActivity;

public class ZendeskSupportModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public ZendeskSupportModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ZendeskSupport";
    }

    @ReactMethod
    public void initialize(ReadableMap params) {

        String appId = params.getString("appId");
        String zendeskUrl = params.getString("zendeskUrl");
        String clientId = params.getString("clientId");

        Zendesk.INSTANCE.init(getCurrentActivity(), zendeskUrl, appId, clientId);
        Support.INSTANCE.init(Zendesk.INSTANCE);

    }

    @ReactMethod
    public void setAnonymousIdentity(ReadableMap params) {

        String email = params.getString("email");
        String name = params.getString("name");

        Identity identity = new AnonymousIdentity.Builder()
        .withNameIdentifier(name)
        .withEmailIdentifier(email)
        .build();
        Zendesk.INSTANCE.setIdentity(identity);

    }

    @ReactMethod
    public void setJwtIdentity(ReadableMap params) {
        
        String token = params.getString("token");

        Identity identity = new JwtIdentity(token);
        Zendesk.INSTANCE.setIdentity(identity);

    }

    @ReactMethod
    public void showRequestRequestList() {
        
        RequestListActivity.builder()
        .show(getCurrentActivity());

    }

    @ReactMethod
    public void showRequestUi() {
        
        RequestActivity.builder()
        .show(getCurrentActivity());

    }

    @ReactMethod
    public void showRequestUiWithRequestId(ReadableMap params) {
        
        String requestId = params.getString("requestId");

        RequestActivity.builder()
        .withRequestId(requestId)
        .show(getCurrentActivity());

    }

    @ReactMethod
    public void registerWithDeviceIdentifier(ReadableMap params, final Promise promise) {
        
        String identifier = params.getString("identifier");

        Zendesk.INSTANCE.provider().pushRegistrationProvider().registerWithDeviceIdentifier(identifier, new ZendeskCallback<String>() {
            @Override
            public void onSuccess(String result) {
                promise.resolve(result);
            }
        
            @Override
            public void onError(ErrorResponse errorResponse) {
                promise.reject("failed", "failed to register with device identifier");
            }
        });

    }
}
