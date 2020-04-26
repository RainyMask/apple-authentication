
#import <React/RCTBridgeModule.h>
#import <AuthenticationServices/AuthenticationServices.h>

@interface RNCAppleAuthentication : NSObject <RCTBridgeModule, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

// TODO use promise wrapper like in google sign in
@property (nonatomic, strong) RCTPromiseResolveBlock promiseResolve;
@property (nonatomic, strong) RCTPromiseRejectBlock promiseReject;

@end
  
