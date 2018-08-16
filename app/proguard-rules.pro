# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in D:\android\sdk\sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}
#-dontwarn
#-dontnote
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
-keep public class * extends android.app.Fragment

# 保持 native 方法不被混淆
-keepclasseswithmembernames class * {
    native <methods>;
}
-keep public class com.community.equity.entity.**{*;}
-keep public class com.community.imsdk.db.DBHelper{*;}
-keep public class com.community.imsdk.dto.**.**{*;}
-keep public class com.community.equity.utils.**{*;}
-keep public class com.community.imsdk.db.bean.**{*;}
-keep public class com.community.imsdk.http.entity.**{*;}

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
-keepclassmembers class com.community.equity.WebViewActivity{
    public *;
}
-keepclassmembers class com.community.equity.AnswerAddActivity{
    public *;
}
-keepclassmembers class com.community.equity.QuestionAddActivity{
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
-keep public class [com.community.equity].R$*{
public static final int *;
}
#--------------- END: umeng ----------

#--------------- BEGIN: jpush ----------
-dontwarn cn.jpush.**
-keep class cn.jpush.** { *; }
#--------------- END: jpush ----------

#--------------- BEGIN: qiniu ----------
-keep class com.qiniu.**{*;}
-keep class com.qiniu.**{public <init>();}
#--------------- END: qiniu ----------


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
-keep class com.community.equity.api.MyCallBack {
    public <fields>;
    public <methods>;
}
-dontnote retrofit2.**
-dontnote com.facebook.stetho.**.**




