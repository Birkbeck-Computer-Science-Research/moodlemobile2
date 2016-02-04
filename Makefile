release:
	cordova build --release android
	cd deploy-keys; rm -f slapp.apk; \
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore app-name-release-key.keystore ../platforms/android/build/outputs/apk/android-release-unsigned.apk slapp; \
	zipalign -v 4 ../platforms/android/build/outputs/apk/android-release-unsigned.apk slapp.apk

debug:
	cordova build android
	cd deploy-keys; rm -f slapp.apk; \
	zip -d ../platforms/android/build/outputs/apk/android-debug.apk META-INF/\*; \
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore app-name-release-key.keystore ../platforms/android/build/outputs/apk/android-debug.apk slapp
