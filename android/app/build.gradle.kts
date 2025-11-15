// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ← الأفضل استخدام الاسم الكامل الجديد
    id("com.google.gms.google-services") // ✅ هنا تم التصحيح
    // يجب أن يأتي Flutter plugin بعد Android و Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.firebasecourse"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // ⚙️ ضع معرف التطبيق الخاص بك
        applicationId = "com.example.firebasecourse"

        // إعدادات Flutter الافتراضية
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // لتوقيع النسخة النهائية، حالياً نستخدم debug لتجربة التطبيق فقط
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔥 حزمة Firebase BOM لإدارة النسخ تلقائيًا
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))

    // 🧩 مكتبات Firebase الشائعة
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
}
