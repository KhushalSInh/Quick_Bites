plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.quick_bites"

    // ✅ Use Flutter's compileSdk but override NDK version to match plugin requirements
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // <-- FIX: Manually set to highest required version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // ✅ Speeds up incremental builds
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.quick_bites"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // ✅ Enables code shrinking & smaller APKs (optional)
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Recommended for desugaring (backward-compatible Java APIs)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
