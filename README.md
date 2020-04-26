# Apple Authentication for React Native

---

### 1、add the lines into package.json file

`"apple-authentication": "github:RainyMask/apple-authentication",`

### 2、run "npm install"

### 3、run "cd ios && pod install"

### 4、use this in code, exampale:

`import {
    SignInWithApple,
    SignInWithAppleButton,
} from 'apple-authentication';`


`<SignInWithAppleButton style={{ height: 44, width: 200 }} onPress={this.signIn} />`



	signIn = async () => {
       try {
            const result = await SignInWithApple.requestAsync({
                scopes: [SignInWithApple.Scope.FULL_NAME, SignInWithApple.Scope.EMAIL],
            });
            console.warn(result);
        } catch (err) {
            console.error(err);
        }
	};
