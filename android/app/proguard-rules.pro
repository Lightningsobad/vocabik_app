# ProGuard / R8 Rules for Vocabik App

# 1. Crashlytics stack trace & line numbers de-obfuscation
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-renamesourcefileattribute SourceFile

# 2. Flutter Embedding & Plugins
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# 3. Firebase & Google Play Services
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# 4. Java Desugaring & Reflection
-dontwarn java.lang.invoke.**
-dontwarn java.time.**

