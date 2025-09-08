import java.util.Properties
import java.io.File

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ikjunchoi_android.sprit"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions { jvmTarget = "17" }

    defaultConfig {
        applicationId = "com.ikjunchoi_android.sprit"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    
    signingConfigs {
        create("release") {
            val props = Properties()
            val kp = rootProject.file("key.properties")
            if (kp.exists()) {
                props.load(kp.inputStream())
                val storePath = props["storeFile"] as String?
                if (storePath != null) {
                    storeFile = File(storePath)
                    storePassword = props["storePassword"] as String?
                    keyAlias = props["keyAlias"] as String?
                    keyPassword = props["keyPassword"] as String?
                }
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter { source = "../.." }

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
