# 🏋️ Bepop Fitness Mobile App

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.4.3+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-Private-red.svg)

**Your Personal Fitness Companion**

</div>

---

## About

**Bepop Fitness** is a comprehensive mobile application designed for fitness enthusiasts who want to stay fit and healthy. The app provides a wide variety of exercises, workouts, diet plans, and fitness tracking tools to help users achieve their fitness goals effectively.

Built with Flutter, Bepop Fitness offers a seamless cross-platform experience on both iOS and Android devices, combining powerful features with an intuitive and modern user interface.

---

## Key Features

### Fitness & Workouts
- **Personalized Workout Plans** - Customized routines based on your fitness level and goals
- **Exercise Library** - Extensive collection of exercises with detailed instructions
- **Video Tutorials** - High-quality video demonstrations for proper form
- **Progress Tracking** - Monitor your fitness journey with detailed statistics and charts
- **Workout History** - Keep track of completed workouts and achievements
- **Step Counter** - Integrated pedometer for daily activity tracking
- **Health Integration** - Sync with Apple Health for comprehensive fitness data

### Nutrition & Diet
- **Diet Plans** - Tailored meal plans for various fitness goals
- **Nutrition Tracking** - Monitor your calorie and macro intake
- **Recipe Library** - Healthy recipes with nutritional information
- **Diet Categories** - Organized meal plans for different dietary preferences

### Social & Community
- **Community Feed** - Share your progress and connect with other fitness enthusiasts
- **Blog & Articles** - Expert fitness tips and wellness articles
- **Chat & Support** - Real-time chat with trainers and support team
- **AI Chatbot** - Get instant answers to fitness-related questions

### Personalization
- **Custom Goals** - Set and track personalized fitness objectives
- **Body Part Targeting** - Focus on specific muscle groups
- **Equipment Filters** - Workouts for your available equipment (No equipment, Dumbbells, Full Gym, etc.)
- **Difficulty Levels** - From totally newbie to advanced
- **Multi-language Support** - Available in multiple languages

### Tracking & Analytics
- **Progress Charts** - Visual representation of your fitness journey
- **Body Measurements** - Track weight, BMI, and other metrics
- **Workout Scheduling** - Plan your fitness routine with calendar integration
- **Reminders & Notifications** - Stay motivated with timely workout reminders

### Premium Features
- **Subscription Plans** - Access premium workouts and features
- **Multiple Payment Options** - Stripe, Razorpay, PayPal, Paystack, and more
- **Scheduled Payments** - Flexible payment scheduling

### User Experience
- **Dark/Light Mode** - Comfortable viewing in any lighting
- **Offline Support** - Access downloaded content without internet
- **Chromecast Support** - Stream workouts to your TV
- **Picture-in-Picture Mode** - Multitask while watching workout videos
- **Bookmark Favorites** - Save your favorite workouts and articles
- **Advanced Search** - Quickly find workouts, exercises, and content

---

## 🛠 Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **MobX** - State management solution

### Backend & Services
- **Firebase** - Authentication, Cloud Firestore, Analytics, Crashlytics, Storage, Cloud Messaging
- **OneSignal** - Push notifications

### Media & Video
- **YouTube Player** - Video playback
- **Chewie** - Custom video player
- **Video Compress** - Optimize video files
- **Chromecast** - TV casting support

### Payment Integrations
- **Stripe** - Payment processing
- **Razorpay** - Indian payment gateway
- **Paystack** - African payment gateway
- **PayTabs** - Middle East payment gateway
- **MyFatoorah** - Payment solution
- **Braintree** - PayPal integration

### UI/UX Libraries
- **Google Fonts** - Typography
- **Lottie** - Smooth animations
- **Cached Network Image** - Optimized image loading
- **Photo View** - Image viewer with zoom
- **Syncfusion Charts** - Data visualization
- **Card Swiper** - Swipeable cards

### Authentication
- **Google Sign-In** - Social login
- **Apple Sign-In** - iOS authentication
- **OTP Verification** - Phone number verification

### Other Integrations
- **OpenAI ChatGPT** - AI-powered chat assistance
- **Health Kit** - iOS health data integration
- **Pedometer** - Step counting
- **Image Picker** - Camera and gallery access
- **Share Plus** - Social sharing
- **URL Launcher** - External links

---


## Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd bepop-fitness-mobile
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
- Add your `google-services.json` file to `android/app/`
- Add your `GoogleService-Info.plist` file to `ios/Runner/`
- Update Firebase configuration in `lib/utils/app_config.dart`

### 4. iOS Setup (macOS only)
```bash
cd ios
pod install
cd ..
```

---

## Running the Application

### Run on Connected Device/Emulator
```bash
flutter run
```

### Run in Debug Mode
```bash
flutter run --debug
```

### Run in Release Mode
```bash
flutter run --release
```

### Run on Specific Device
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

---

## Building for Production

### Android APK
Generate split APKs for different architectures (recommended):
```bash
flutter build apk --split-per-abi
open build/app/outputs/flutter-apk/
```

Generate a single universal APK:
```bash
flutter build apk
```

### Android App Bundle (for Google Play Store)
```bash
flutter build appbundle
```

### iOS (macOS only)
```bash
flutter build ios --release
```
Then open `ios/Runner.xcworkspace` in Xcode and archive the app.

---

## Maintenance Commands

### Update iOS Pods
```bash
cd ios
pod init
pod update
pod install
cd ..
```

### Clean Pub Cache
```bash
flutter clean
flutter pub cache clean
flutter pub get
```

### Repair Pub Cache
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Fix Common iOS Errors
If you encounter iOS build issues, run this comprehensive cleanup:
```bash
flutter clean
rm -Rf ios/Pods
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf Flutter/Flutter.podspec
rm ios/podfile.lock
cd ios 
pod deintegrate
sudo rm -rf ~/Library/Developer/Xcode/DerivedData
flutter pub cache repair
flutter pub get 
pod install 
pod update
cd ..
```

---

## Project Structure

```
bepop-fitness-mobile/
├── android/                 # Android native code
├── ios/                     # iOS native code
├── lib/
│   ├── components/         # Reusable UI components
│   ├── extensions/         # Dart extensions
│   ├── models/            # Data models
│   ├── screens/           # App screens/pages
│   ├── service/           # API services
│   ├── store/             # MobX stores (state management)
│   ├── utils/             # Utility functions and constants
│   └── main.dart          # App entry point
├── assets/                # Images, fonts, and static files
├── pubspec.yaml          # Project dependencies
└── README.md             # This file
```

---


## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

---

## Troubleshooting

### Common Issues

**Issue: Dependencies conflict**
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

**Issue: iOS build fails**
```bash
cd ios
pod repo update
pod install --repo-update
cd ..
```

**Issue: Android build fails**
- Ensure you have the latest Android SDK
- Check `android/app/build.gradle` for minimum SDK version
- Clean and rebuild: `flutter clean && flutter build apk`


## Supported Platforms

- ✅ Android (API 26+)
- ✅ iOS (12.0+)

---

<div align="center">

**Made with ❤️ by Roland Team**

*Stay fit, stay healthy with Bepop Fitness!*

</div>
