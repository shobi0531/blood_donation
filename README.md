Here’s a sample `README.md` file for your **Blood Donation App** project. You can customize it further based on your specific requirements and features:

---

# Blood Donation App

![Blood Donation App](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-%23FFCA28.svg?style=for-the-badge&logo=Firebase&logoColor=black)

A Flutter-based mobile application designed to connect blood donors with recipients. The app uses **Firebase Firestore** for real-time data storage and retrieval, and **Firebase Authentication** for user management.

---

## Features

- **User Authentication**: Sign up, log in, and manage user profiles using Firebase Authentication.
- **Donor Registration**: Users can register as blood donors by providing their details (e.g., blood group, location).
- **Blood Request**: Recipients can request blood by specifying their requirements (e.g., blood group, urgency).
- **Real-Time Updates**: Firebase Firestore ensures real-time updates for blood requests and donor availability.
- **Search Donors**: Users can search for donors based on blood group and location.
- **Notifications**: Push notifications for new blood requests or donor matches.

---

## Firebase Collections

The app uses the following Firestore collections:

1. **`users`**:
   - Stores user profile information (e.g., name, email, blood group, location).
   - Example document structure:
     ```json
     {
       "name": "John Doe",
       "email": "john.doe@example.com",
       "bloodGroup": "O+",
       "location": "New York",
       "isDonor": true
     }
     ```

2. **`donations`**:
   - Stores blood donation requests made by recipients.
   - Example document structure:
     ```json
     {
       "recipientId": "abc123",
       "bloodGroup": "A+",
       "location": "Los Angeles",
       "urgency": "High",
       "timestamp": "2023-10-15T12:00:00Z"
     }
     ```

3. **`notifications`**:
   - Stores notifications for users (e.g., new blood requests, donor matches).
   - Example document structure:
     ```json
     {
       "userId": "xyz456",
       "message": "A new blood request matches your blood group.",
       "timestamp": "2023-10-15T12:30:00Z",
       "read": false
     }
     ```

---

## Setup Instructions

### Prerequisites

- Flutter SDK installed (version 3.0 or higher).
- Firebase project set up on the [Firebase Console](https://console.firebase.google.com/).
- Android Studio or VS Code for development.

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/shobi0531/blood_donation.git
   cd blood_donation
   ```

2. **Add Firebase Configuration**:
   - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) from your Firebase project.
   - Place these files in the appropriate directories:
     - Android: `android/app/`
     - iOS: `ios/Runner/`

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the App**:
   ```bash
   flutter run
   ```

---

## Dependencies

The app uses the following Flutter packages:

- `firebase_core`: For Firebase initialization.
- `cloud_firestore`: For Firestore database operations.
- `firebase_auth`: For user authentication.
- `flutter_local_notifications`: For push notifications.
- `geolocator`: For location-based services.

Add these to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: latest_version
  cloud_firestore: latest_version
  firebase_auth: latest_version
  flutter_local_notifications: latest_version
  geolocator: latest_version
```

---

## Screenshots
-![ss1](https://github.com/user-attachments/assets/6d3d9aa8-85d3-4742-805d-2b72cba82634)

-![ss2](https://github.com/user-attachments/assets/8b22fd5c-6e09-416f-a4ac-a8dd184ebce1)

![ss3](https://github.com/user-attachments/assets/609b3ac5-0e08-4920-beed-46ed9c270e35)

![ss4](https://github.com/user-attachments/assets/2b9b9f4b-5c64-4de8-89aa-2a82b172660e)

![ss5](https://github.com/user-attachments/assets/f17e76ac-288e-464b-ab83-f5282574c5cb)

![ss6](https://github.com/user-attachments/assets/4a093042-0764-4130-bf14-33f9aa600de2)


## Contact

For any questions or feedback, feel free to reach out:

- **Shobi**  
  GitHub: [shobi0531](https://github.com/shobi0531)  
  Email: shobi0531@example.com

---
