#import "RNCSignInWithAppleButton.h"

@implementation RNCSignInWithAppleButton

-(instancetype)initWithAuthorizationButtonType:(ASAuthorizationAppleIDButtonType)type authorizationButtonStyle:(ASAuthorizationAppleIDButtonStyle)style API_AVAILABLE(ios(13.0)) {
  RNCSignInWithAppleButton* btn = [super initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeDefault authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleBlack];
  [btn addTarget:self action:@selector(onDidPress) forControlEvents:UIControlEventTouchUpInside];
  return btn;
}

-(void)onDidPress {
  _onPress(nil);
}

@end
