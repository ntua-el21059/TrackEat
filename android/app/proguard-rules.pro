# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**

# Keep your model classes
-keep class com.trackeat.app.models.** { *; }

# Keep Gson annotations
-keepattributes *Annotation*
-keepattributes Signature
-dontwarn sun.misc.**

# Prevent R8 from stripping interface information
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep setters in models so Gson can find them
-keepclassmembers class * {
    void set*(***);
    *** get*();
} 