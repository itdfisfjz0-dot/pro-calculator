# آلة حاسبة احترافية - Flutter

تطبيق آلة حاسبة احترافي مبني بـ Flutter يعمل **بدون إنترنت** بشكل كامل،
مع واجهة عربية وداكنة، عمليات علمية، وسجل محفوظ محلياً على الجهاز.

---

## الميزات

- واجهة داكنة عصرية بنفس تصميم النسخة الويب (برتقالي + رمادي داكن).
- عمليات أساسية: + − × ÷ ( ) % .
- عمليات علمية: sin, cos, tan, log, ln, √, x^y, π, e.
- سجل العمليات محفوظ محلياً عبر **SQLite** ويعمل بدون إنترنت.
- مسح فردي بالسحب أو مسح كامل للسجل.
- إعادة استخدام أي عملية سابقة بضغطة واحدة.
- اهتزاز خفيف عند الضغط على الأزرار (Haptic Feedback).
- شاشة بداية (Splash Screen) وأيقونة تطبيق احترافية.
- يدعم الاتجاه الرأسي على الهاتف.

---

## بنية المشروع

```
flutter_app/
├── pubspec.yaml              # تبعيات Flutter
├── lib/
│   ├── main.dart             # نقطة الدخول
│   ├── theme/app_theme.dart  # ألوان وخطوط التطبيق
│   ├── models/calculation.dart
│   ├── services/
│   │   ├── calculator_service.dart  # محرك الحساب
│   │   └── database_service.dart    # SQLite للتخزين المحلي
│   ├── widgets/
│   │   ├── display.dart
│   │   └── calculator_button.dart
│   └── screens/
│       ├── calculator_screen.dart
│       └── history_screen.dart
├── assets/
│   ├── icon/icon.png         # أيقونة التطبيق
│   └── splash/splash.png     # شعار شاشة البداية
└── android/                  # إعدادات أندرويد
```

---

## المتطلبات قبل البناء

1. **Flutter SDK** الإصدار 3.10 أو أحدث.
   تحقق من التثبيت:
   ```bash
   flutter --version
   flutter doctor
   ```
2. **Android Studio** (أو على الأقل Android command-line tools + JDK 17).
3. تأكد من قبول رخص أندرويد:
   ```bash
   flutter doctor --android-licenses
   ```

> ملاحظة: بيئة Replit الحالية لا تدعم Flutter SDK مباشرة. لذا يجب تنزيل
> مجلد `flutter_app/` على جهازك الشخصي ثم تشغيل الخطوات التالية.

---

## خطوات التشغيل أول مرة

من داخل مجلد `flutter_app/`:

```bash
# 1. تنزيل التبعيات
flutter pub get

# 2. توليد أيقونة التطبيق من assets/icon/icon.png
flutter pub run flutter_launcher_icons

# 3. توليد شاشة البداية من assets/splash/splash.png
flutter pub run flutter_native_splash:create

# 4. تشغيل التطبيق على جهاز/محاكي متصل
flutter run
```

---

## بناء ملف APK للتثبيت على أندرويد

### بناء APK تجريبي (debug) سريع
```bash
flutter build apk --debug
# الناتج: build/app/outputs/flutter-apk/app-debug.apk
```

### بناء APK جاهز للنشر (release)
```bash
flutter build apk --release
# الناتج: build/app/outputs/flutter-apk/app-release.apk
```

### بناء APK مقسّم حسب المعمارية (حجم أصغر)
```bash
flutter build apk --split-per-abi --release
# الناتج: عدة ملفات داخل build/app/outputs/flutter-apk/
#   app-armeabi-v7a-release.apk   (للأجهزة القديمة 32-bit)
#   app-arm64-v8a-release.apk     (الأجهزة الحديثة 64-bit) ← الأكثر استخداماً
#   app-x86_64-release.apk        (المحاكيات)
```

### بناء AAB لرفعه على Google Play
```bash
flutter build appbundle --release
# الناتج: build/app/outputs/bundle/release/app-release.aab
```

---

## التثبيت على هاتف أندرويد

1. فعّل **خيارات المطور** على هاتفك ثم فعّل **USB Debugging**.
2. وصّل الهاتف بالكمبيوتر.
3. تأكد أنه ظاهر:
   ```bash
   flutter devices
   ```
4. ثبّت مباشرة:
   ```bash
   flutter install
   ```
   أو انقل ملف `app-release.apk` إلى الهاتف وافتحه يدوياً للتثبيت
   (قد يطلب الجهاز السماح بتثبيت تطبيقات من مصادر غير معروفة).

---

## التوقيع للنشر على Google Play (اختياري)

1. أنشئ keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. أنشئ ملف `flutter_app/android/key.properties` (لا ترفعه إلى Git):
   ```
   storePassword=YOUR_PASSWORD
   keyPassword=YOUR_PASSWORD
   keyAlias=upload
   storeFile=/absolute/path/to/upload-keystore.jks
   ```
3. حدّث `android/app/build.gradle` ليقرأ `key.properties` ويستخدم
   `signingConfigs.release` بدل `signingConfigs.debug`.
4. أعد البناء: `flutter build appbundle --release`.

---

## ملاحظات تقنية

- محرك الحساب يستخدم مكتبة `math_expressions` ويدعم نفس عمليات النسخة الويب.
- التخزين المحلي عبر `sqflite` — جميع العمليات تُحفظ محلياً ولا تحتاج خادماً.
- لا يوجد أي اتصال بشبكة الإنترنت أو خدمات خارجية، التطبيق آمن للعمل أوفلاين.
- إذا واجهت أي خطأ في بناء Gradle، نفّذ:
  ```bash
  cd android && ./gradlew clean && cd .. && flutter clean && flutter pub get
  ```
