plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
        import java.io.FileInputStream

// Cargar credenciales de CleverTap desde local.properties
val props = Properties().apply {
    load(FileInputStream(rootProject.file("local.properties")))
}

android {
    namespace = "com.example.growthlab_productivity"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Kotlin DSL correcto
    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.growthlab_productivity"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Placeholders de CleverTap
        manifestPlaceholders["CLEVERTAP_ACCOUNT_ID"] = props.getProperty("CLEVERTAP_ACCOUNT_ID")
        manifestPlaceholders["CLEVERTAP_TOKEN"]     = props.getProperty("CLEVERTAP_TOKEN")
        manifestPlaceholders["CLEVERTAP_REGION"]    = props.getProperty("CLEVERTAP_REGION")
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
