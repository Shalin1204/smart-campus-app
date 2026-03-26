# 🎓 Smart Campus App

Welcome to the **Smart Campus App**, an all-in-one centralized mobile application built with React Native and Expo. This app is designed to streamline and modernize the university experience for students, faculty, and staff by offering a unified suite of powerful campus-specific utilities.

---

## 🌟 Core Features 

Our platform goes beyond basic directories by integrating state-of-the-art navigation and AI tools.

### 🤖 1. AI Campus Chatbot (Main Feature)
Your 24/7 intelligent campus assistant. Powered by advanced AI (Gemini), the chatbot is seamlessly integrated to answer any questions about the university—from syllabus details and exam schedules to events and administrative procedures.
- Natural language query understanding
- Context-aware responses customized for the university
- Fast, reliable, and continuously learning

### 🚌 2. Real-Time Bus Tracking (Main Feature)
Never miss your shuttle again. This feature provides a live, interactive map tracking the campus bus fleet in real-time.
- View live coordinates and movement of all campus buses
- Check estimated times of arrival (ETAs) and routes
- Easily find the nearest active bus stop

### 🗺️ 3. Interactive Campus Map (Main Feature)
A custom-built, highly detailed geographic map of the entire university grounds.
- Search and highlight specific department buildings, labs, and dorms
- Custom routing and walking directions between points of interest
- Identify key facilities like libraries, restrooms, and auditoriums with custom markers

---

## ✨ Additional Smart Features

### 🍔 4. Smart Canteen & Food Court
Skip the lines! Browse menus across various campus restaurants and food courts (like HR05 Food Plaza and Queens Court).
- Filter by Veg/Non-Veg options
- Browse categories: Fast Food, Thalis, Main Courses, Beverages, and more
- Seamlessly add items to your cart and track orders

### 🚗 5. Parking ID & Assistant
Take the hassle out of finding a spot. The Parking ID system helps you locate the best parking areas closest to your destination building.
- Calculate distance from specific buildings to available parking lots
- Save your specific parking spot GPS coordinates
- Use the "Find My Car" feature with live tracking to navigate directly back to your vehicle

### 🚨 6. Emergency Helpline
Safety is a priority. Instantly access an emergency dashboard that connects you to campus security, medical centers, and administration.
- One-tap calling for critical university helplines
- Quick SOS buttons for immediate security dispatch

---

## 🚀 Getting Started

### Prerequisites

Ensure you have [Node.js](https://nodejs.org/) installed. We recommend testing on physical devices using the Expo Go app.

### Installation

1. Clone this repository and navigate into the project directory:
   ```bash
   git clone <repository-url>
   cd smart-campus-app
   ```

2. Install the necessary dependencies:
   ```bash
   npm install
   ```

3. Start the Expo development server:
   ```bash
   npx expo start -c
   ```

### Running the App

Once the server is running, you can open the app using:
- **Expo Go App**: Scan the QR code in your terminal using your iOS/Android device.
- **Android Emulator**: Press `a` in the terminal.
- **iOS Simulator**: Press `i` in the terminal.

---

## 🛠️ Technology Stack
- **Framework**: React Native + Expo (Managed Workflow)
- **Routing**: Expo Router (File-based internal routing)
- **Mapping & Logistics**: `react-native-maps` & `expo-location`
- **UI Components**: Custom `StyleSheet`, `@react-native-picker/picker`, `@expo/vector-icons`
- **AI Engine**: Google Gemini API Integration
