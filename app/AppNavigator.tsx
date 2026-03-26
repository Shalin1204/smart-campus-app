import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import React from "react";

import BusTrackingScreen from "./BusTrackingScreen";
import CampusMapScreen from "./CampusMapScreen";
import CanteenScreen from "./CanteenScreen";
import ChatbotScreen from "./ChatbotScreen";
import DashboardScreen from "./DashboardScreen";
import HelplineScreen from "./HelplineScreen";
import ParkingIDScreen from "./parking-id";
import SplashScreen from "./SplashScreen";

export type RootStackParamList = {
  Splash: undefined;
  Dashboard: undefined;
  BusTracking: undefined;
  Canteen: undefined;
  CampusMap: undefined;
  ParkingID: undefined;
  Helpline: undefined;
  Chatbot: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator
        initialRouteName="Splash"
        screenOptions={{ headerShown: false }}
      >
        <Stack.Screen name="Splash" component={SplashScreen} />
        <Stack.Screen name="Dashboard" component={DashboardScreen} />
        <Stack.Screen name="BusTracking" component={BusTrackingScreen} />
        <Stack.Screen name="Canteen" component={CanteenScreen} />
        <Stack.Screen name="CampusMap" component={CampusMapScreen} />
        <Stack.Screen name="ParkingID" component={ParkingIDScreen} />
        <Stack.Screen name="Helpline" component={HelplineScreen} />
        <Stack.Screen name="Chatbot" component={ChatbotScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
