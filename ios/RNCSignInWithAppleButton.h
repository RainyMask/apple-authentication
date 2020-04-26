#import <React/RCTComponent.h>
#import <AuthenticationServices/AuthenticationServices.h>

@interface RNCSignInWithAppleButton : ASAuthorizationAppleIDButton

@property (nonatomic, copy) RCTBubblingEventBlock onPress;

@end
