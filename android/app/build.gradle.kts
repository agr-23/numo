import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.numo.numo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.numo.numo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Firma de versiones: si existe android/key.properties (local) o las
    // variables NUMO_KEYSTORE_* (CI), se firma con ese keystore. Si no, con
    // la clave de depuración, para que `flutter run --release` funcione.
    // Ver docs/RELEASING.md. El keystore nunca se sube al repositorio.
    val keyProps = Properties().apply {
        val f = rootProject.file("key.properties")
        if (f.exists()) f.inputStream().use { load(it) }
    }
    fun secret(prop: String, env: String): String? =
        keyProps.getProperty(prop) ?: System.getenv(env)
    val storePath = secret("storeFile", "NUMO_KEYSTORE_PATH")

    signingConfigs {
        if (storePath != null) {
            create("release") {
                storeFile = file(storePath)
                storePassword = secret("storePassword", "NUMO_KEYSTORE_PASSWORD")
                keyAlias = secret("keyAlias", "NUMO_KEY_ALIAS")
                keyPassword = secret("keyPassword", "NUMO_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release")
                ?: signingConfigs.getByName("debug")
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
