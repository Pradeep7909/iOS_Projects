#  Arfof Demo
A sample project on Ecommerce Application with Authentication, Realtime chat and Map.


- [Description](#Description)
- [Features](#Features)
- [Requirements](#Requirements)
- [Dependencies](#Dependencies)
- [ScreenShots](#ScreenShots)


## Description
Built a iOS Mobile Application using swift, xcode

These application consists of:

  * User authentication using phone numbers, Facebook, Google, Twitter, and GitHub.
  * Real-time chat functionality powered by Firebase Realtime Database.
  * Integration of MapKit for mapping features.
  * Custom UI for notifications using NotificationService and NotificationContent.
  * UI Test and Unit Test for testing my project.
  

## Features

### User Authentication
- **Signup Screen:** Allows users to sign up for the application.
- **Profile Screen:** Displays user profile information.
- **Realtime Database Integration:** Stores user profile data in Firebase Realtime Database.

### Real-time Chat
- **Recent Chats Screen:** Shows a list of recent chats for quick access.
- **All Users Screen:** Displays all users of the application.
- **Chat Screen:** Enables users to engage in real-time chat and share images.

### Map Integration
- **MapView:** Utilizes MapKit to display a map.
- **Polyline between Source and Destination:** Shows a visual representation of the route.
- **Cluster of Annotations:** Enhances the map by clustering nearby annotations.

### Arfof Ecommerce
- **Home Screen:** Landing page with essential information.
- **Single Product Screen:** Display detail about a product.
- **Single Store Screen:** Shows detail about store such as reviews
- **Orders Screen:** Displays order history and status.
- **Dashboard Screen:** Presents a graph related to orders and sales'
'.

### DGCharts Integration
- **Line Chart and Bar Chart:** Utilizes DGCharts to visualize data in the dashboard screen.


## Requirements

- iOS 13.0+ (Minimum Deployment target)


## Dependencies

* [Hero](https://github.com/HeroTransitions/Hero) :- For Animation 
* [DGCharts](https://github.com/DanielGindi/Charts) :- For Line Chart and Bar Chart in DashBoard Screen 
* [FirebaseAuth](https://github.com/firebase/firebase-ios-sdk) :- For Authentication 
* [FirebaseMessaging](https://github.com/firebase/firebase-ios-sdk) :- For Notification 
* [FirebaseInAppMessaging](https://github.com/firebase/firebase-ios-sdk) :- For in-App Messages 
* [FirebaseDatabase](https://github.com/firebase/firebase-ios-sdk) :- For Real-Time Chat 
* [FirebaseStorage](https://github.com/firebase/firebase-ios-sdk) :- For storing images on Firebase 
* [GoogleSignIn](https://github.com/google/GoogleSignIn) :- For Integrating Google Sign-in 
* [FBSDKLoginKit](https://github.com/facebook/facebook-ios-sdk) :- For Facebook Integration 
* [SDWebImage](https://github.com/SDWebImage/SDWebImage) :- For Displaying Network Image 

```
platform :ios, '13.0'

target 'Arfof Demo' do
  use_frameworks!
  
  # Pods for Arfof Demo
  pod 'Hero'
  pod 'DGCharts'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Crashlytics'
  pod 'FirebaseInAppMessaging', '~> 10.19.0-beta'
  pod 'Firebase/Firestore'
  pod 'GoogleSignIn'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'SDWebImage'
  
end

```
  
## ScreenShots

These are Screenshots of my application screen

<img width="200" alt="AuthUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/c3e5362f-5c1a-4d38-a0d4-3b011b656d58">
<img width="200" alt="mapUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/38689a0c-4340-4cce-b686-d72eebaa4ce8">
<img width="200" alt="ChatUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/65bf09e2-0779-470e-b0a1-68b1539a6f61">
<img width="200" alt="GraphUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/d69d847d-b395-4cc7-b465-dbdf629c5e72">


