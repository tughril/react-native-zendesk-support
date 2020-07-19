// RN < 0.40 suppoert
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTConvert.h>
#else
#import "RCTConvert.h"
#endif

#import "RNZendeskSupport.h"
#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import <SupportSDK/SupportSDK.h>

@implementation RNZendeskSupport

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initialize:(NSDictionary *)params){
    NSString *appId = [RCTConvert NSString:params[@"appId"]];
    NSString *zendeskUrl = [RCTConvert NSString:params[@"zendeskUrl"]];
    NSString *clientId = [RCTConvert NSString:params[@"clientId"]];
    
    [ZDKZendesk initializeWithAppId:appId clientId:clientId zendeskUrl:zendeskUrl];
    [ZDKSupport initializeWithZendesk:[ZDKZendesk instance]];

}

RCT_EXPORT_METHOD(setIdentity:(NSDictionary *)params){
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *email = [RCTConvert NSString:params[@"email"]];
        NSString *name = [RCTConvert NSString:params[@"name"]];
        
        id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:nil email:nil];
        [[ZDKZendesk instance] setIdentity:userIdentity];
        
    });
}

RCT_EXPORT_METHOD(setIdentityWithJwt:(NSDictionary *)params){
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *token = [RCTConvert NSString:params[@"token"]];
        NSLog(@"%@", @"token");
        NSLog(@"%@", token);
        
        id<ZDKObjCIdentity> userIdentity = [[ZDKObjCJwt alloc] initWithToken:token];
        [[ZDKZendesk instance] setIdentity:userIdentity];
        
    });
}

RCT_EXPORT_METHOD(showRequestRequestList){
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIViewController *requestScreen = [ZDKRequestUi buildRequestList];
        UIViewController *nav = [[UINavigationController alloc] initWithRootViewController:requestScreen];
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        [vc presentViewController:nav animated:true completion:nil];

    });
}

RCT_EXPORT_METHOD(showRequestUi) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIViewController *requestScreen = [ZDKRequestUi buildRequestUiWith:@[]];
        UIViewController *nav = [[UINavigationController alloc] initWithRootViewController:requestScreen];
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        [vc presentViewController:nav animated:true completion:nil];

    });
}

RCT_EXPORT_METHOD(showRequestWithRequestId:(NSDictionary *)params) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *requestId = [RCTConvert NSString:params[@"requestId"]];
        
        UIViewController *requestScreen = [ZDKRequestUi buildRequestUiWithRequestId:requestId];
        UIViewController *nav = [[UINavigationController alloc] initWithRootViewController:requestScreen];
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        [vc presentViewController:nav animated:true completion:nil];

    });
}

RCT_EXPORT_METHOD(registerWithDeviceIdentifier:(NSDictionary *)params
                  withResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *identifier = [RCTConvert NSString:params[@"identifier"]];
        NSString *locale = [[NSLocale preferredLanguages] firstObject];
        
        [[[ZDKPushProvider alloc] initWithZendesk:[ZDKZendesk instance]] registerWithDeviceIdentifier:identifier locale:locale completion:^(NSString * _Nullable registrationResponse, NSError * _Nullable error) {
          if (error) {
            reject(@"error", @"failed to register with device identifier", error);
          } else if (registrationResponse) {
            resolve(registrationResponse);
          }
        }];

    });

}

RCT_EXPORT_METHOD(getRequestIdsByStatus:(NSDictionary *)params
                  withResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *status = [RCTConvert NSString:params[@"status"]];
        
        ZDKRequestProvider *provider = [ZDKRequestProvider new];
        [provider getRequestsByStatus:status withCallback:^(ZDKRequestsWithCommentingAgents *requestsWithCommentingAgents, NSError *error) {
            if (error) {
                reject(@"error", @"failed to get requests ids by status", error);
            } else if (requestsWithCommentingAgents) {
                NSMutableArray *requestIds = [NSMutableArray arrayWithCapacity:requestsWithCommentingAgents.requests.count];
                [requestsWithCommentingAgents.requests enumerateObjectsUsingBlock:^(ZDKRequest *request, NSUInteger idx, BOOL *stop) {
                    [requestIds addObject:request.requestId];
                }];
                resolve(requestIds);
            }
        }];

    });

}

@end
