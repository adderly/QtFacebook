DEFINES += FB_IOS_GLUE

INCLUDEPATH += $$PWD

SOURCES += \
        $$PWD/qfacebook.cpp

HEADERS += \
	$$PWD/qfacebook.h

    #DEFINES += QFACEBOOK_NOT_DEFINE_JNI_ONLOAD
    #DEFINES += QFACEBOOK_NOT_DEFINE_IOS_URL_HANDLER
ios{
    DEFINES += QFACEBOOK_SDK_4
    CONFIG += fb_sdk4
}
android {
	QT += androidextras
        SOURCES += $$PWD/qfacebook_android.cpp \
                   $$PWD/qfacebook_android_sdk4.cpp

        fb_sdk4{
            INCLUDEPATH +=$$PWD/plugin/android/jni/
            INCLUDEPATH +=$$PWD/plugin/android/jni/sdkbox
            INCLUDEPATH +=$$PWD/plugin/android/jni/pluginfacebook/
            LIBS += $$PWD/plugin/android/jni/sdkbox/libs/$$ANDROID_TARGET_ARCH/
            LIBS += $$PWD/plugin/android/jni/pluginfacebook/libs/$$ANDROID_TARGET_ARCH/
        }

	QFACEBOOK_JAVASRC.path = /src/org/gmaxera/qtfacebook
	QFACEBOOK_JAVASRC.files += $$files($$PWD/Android/src/org/gmaxera/qtfacebook/*)
        INSTALLS += QFACEBOOK_JAVASRC
} else:ios {
	## the objective sources should be put in this variable
        fb_sdk4 {
            LIBS += -F$$PWD/plugin/ios/ -framework FBSDKCoreKit
            LIBS += -F$$PWD/plugin/ios/ -framework FBSDKLoginKit
            LIBS += -F$$PWD/plugin/ios/ -framework FBSDKShareKit
            LIBS += -F$$PWD/plugin/ios/ -framework PluginFacebook
            LIBS += -F$$PWD/plugin/ios/ -framework sdkbox
        }

#        QMAKE_CXXFLAGS += -fno-objc-arc
	OBJECTIVE_SOURCES += \
                $$PWD/qfacebook_ios.mm \ #-fno-objc-arc
                $$PWD/qfacebook_ios_sdk4.mm
} else {
	SOURCES += \
		$$PWD/qfacebook_desktop.cpp
}

OTHER_FILES += \
        $$PWD/README.md \
        $$files($$PWD/Android/src/org/gmaxera/qtfacebook/*)

OBJECTIVE_SOURCES += \
    $$PWD/IOSGlue.mm


