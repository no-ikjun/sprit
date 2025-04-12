# OkHttp/Conscrypt 관련 예외
-keep class org.conscrypt.** { *; }
-dontwarn org.conscrypt.**

-keep class org.openjsse.** { *; }
-dontwarn org.openjsse.**

# Prevent removal of SSL-related classes
-keep class javax.net.ssl.** { *; }
-dontwarn javax.net.ssl.**

# Optional: keep Flutter plugin generated code
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**
