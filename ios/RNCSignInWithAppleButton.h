#import <React/RCTComponent.h>
#import <AuthenticationServices/AuthenticationServices.h>

API_AVAILABLE(ios(13.0))
@interface RNCSignInWithAppleButton : ASAuthorizationAppleIDButton

@property (nonatomic, copy) RCTBubblingEventBlock onPress;

@end
