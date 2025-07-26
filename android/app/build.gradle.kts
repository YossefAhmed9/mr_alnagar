plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.mrAlnagar.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.mrAlnagar.app"
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Replace with your keystore path and credentials
            storeFile = file("E:\\Work Station\\Android\\mr_alnagar\\android\\app\\upload-keystore.jks")
            storePassword = "1234567890"
            keyAlias = "upload"
            keyPassword = "1234567890"
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false // Set to true if using ProGuard
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")

            isShrinkResources = false // explicitly disable resource shrinking

            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
