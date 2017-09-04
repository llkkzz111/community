# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in E:\android-sdk-windows/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
-keepclassmembers class fqcn.of.javascript.interface.for.webview {
   public *;
}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

#忽略警告
-ignorewarnings
# 指定代码的压缩级别
-optimizationpasses 5
# 不使用大小写混合
-dontusemixedcaseclassnames
# 混淆第三方jar
-dontskipnonpubliclibraryclasses
# 混淆时不做预校验
-dontpreverify
 # 混淆时记录日志
-verbose
 # 混淆时所采用的算法
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

-dontoptimize

# 保持哪些类不被混淆：四大组件，应用类，配置类等等
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Fragment
-keep public class * extends android.support.v4.app.FragmentActivity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class com.android.vending.licensing.ILicensingService

# 保持 native 方法不被混淆
-keepclasseswithmembernames class * {
    native <methods>;
}

-keep public class com.ocj.oms.utils.**.**{*;}
-keep public class com.ocj.oms.view.**.**{*;}
-keep public class com.ocj.oms.mobile.bean.**{*;}
-keep public class com.ocj.oms.mobile.db.**{*;}
-keep public class com.ocj.oms.utils.**.**{*;}
-keep public class com.ocj.oms.mobile.utils.**{*;}
-keep public class com.ocj.oms.mobile.view.**{*;}
-keep public class com.ocj.oms.mobile.db.**{*;}
-keep public class com.ocj.oms.view.**{*;}
-keep public class com.ocj.oms.rn.**{*;}
-keep public class com.ocj.oms.mobile.third.**.**{*;}
-keep public class com.learnium.RNDeviceInfo.**{*;}
-keep public class com.oblador.vectoricons.**{*;}
-keep public class com.reactnativecomponent.**.**{*;}
-keep public class com.ocj.oms.mobile.base.**{*;}
-keep public class com.ocj.oms.mobile.ui.fragment.**{*;}
-keep public class com.ocj.oms.mobile.ui.webview.**{*;}
-keep public class com.ocj.oms.mobile.ui.rn.**{*;}
-keep public class com.ocj.oms.common.image.**{*;}
-keep public class me.codeboy.android.aligntextview.**.**{*;}
-keep public class com.ocj.oms.common.net.mode.ApiResult{*;}
# 保持自定义控件类不被混淆
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

 # 保持自定义控件类不被混淆
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# 保持自定义控件类不被混淆
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}
#-------------------------START: webview------------------------------------
-keepclassmembers class com.ocj.oms.mobile.ui.webview.WebViewActivity{
    public *;
}
-keepclassmembers class com.ocj.oms.mobile.ui.personal.order.H5PayActivity{
    public *;
}
#-------------------------END: webview------------------------------------

#-------------------------START: nactive------------------------------------
-keepattributes Exceptions
-keepattributes Signature
-keepattributes EnclosingMethod
-keepattributes *Annotation*
-keepattributes *JavascriptInterface*

-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}

#-------------------------END: nactive------------------------------------

#-------------------------START: enum------------------------------------
# 保持枚举 enum 类不被混淆
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
#-------------------------END: enum------------------------------------

#-------------------------START: Parcelable------------------------------------
# 保持 Parcelable 不被混淆
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}
#-------------------------END: Parcelable------------------------------------

#-------------------------START: Serializable------------------------------------
# 保持 Serializable 不被混淆
-keep class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
#-------------------------END: Serializable------------------------------------


#---------------------BEGIN:TD----------------------------
-libraryjars libs/ocjhttps_Analytics_Android_SDK_V2.2.48.jar
-dontwarn com.tendcloud.tenddata.**
-keep  class com.tendcloud.tenddata.** { *;}
#---------------------END:TD----------------------------


-dontwarn com.ocj.store.OcjStoreDataAnalytics.**
-keep  class com.ocj.store.OcjStoreDataAnalytics.** { *;}

-dontwarn com.ocj.store.OcjStoreDataAnalytics.**.**
-keep  class com.ocj.store.OcjStoreDataAnalytics.**.** { *;}






