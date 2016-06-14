release: resources gulp
	#cordova clean android
	# make www/build
	ionic build --release android
	cd deploy-keys; rm -f birkbeck.apk; \
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore app-name-release-key.keystore ../platforms/android/build/outputs/apk/android-release-unsigned.apk slapp; \
	zipalign -v 4 ../platforms/android/build/outputs/apk/android-release-unsigned.apk birkbeck.apk

ios: resources gulp
	ionic build --release ios

debug: resources gulp
	ionic build android
	cd deploy-keys; rm -f birkbeck-debug.apk; \
	zip -d ../platforms/android/build/outputs/apk/android-debug.apk META-INF/\*; \
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore app-name-release-key.keystore ../platforms/android/build/outputs/apk/android-debug.apk slapp; \
	zipalign -v 4 ../platforms/android/build/outputs/apk/android-debug.apk birkbeck-debug.apk


resources: resources/icon.png resources/splash.png
	rm -rf resources/android
	ionic resources

gulp:
		gulp