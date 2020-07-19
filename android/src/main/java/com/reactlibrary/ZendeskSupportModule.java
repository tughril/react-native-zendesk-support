package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import zendesk.support.request.RequestActivity;

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

        Zendesk.INSTANCE.init(getReactApplicationContext(), zendeskUrl, appId, clientId);

    }

    @ReactMethod
    public void setAnonymousIdentity(ReadableMap params) {

        String email = params.getString("email");
        String name = params.getString("name");

        Identity identity = new AnonymousIdentity.Builder()
        .withNameIdentifier(name)
        .withEmailIdentifier(email)
        .build();

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
        .show(getReactApplicationContext());

    }

    @ReactMethod
    public void showRequestUi() {
        
        RequestActivity.builder()
        .show(getReactApplicationContext());

    }

    @ReactMethod
    public void showRequestUiWithRequestId(ReadableMap params) {
        
        String requestId = params.getString("requestId");

        RequestActivity.builder()
        .withRequestId(requestId)
        .show(getReactApplicationContext());

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
