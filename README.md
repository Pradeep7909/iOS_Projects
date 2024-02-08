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
- **Custom Notification UI:** User can even reply and mark message as seen from notification.
- **Addition Features:** User Online/Offline, Message Seen/Unseen, Edit/Delete option


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

### These are Screenshots of my application screen

Authentication 
<img width="200" alt="AuthUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/c3e5362f-5c1a-4d38-a0d4-3b011b656d58">
<img width="200" alt="OtpUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/4a109a36-5a7e-4164-b1d7-9364fe47c2d8">



RealTime Chat Aplication
<img width="200" alt="ChatUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/b307fa10-5222-444a-9725-f9cba2777c00">
<img width="200" alt="ChatUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/e8756735-3b0f-4a4a-9a00-eeeeec1acb6b">
<img width="200" alt="ChatUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/275fd8d3-eebe-4580-b845-07aa5d898d80">
<img width="200" alt="ChatUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/149497c5-1799-4ac6-80d1-e2f375bbdb56">
<img width="200" alt="ChatUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/e0ead16f-4522-4673-9120-ea468029bb2c">



Map Integration
<img width="200" alt="mapUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/38689a0c-4340-4cce-b686-d72eebaa4ce8">
<img width="200" alt="mapUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/dcf0a392-a50f-49cd-9059-df035aad6ead">
<img width="200" alt="mapUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/40cc95a5-ebb7-4915-8f35-3cc88b171e5d">
<img width="200" alt="mapUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/fe85e9e8-4976-4f2d-bac6-7421a9737e64">



Arfof Clone 
<img width="200" alt="ArfofCloneUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/7e265ac2-8123-40b6-a478-fa6cb33dba02">
<img width="200" alt="ArfofCloneUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/a0c69c65-17b0-4252-b28f-291be04343b1">
<img width="200" alt="ArfofCloneUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/d09c6a05-e343-4e2c-b8e8-8be1c34a600d">
<img width="200" alt="ArfofCloneUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/e0960b5b-6689-44da-aa28-b3daf18a0e07">
<img width="200" alt="ArfofCloneUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/d5fbcb94-c55c-443e-b99d-fa520eeaada7">
<img width="200" alt="ArfofCloneUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/46ace651-7947-494d-ab57-62e3b0ade036">
<img width="200" alt="ArfofCloneUI" src="https://github.com/Pradeep7909/Arfof_Demo/assets/125856691/3a473bdc-da2b-4f47-a163-12c94be72fe9">



