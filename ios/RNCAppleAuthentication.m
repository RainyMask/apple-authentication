
#import "RNCAppleAuthentication.h"
#import <React/RCTUtils.h>

@implementation RNCAppleAuthentication

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

- (NSDictionary *)constantsToExport
{
    if (@available(iOS 13.0, *)) {
        NSDictionary* scopes = @{@"FULL_NAME": ASAuthorizationScopeFullName, @"EMAIL": ASAuthorizationScopeEmail};
        
        NSDictionary* operations = @{
          @"LOGIN": ASAuthorizationOperationLogin,
          @"REFRESH": ASAuthorizationOperationRefresh,
          @"LOGOUT": ASAuthorizationOperationLogout,
          @"IMPLICIT": ASAuthorizationOperationImplicit
        };
        
        NSDictionary* credentialStates = @{
          @"AUTHORIZED": @(ASAuthorizationAppleIDProviderCredentialAuthorized),
          @"REVOKED": @(ASAuthorizationAppleIDProviderCredentialRevoked),
          @"NOT_FOUND": @(ASAuthorizationAppleIDProviderCredentialNotFound),
        };
        
        NSDictionary* userDetectionStatuses = @{
          @"LIKELY_REAL": @(ASUserDetectionStatusLikelyReal),
          @"UNKNOWN": @(ASUserDetectionStatusUnknown),
          @"UNSUPPORTED": @(ASUserDetectionStatusUnsupported),
        };
        
        return @{
            @"Scope": scopes,
            @"Operation": operations,
            @"CredentialState": credentialStates,
            @"UserDetectionStatus": userDetectionStatuses
        };
    } else {
        return @{};
    }
}

RCT_EXPORT_METHOD(requestAsync:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    
    _promiseResolve = resolve;
    _promiseReject = reject;
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = options[@"requestedScopes"];
        //
        if (options[@"requestedOperation"]) {
          appleIDRequest.requestedOperation = options[@"requestedOperation"];
        }
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    } else {
        // 处理不支持系统版本
        NSLog(@"该系统版本不可用Apple登录");
    }
}


#pragma mark - delegate
//@optional 授权成功回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    
    ASAuthorizationAppleIDCredential* credential = authorization.credential;
    NSDictionary* user = @{
                         @"fullName": RCTNullIfNil(credential.fullName),
                         @"email": RCTNullIfNil(credential.email),
                         @"user": credential.user,
                         @"authorizedScopes": credential.authorizedScopes,
                         @"realUserStatus": @(credential.realUserStatus),
                         @"state": RCTNullIfNil(credential.state),
                         @"authorizationCode": RCTNullIfNil(credential.authorizationCode),
                         @"identityToken": RCTNullIfNil(credential.identityToken)
                         };
//    // 服务器验证需要使用的参数
//    NSString *identityTokenStr = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
//    NSString *authorizationCodeStr = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
//    NSLog(@"%@\n\n%@", identityTokenStr, authorizationCodeStr);
//    if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
//        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
//        // Sign in using an existing iCloud Keychain credential.
//        // 用户登录使用现有的密码凭证
//        ASPasswordCredential *passwordCredential = authorization.credential;
//        // 密码凭证对象的用户标识 用户的唯一标识
//        NSString *user = passwordCredential.user;
//        // 密码凭证对象的密码
//        NSString *password = passwordCredential.password;
//
//    }
    if (_promiseResolve) {
        _promiseResolve(user);
    }
}
// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSLog(@"Handle error：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
        default:
            break;
    }
    NSLog(@"%@", errorMsg);
    if (_promiseReject) {
        _promiseReject([NSString stringWithFormat:@"%ld", (long)error.code], errorMsg, error);
    }
}

// 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
     return RCTKeyWindow();
//    return [UIApplication sharedApplication].windows.lastObject;
}

@end
  
