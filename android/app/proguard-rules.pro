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

#--------------- BEGIN: okhttp ----------
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontnote okhttp3.internal.**
#--------------- END: okhttp ----------
#--------------- BEGIN: okio ----------
-keep class sun.misc.Unsafe { *; }
-dontwarn java.nio.file.*
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn okio.**
#--------------- END: okio ----------
#--------------- BEGIN: wechat ----------
-keep class com.tencent.mm.sdk.** {
   *;
}
-keep class com.tencent.mm.sdk.**.** {*;}
#--------------- END: wechat ----------

#--------------- BEGIN: umeng ----------
-keep public class [com.ocj.oms.moile].R$*{
public static final int *;
}
#--------------- END: umeng ----------

#--------------- BEGIN: jpush ----------
-dontwarn cn.jpush.**
-keep class cn.jpush.** { *; }
#--------------- END: jpush ----------

#------------------BEGIN: gson--------------------------
-dontwarn com.google.**
-keep class com.google.gson.** {*;}
-dontnote com.google.gson.**.**
#------------------END: gson--------------------------

#------------------BEGIN: protobuf----------------------
-dontwarn com.google.**
-keep class com.google.protobuf.** {*;}
#------------------END: protobuf----------------------

#------------------BEGIN: greendao----------------------
-keep class de.greenrobot.dao.** {*;}
-keepclassmembers class * extends de.greenrobot.dao.AbstractDao {
    public static java.lang.String TABLENAME;
}
-keep class **$Properties
#------------------END: greendao----------------------

-dontwarn android.support.**.**
-keep class android.support.**.** { *; }
-dontnote android.support.**.**

-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keep class com.choudao.equity.api.MyCallBack {
    public <fields>;
    public <methods>;
}
-dontnote retrofit2.**
-dontnote com.facebook.stetho.**.**
#------------------BEGIN: alipay----------------------
#-libraryjars libs/alipaySDK-20150602.jar

-keep class com.alipay.android.app.IAlixPay{*;}
-keep class com.alipay.android.app.IAlixPay$Stub{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback$Stub{*;}
-keep class com.alipay.sdk.app.PayTask{ public *;}
-keep class com.alipay.sdk.app.AuthTask{ public *;}
#------------------END: alipay----------------------
#------------------BEGIN: QQ----------------------
-keep class com.tencent.open.TDialog$*
-keep class com.tencent.open.TDialog$* {*;}
-keep class com.tencent.open.PKDialog
-keep class com.tencent.open.PKDialog {*;}
-keep class com.tencent.open.PKDialog$*
-keep class com.tencent.open.PKDialog$* {*;}
#------------------END: QQ----------------------
#------------------BEGIN: 微信----------------------
-keep class com.tencent.mm.opensdk.** {
   *;
}
-keep class com.tencent.wxop.** {
   *;
}
-keep class com.tencent.mm.sdk.** {
   *;
}
-keep ,includedescriptorclasses class com.tencent.open.** {
   *;
}
#------------------END: 微信----------------------
#------------------BEGIN: unionpay----------------------
-keep class  com.unionpay.sdk.** { *; }
-keepclassmembers class  com.unionpay.sdk.** { *; }
-dontwarn  com.unionpay.sdk.**
#------------------END: unionpay----------------------
#------------------BEGIN: rxjava2----------------------
-dontwarn sun.misc.**
-keep class io.reactivex.**.** { *; }
-keepclassmembers class io.reactivex.**.** { *; }
-dontwarn io.reactivex.**.**
-keep ,includedescriptorclasses  class io.reactivex.** { *; }
-keepclassmembers class io.reactivex.** { *; }
-dontwarn io.reactivex.**
#------------------END: rxjava2----------------------

#------------------BEGIN: utilcode----------------------
-keep class com.blankj.utilcode.** { *; }
-keepclassmembers class com.blankj.utilcode.** { *; }
-dontwarn com.blankj.utilcode.**
#------------------END: utilcode----------------------
-dontwarn cn.jpush.**
-keep class cn.jpush.** { *; }

-dontwarn cn.jiguang.**
-keep class cn.jiguang.** { *; }

-dontwarn com.google.zxing.**
-keep  class com.google.zxing.**{*;}

#---------------------BEGIN:Arouter----------------------------
-keep public class com.alibaba.android.arouter.routes.**{*;}
-keep class * implements com.alibaba.android.arouter.facade.template.ISyringe{*;}
#---------------------END:Arouter----------------------------

#---------------------BEGIN:react-native----------------------------
-dontwarn  com.facebook.**.**
-keep class com.facebook.**.** {
    *;
}
-dontwarn  com.facebook.**.**.**
-keep class com.facebook.**.**.** {
    *;
}
-dontwarn  com.ocj.oms.mobile.ui.rn.**
-keep class com.ocj.oms.mobile.ui.rn.** {
    *;
}

#---------------------END:react-native----------------------------
#---------------------BEGIN:jizhalive----------------------------
-libraryjars libs/AlivcBubblingAnimationViewRelease1.0.0.aar
-libraryjars libs/jizhalivesdk-debug.aar
-libraryjars libs/AlivcLiveRecord-release1.0.0.aar
-libraryjars libs/armeabi-v7a/libalivc-media-jni.so
-libraryjars libs/armeabi-v7a/libgnustl_shared.so
-libraryjars libs/armeabi-v7a/libqupai-media-thirdparty.so

-dontwarn  com.alivc.player.**
-keep class com.alivc.player.** { *;}

-dontwarn  com.alivc.player.**.**
-keep class com.alivc.player.**.** {*;}

-dontwarn  com.alivc.player.**.**.**
-keep class com.alivc.player.**.**.** {*;}

-dontwarn  com.alivc.player.**.**.**.**
-keep class com.alivc.player.**.**.**.** {*;}

-dontwarn  com.jz.jizhalivesdk.**
-keep class com.jz.jizhalivesdk.** {*;}

-dontwarn  com.jz.jizhalivesdk.**.**
-keep class com.jz.jizhalivesdk.**.** {*;}

-dontwarn  com.alibaba.view.**
-keep class com.alibaba.view.** {*;}

-dontwarn  com.alibaba.livecloud.**
-keep public class com.alibaba.livecloud.**{*;}

-dontwarn  com.alibaba.livecloud.**.**
-keep public class com.alibaba.livecloud.**.**{*;}

-dontwarn  com.duanqu.qupai.**
-keep class com.duanqu.qupai.** {*;}

-dontwarn  com.duanqu.qupai.**.**
-keep class com.duanqu.qupai.**.** {*;}

-dontwarn  com.duanqu.qupai.**.**.**
-keep class com.duanqu.qupai.**.**.** {*;}

-dontwarn  com.duanqu.qupai.**.**.**.**
-keep class com.duanqu.qupai.**.**.**.** {*;}

#直播的混淆keep
-keep public class com.ocj.oms.mobile.ui.video.player.**{*;}
-keep public class com.ocj.oms.mobile.ui.video.player.**.**{*;}

#---------------------END:jizhalive----------------------------

#---------------------BEGIN:logger----------------------------
-dontwarn com.orhanobut.logger.**
-keep class com.orhanobut.logger.** {*;}
#---------------------END:logger----------------------------


#---------------------BEGIN:eventbus----------------------------
-keepclassmembers class ** {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }

# Only required if you use AsyncExecutor
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}
#---------------------END:eventbus----------------------------

#---------------------BEGIN:glide----------------------------
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
    **[] $VALUES;
    public *;
}
#---------------------END:glide----------------------------

#---------------------BEGIN:unionpay----------------------------

-dontwarn  cn.gov.pbc.tsm.client.mobile.android.bank.service.**
-keep class cn.gov.pbc.tsm.client.mobile.android.bank.service.** {
    *;
}
-dontwarn  com.UCMobile.PayPlugin.**
-keep class com.UCMobile.PayPlugin.** {
    *;
}
-dontwarn  com.unionpay.**.*
-keep class com.unionpay.**.* {
    *;
}
-dontwarn  com.unionpay.**.**
-keep class com.unionpay.**.** {
    *;
}
-dontwarn  com.unionpay.**.**.**
-keep class com.unionpay.**.**.** {
    *;
}
#---------------------END:unionpay----------------------------


#---------------------BEGIN:TD----------------------------
-libraryjars ../basekit/libs/ocjhttps_Analytics_Android_SDK_V2.2.48.jar
-dontwarn com.tendcloud.tenddata.**
-keep  class com.tendcloud.tenddata.** { *;}
#---------------------END:TD----------------------------


-dontwarn com.ocj.store.OcjStoreDataAnalytics.**
-keep public class com.ocj.store.OcjStoreDataAnalytics.** { *;}

-dontwarn com.ocj.store.OcjStoreDataAnalytics.**.**
-keep public class com.ocj.store.OcjStoreDataAnalytics.**.** { *;}

#指纹识别
# MeiZuFingerprint
-keep class com.fingerprints.service.** { *; }
# SmsungFingerprint
-keep class com.samsung.android.sdk.** { *; }



