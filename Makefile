release: resources
	cordova clean android
	# seem to need next line to plumb config.json:versionname into "About"
	ionic platform remove android && ionic platform add android
	cordova build --release android
	cd deploy-keys; rm -f birkbeck.apk; \
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore app-name-release-key.keystore ../platforms/android/build/outputs/apk/android-release-unsigned.apk slapp; \
	zipalign -v 4 ../platforms/android/build/outputs/apk/android-release-unsigned.apk birkbeck.apk

debug:
	cordova build android
	cd deploy-keys; rm -f birkbeck.apk; \
	zip -d ../platforms/android/build/outputs/apk/android-debug.apk META-INF/\*; \
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore app-name-release-key.keystore ../platforms/android/build/outputs/apk/android-debug.apk birkbeck

resources: resources/icon.png resources/splash.png
	rm -rf resources/android
	ionic resources
