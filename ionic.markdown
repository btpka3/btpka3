http://ionicframework.com/getting-started/

```
npm install -g cordova ionic
ionic start myApp sidemenu
cd myApp
ionic platform add android

vi platforms/android/project.properties
#target=android-22
target=android-17

ionic build android
ionic emulate android
```