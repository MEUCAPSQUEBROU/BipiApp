plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Firebase: aplica o plugin do Google Services neste módulo.
    id("com.google.gms.google-services")
}

android {
    namespace = "br.com.bipi.bipi"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "br.com.bipi.bipi"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // No CI, assina com a debug keystore passada via env (DEBUG_STORE_FILE),
        // para bater com a assinatura dos apps já instalados. Localmente o env
        // não existe e o build usa a debug keystore padrão (~/.android/debug.keystore).
        create("ci") {
            val storePath = System.getenv("DEBUG_STORE_FILE")
            if (storePath != null) {
                storeFile = file(storePath)
                storePassword = "android"
                keyAlias = "androiddebugkey"
                keyPassword = "android"
            }
        }
    }

    buildTypes {
        release {
            // Mesma chave em todo lugar: no CI vem do DEBUG_STORE_FILE; localmente
            // é a debug keystore padrão. Isso garante que updates instalem por cima.
            signingConfig = if (System.getenv("DEBUG_STORE_FILE") != null) {
                signingConfigs.getByName("ci")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
