import React, { useState } from "react";
import {
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  Alert,
} from "react-native";
import * as Location from "expo-location";
import { useRouter } from "expo-router";
import MapView, { Marker } from "react-native-maps";
import { useRouter } from "expo-router";
import { Picker } from "@react-native-picker/picker";
import { Ionicons } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";

import { buildings } from "../src/parking/buildings";
import { calculateDistance } from "../src/parking/distanceUtils";
import { parkingAreas } from "../src/parking/parkingLocations";

export default function ParkingIDScreen() {
  const router = useRouter();
  const insets = useSafeAreaInsets();

  const [selectedBuilding, setSelectedBuilding] = useState<any>(buildings[0]);
  const [parkingResult, setParkingResult] = useState<any>(null);
  const [distance, setDistance] = useState<number | null>(null);
  const [carLocation, setCarLocation] = useState<any>(null);
  const [userLocation, setUserLocation] = useState<any>(null);

  const handleSuggestion = () => {
    let bestParking = parkingAreas[0];
    let shortestDistance = Infinity;

    for (let i = 0; i < parkingAreas.length; i++) {
      const parking = parkingAreas[i];
      const dist = calculateDistance(
        selectedBuilding.lat,
        selectedBuilding.lng,
        parking.lat,
        parking.lng,
      );

      if (dist < shortestDistance) {
        shortestDistance = dist;
        bestParking = parking;
      }
    }

    setParkingResult(bestParking);
    setDistance(shortestDistance);
  };

  const saveParkingSpot = async () => {
    const { status } = await Location.requestForegroundPermissionsAsync();
    if (status !== "granted") {
      Alert.alert("Permission Denied", "Location permission is required to save your parking spot.");
      return;
    }

    const location = await Location.getCurrentPositionAsync({});
    setCarLocation({
      latitude: location.coords.latitude,
      longitude: location.coords.longitude,
    });
    Alert.alert("Success", "Parking location saved!");
  };

  const findMyCar = async () => {
    if (!carLocation) {
      Alert.alert("No Saved Spot", "You haven't saved a parking spot yet!");
      return;
    }

    const { status } = await Location.requestForegroundPermissionsAsync();
    if (status !== "granted") {
      Alert.alert("Permission Denied", "Location permission is required to find your car.");
      return;
    }

    const location = await Location.getCurrentPositionAsync({});
    setUserLocation({
      latitude: location.coords.latitude,
      longitude: location.coords.longitude,
    });
  };

  return (
    <View style={[styles.container, { paddingTop: insets.top }]}>
      <StatusBar barStyle="dark-content" backgroundColor="#F8F9FB" />

      {/* Fixed Sticky Header */}
      <View style={styles.header}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()} activeOpacity={0.7}>
          <Ionicons name="arrow-back" size={24} color="#333" />
        </TouchableOpacity>
        <View style={styles.headerTextContainer}>
          <Text style={styles.headerTitle}>Parking ID</Text>
          <Text style={styles.headerSub}>Smart parking assistant</Text>
        </View>
        <View style={{ width: 44 }} /> {/* Spacer for centering */}
      </View>

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        <View style={styles.card}>
          <Text style={styles.label}>Select Destination Building</Text>
          <View style={styles.pickerBox}>
            <Picker
              selectedValue={selectedBuilding}
              onValueChange={(itemValue) => setSelectedBuilding(itemValue)}
            >
              {buildings.map((building, index) => (
                <Picker.Item key={index} label={building.name} value={building} />
              ))}
            </Picker>
          </View>
          <TouchableOpacity style={styles.primaryButton} onPress={handleSuggestion} activeOpacity={0.8}>
            <Ionicons name="search" size={20} color="#fff" style={styles.btnIcon} />
            <Text style={styles.primaryButtonText}>Find Best Parking</Text>
          </TouchableOpacity>
        </View>

        {parkingResult && distance !== null && (
          <View style={styles.resultCard}>
            <View style={styles.resultHeader}>
              <Ionicons name="location" size={24} color="#1565C0" />
              <Text style={styles.resultTitle}>Suggested Parking</Text>
            </View>
            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Destination:</Text>
              <Text style={styles.resultValue}>{selectedBuilding.name}</Text>
            </View>
            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Parking Area:</Text>
              <Text style={styles.resultValue}>{parkingResult.name}</Text>
            </View>
            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Distance:</Text>
              <Text style={styles.resultValue}>{(distance * 1000).toFixed(0)} meters</Text>
            </View>
          </View>
        )}

        <View style={styles.actionsRow}>
          <TouchableOpacity style={styles.secondaryButton} onPress={saveParkingSpot} activeOpacity={0.8}>
            <Ionicons name="car" size={20} color="#fff" style={styles.btnIcon} />
            <Text style={styles.secondaryButtonText}>Save Spot</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.secondaryButton} onPress={findMyCar} activeOpacity={0.8}>
            <Ionicons name="navigate" size={20} color="#fff" style={styles.btnIcon} />
            <Text style={styles.secondaryButtonText}>Find Car</Text>
          </TouchableOpacity>
        </View>

        {userLocation && carLocation && (
          <View style={styles.mapContainer}>
            <MapView
              style={styles.map}
              showsUserLocation={true}
              initialRegion={{
                latitude: (userLocation.latitude + carLocation.latitude) / 2,
                longitude: (userLocation.longitude + carLocation.longitude) / 2,
                latitudeDelta: 0.01,
                longitudeDelta: 0.01,
              }}
            >
              <Marker coordinate={userLocation} title="You are here" pinColor="blue" />
              <Marker coordinate={carLocation} title="Your Car" pinColor="green" />
            </MapView>
          </View>
        )}

        {carLocation && !userLocation && (
          <View style={styles.resultCard}>
            <View style={styles.resultHeader}>
              <Ionicons name="bookmark" size={24} color="#1565C0" />
              <Text style={styles.resultTitle}>Saved Parking Location</Text>
            </View>
            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Latitude:</Text>
              <Text style={styles.resultValue}>{carLocation.latitude.toFixed(5)}</Text>
            </View>
            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Longitude:</Text>
              <Text style={styles.resultValue}>{carLocation.longitude.toFixed(5)}</Text>
            </View>
          </View>
        )}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#F8F9FB",
  },
  header: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: "#F8F9FB",
  },
  headerTextContainer: {
    alignItems: "center",
  },
  backBtn: {
    padding: 8,
    borderRadius: 8,
    backgroundColor: "#fff",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: "bold",
    color: "#333",
  },
  headerSub: {
    fontSize: 13,
    color: "#666",
    marginTop: 2,
  },
  scrollContent: {
    paddingHorizontal: 20,
    paddingBottom: 40,
    paddingTop: 10,
  },
  card: {
    backgroundColor: "#fff",
    padding: 20,
    borderRadius: 16,
    marginBottom: 20,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.05,
    shadowRadius: 8,
    elevation: 3,
  },
  label: {
    fontSize: 16,
    fontWeight: "600",
    marginBottom: 12,
    color: "#333",
  },
  pickerBox: {
    borderWidth: 1,
    borderColor: "#E0E0E0",
    borderRadius: 12,
    marginBottom: 20,
    backgroundColor: "#FAFAFA",
    overflow: "hidden",
  },
  primaryButton: {
    backgroundColor: "#007BFF",
    flexDirection: "row",
    padding: 16,
    borderRadius: 12,
    alignItems: "center",
    justifyContent: "center",
  },
  btnIcon: {
    marginRight: 8,
  },
  primaryButtonText: {
    color: "#fff",
    fontSize: 16,
    fontWeight: "bold",
  },
  resultCard: {
    backgroundColor: "#E3F2FD",
    padding: 20,
    borderRadius: 16,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: "#BBDEFB",
  },
  resultHeader: {
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 16,
  },
  resultTitle: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#1565C0",
    marginLeft: 8,
  },
  resultRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 8,
  },
  resultLabel: {
    fontSize: 15,
    color: "#424242",
    fontWeight: "500",
  },
  resultValue: {
    fontSize: 15,
    color: "#1E88E5",
    fontWeight: "600",
  },
  actionsRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 20,
    gap: 12,
  },
  secondaryButton: {
    flex: 1,
    backgroundColor: "#1976D2",
    flexDirection: "row",
    padding: 16,
    borderRadius: 12,
    alignItems: "center",
    justifyContent: "center",
    shadowColor: "#1976D2",
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 4,
  },
  secondaryButtonText: {
    color: "#fff",
    fontSize: 15,
    fontWeight: "600",
  },
  mapContainer: {
    borderRadius: 16,
    overflow: "hidden",
    marginBottom: 20,
    borderWidth: 1,
    borderColor: "#E0E0E0",
  },
  map: {
    height: 300,
    width: "100%",
  },
});
