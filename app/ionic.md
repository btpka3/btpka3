http://ionicframework.com/getting-started/

```
npm install -g cordova ionic
ionic start myApp sidemenu
cd myApp
ionic platform add android

vi platforms/android/project.properties
#target=android-22
target=android-21

ionic build android
ionic emulate --target=test2 android
```


#

```bash
ionic start --no-cordova my-ionic3 blank
cd my-ionic3
ionic cordova platform ls
ionic cordova platform add browser
ionic cordova build --platform browser --target cordova
```
