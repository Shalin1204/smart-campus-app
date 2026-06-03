/**
 * Native (Android / iOS) implementation of the Parking ID screen.
 * Metro picks this file automatically over parking-id.tsx on native platforms.
 */
import React, { useCallback, useRef, useState } from "react";
import {
  Alert,
  Animated,
  Platform,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { Ionicons } from "@expo/vector-icons";
import * as Location from "expo-location";
import { useRouter } from "expo-router";
import { Picker } from "@react-native-picker/picker";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import MapView, { Marker, Polyline, PROVIDER_GOOGLE } from "react-native-maps";

import { buildings } from "../src/parking/buildings";
import { calculateDistance } from "../src/parking/distanceUtils";
import { parkingAreas, ParkingArea } from "../src/parking/parkingLocations";

/* ─── Types ─────────────────────────────────────────────────────── */
type LatLng = { latitude: number; longitude: number };

type ParkingResult = ParkingArea & {
  distanceM: number;
  walkMinutes: number;
};

/* ─── Constants ─────────────────────────────────────────────────── */
const GREEN = "#16A34A";

/* ─── Main Screen ────────────────────────────────────────────────── */
export default function ParkingIDScreen() {
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const mapRef = useRef<MapView>(null);

  const [selectedBuildingName, setSelectedBuildingName] = useState<string>(
    buildings[0].name
  );
  const [rankedParking, setRankedParking] = useState<ParkingResult[]>([]);
  const [selectedParking, setSelectedParking] = useState<ParkingResult | null>(null);
  const [carLocation, setCarLocation] = useState<LatLng | null>(null);
  const [userLocation, setUserLocation] = useState<LatLng | null>(null);
  const [mapMode, setMapMode] = useState<"none" | "suggestion" | "findCar">("none");
  const [loadingLocation, setLoadingLocation] = useState(false);
  const [savingSpot, setSavingSpot] = useState(false);

  const fadeAnim = useRef(new Animated.Value(0)).current;

  const selectedBuilding =
    buildings.find((b) => b.name === selectedBuildingName) ?? buildings[0];

  /* ── Request location permission ── */
  const requestPermission = async (): Promise<boolean> => {
    const { status } = await Location.requestForegroundPermissionsAsync();
    if (status !== "granted") {
      Alert.alert(
        "Permission Needed",
        "Location access is required. Please enable it in Settings.",
        [{ text: "OK" }]
      );
      return false;
    }
    return true;
  };

  /* ── Rank all parking areas by Haversine distance from building ── */
  const handleFindParking = useCallback(() => {
    const results: ParkingResult[] = parkingAreas
      .map((p) => {
        const distKm = calculateDistance(
          selectedBuilding.lat,
          selectedBuilding.lng,
          p.lat,
          p.lng
        );
        const distM = Math.round(distKm * 1000);
        const walkMinutes = Math.max(1, Math.round(distM / 80)); // 80 m/min avg walk
        return { ...p, distanceM: distM, walkMinutes };
      })
      .sort((a, b) => a.distanceM - b.distanceM);

    setRankedParking(results);
    setSelectedParking(results[0]);
    setMapMode("suggestion");

    fadeAnim.setValue(0);
    Animated.timing(fadeAnim, {
      toValue: 1,
      duration: 400,
      useNativeDriver: true,
    }).start();

    setTimeout(() => {
      mapRef.current?.fitToCoordinates(
        [
          { latitude: selectedBuilding.lat, longitude: selectedBuilding.lng },
          { latitude: results[0].lat, longitude: results[0].lng },
        ],
        { edgePadding: { top: 60, right: 60, bottom: 60, left: 60 }, animated: true }
      );
    }, 400);
  }, [selectedBuilding, fadeAnim]);

  /* ── Save GPS as parking spot ── */
  const handleSaveSpot = async () => {
    setSavingSpot(true);
    const granted = await requestPermission();
    if (!granted) { setSavingSpot(false); return; }
    try {
      const loc = await Location.getCurrentPositionAsync({
        accuracy: Location.Accuracy.High,
      });
      const coords: LatLng = {
        latitude: loc.coords.latitude,
        longitude: loc.coords.longitude,
      };
      setCarLocation(coords);
      setUserLocation(null);
      setMapMode("none");
      Alert.alert(
        "✅ Spot Saved!",
        `Parking location saved.\nLat: ${coords.latitude.toFixed(5)}\nLng: ${coords.longitude.toFixed(5)}`
      );
    } catch {
      Alert.alert("Error", "Could not get your location. Please try again.");
    } finally {
      setSavingSpot(false);
    }
  };

  /* ── Navigate back to saved car ── */
  const handleFindCar = async () => {
    if (!carLocation) {
      Alert.alert(
        "No Saved Spot",
        "Save your parking spot first using 'Save My Spot'."
      );
      return;
    }
    setLoadingLocation(true);
    const granted = await requestPermission();
    if (!granted) { setLoadingLocation(false); return; }
    try {
      const loc = await Location.getCurrentPositionAsync({
        accuracy: Location.Accuracy.High,
      });
      const userCoords: LatLng = {
        latitude: loc.coords.latitude,
        longitude: loc.coords.longitude,
      };
      setUserLocation(userCoords);
      setMapMode("findCar");
      setTimeout(() => {
        mapRef.current?.fitToCoordinates(
          [userCoords, carLocation],
          { edgePadding: { top: 80, right: 80, bottom: 80, left: 80 }, animated: true }
        );
      }, 400);
    } catch {
      Alert.alert("Error", "Could not get your location. Please try again.");
    } finally {
      setLoadingLocation(false);
    }
  };

  /* ── Distance between two LatLng in metres ── */
  const distBetween = (a: LatLng, b: LatLng) =>
    Math.round(calculateDistance(a.latitude, a.longitude, b.latitude, b.longitude) * 1000);

  /* ─── Render ─────────────────────────────────────────────────── */
  return (
    <View style={[styles.container, { paddingTop: insets.top }]}>
      <StatusBar barStyle="dark-content" backgroundColor="#F3F4F6" />

      {/* ── Header ── */}
      <View style={styles.header}>
        <TouchableOpacity
          style={styles.backBtn}
          onPress={() => router.back()}
          activeOpacity={0.7}
        >
          <Ionicons name="arrow-back" size={22} color="#111827" />
        </TouchableOpacity>
        <View style={styles.headerCenter}>
          <Text style={styles.headerTitle}>Parking ID</Text>
          <Text style={styles.headerSub}>Smart campus parking assistant</Text>
        </View>
        <View style={{ width: 38 }} />
      </View>

      <ScrollView
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
        keyboardShouldPersistTaps="handled"
      >
        {/* ── Find Parking Card ── */}
        <View style={styles.card}>
          <View style={styles.cardHeader}>
            <View style={styles.cardIconBg}>
              <Ionicons name="search-circle" size={20} color={GREEN} />
            </View>
            <Text style={styles.cardTitle}>Find Best Parking</Text>
          </View>
          <Text style={styles.sectionLabel}>Select Your Destination</Text>
          <View style={styles.pickerBox}>
            <Ionicons name="business" size={16} color="#6B7A8D" style={styles.pickerIcon} />
            <Picker
              selectedValue={selectedBuildingName}
              onValueChange={(v) => {
                setSelectedBuildingName(v as string);
                setRankedParking([]);
                setSelectedParking(null);
                setMapMode("none");
              }}
              style={styles.picker}
              dropdownIconColor="#6B7A8D"
            >
              {buildings.map((b) => (
                <Picker.Item key={b.name} label={b.name} value={b.name} />
              ))}
            </Picker>
          </View>
          <TouchableOpacity
            style={styles.primaryBtn}
            onPress={handleFindParking}
            activeOpacity={0.85}
          >
            <Ionicons name="car-sport" size={18} color="#fff" style={{ marginRight: 8 }} />
            <Text style={styles.primaryBtnText}>Find Best Parking</Text>
          </TouchableOpacity>
        </View>

        {/* ── Suggestion Map ── */}
        {mapMode === "suggestion" && selectedParking && (
          <Animated.View style={[styles.mapCard, { opacity: fadeAnim }]}>
            <View style={styles.mapLabelRow}>
              <Ionicons name="map" size={16} color={GREEN} />
              <Text style={styles.mapLabel}>Parking Map</Text>
            </View>
            <MapView
              ref={mapRef}
              style={styles.map}
              provider={PROVIDER_GOOGLE}
              initialRegion={{
                latitude: (selectedBuilding.lat + selectedParking.lat) / 2,
                longitude: (selectedBuilding.lng + selectedParking.lng) / 2,
                latitudeDelta: 0.005,
                longitudeDelta: 0.005,
              }}
              showsCompass
              showsScale
            >
              <Marker
                coordinate={{ latitude: selectedBuilding.lat, longitude: selectedBuilding.lng }}
                title={selectedBuilding.name}
                description="Your destination"
                pinColor="#3B82F6"
              />
              {rankedParking.map((p, idx) => (
                <Marker
                  key={p.id}
                  coordinate={{ latitude: p.lat, longitude: p.lng }}
                  title={p.name}
                  description={`${p.distanceM}m · ~${p.walkMinutes} min walk`}
                  pinColor={idx === 0 ? GREEN : "#F59E0B"}
                  onPress={() => setSelectedParking(p)}
                />
              ))}
              <Polyline
                coordinates={[
                  { latitude: selectedBuilding.lat, longitude: selectedBuilding.lng },
                  { latitude: selectedParking.lat, longitude: selectedParking.lng },
                ]}
                strokeColor={GREEN}
                strokeWidth={3}
                lineDashPattern={[8, 4]}
              />
            </MapView>
          </Animated.View>
        )}

        {/* ── Ranked Parking List ── */}
        {rankedParking.length > 0 && (
          <Animated.View style={{ opacity: fadeAnim }}>
            <Text style={styles.sectionHeading}>Ranked Parking Areas</Text>
            {rankedParking.map((p, idx) => (
              <TouchableOpacity
                key={p.id}
                style={[
                  styles.parkingItem,
                  selectedParking?.id === p.id && styles.parkingItemSelected,
                ]}
                onPress={() => {
                  setSelectedParking(p);
                  mapRef.current?.animateToRegion(
                    {
                      latitude: (selectedBuilding.lat + p.lat) / 2,
                      longitude: (selectedBuilding.lng + p.lng) / 2,
                      latitudeDelta: 0.005,
                      longitudeDelta: 0.005,
                    },
                    400
                  );
                }}
                activeOpacity={0.85}
              >
                <View style={[styles.rankBadge, idx === 0 && styles.rankBadgeBest]}>
                  <Text style={styles.rankText}>#{idx + 1}</Text>
                </View>
                <View style={styles.parkingItemContent}>
                  <Text style={styles.parkingItemName}>{p.name}</Text>
                  <Text style={styles.parkingItemSub}>
                    {p.distanceM}m · ~{p.walkMinutes} min walk
                  </Text>
                </View>
                {idx === 0 && (
                  <View style={styles.bestBadge}>
                    <Text style={styles.bestBadgeText}>Best</Text>
                  </View>
                )}
                {selectedParking?.id === p.id && (
                  <Ionicons name="checkmark-circle" size={20} color={GREEN} style={{ marginLeft: 6 }} />
                )}
              </TouchableOpacity>
            ))}
          </Animated.View>
        )}

        {/* ── Save / Find Car Card ── */}
        <View style={styles.card}>
          <View style={styles.cardHeader}>
            <View style={styles.cardIconBg}>
              <Ionicons name="car" size={20} color={GREEN} />
            </View>
            <Text style={styles.cardTitle}>My Parking Spot</Text>
          </View>

          {carLocation && (
            <View style={styles.savedSpotInfo}>
              <Ionicons name="location" size={14} color={GREEN} />
              <Text style={styles.savedSpotText}>
                Spot saved · {carLocation.latitude.toFixed(5)}, {carLocation.longitude.toFixed(5)}
              </Text>
            </View>
          )}

          <View style={styles.actionsRow}>
            <TouchableOpacity
              style={[styles.actionBtn, savingSpot && styles.actionBtnLoading]}
              onPress={handleSaveSpot}
              activeOpacity={0.85}
              disabled={savingSpot}
            >
              <Ionicons name="bookmark" size={17} color="#fff" style={{ marginRight: 6 }} />
              <Text style={styles.actionBtnText}>
                {savingSpot ? "Saving…" : "Save My Spot"}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[
                styles.actionBtn,
                styles.actionBtnOutline,
                (!carLocation || loadingLocation) && styles.actionBtnDisabled,
              ]}
              onPress={handleFindCar}
              activeOpacity={0.85}
              disabled={!carLocation || loadingLocation}
            >
              <Ionicons
                name="navigate"
                size={17}
                color={carLocation ? GREEN : "#9CA3AF"}
                style={{ marginRight: 6 }}
              />
              <Text style={[
                styles.actionBtnText,
                styles.actionBtnOutlineText,
                !carLocation && { color: "#9CA3AF" },
              ]}>
                {loadingLocation ? "Locating…" : "Find My Car"}
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* ── Find My Car Map ── */}
        {mapMode === "findCar" && userLocation && carLocation && (
          <View style={styles.mapCard}>
            <View style={styles.mapLabelRow}>
              <Ionicons name="navigate-circle" size={16} color="#3B82F6" />
              <Text style={[styles.mapLabel, { color: "#3B82F6" }]}>
                Navigate to Your Car
              </Text>
              <Text style={styles.mapDistance}>
                {distBetween(userLocation, carLocation)}m away
              </Text>
            </View>
            <MapView
              ref={mapRef}
              style={styles.map}
              provider={PROVIDER_GOOGLE}
              initialRegion={{
                latitude: (userLocation.latitude + carLocation.latitude) / 2,
                longitude: (userLocation.longitude + carLocation.longitude) / 2,
                latitudeDelta: 0.004,
                longitudeDelta: 0.004,
              }}
              showsUserLocation
              showsMyLocationButton
              showsCompass
            >
              <Marker
                coordinate={userLocation}
                title="You are here"
                pinColor="#3B82F6"
              />
              <Marker
                coordinate={carLocation}
                title="Your Car"
                pinColor={GREEN}
              />
              <Polyline
                coordinates={[userLocation, carLocation]}
                strokeColor="#3B82F6"
                strokeWidth={3}
                lineDashPattern={[10, 5]}
              />
            </MapView>
          </View>
        )}

        <View style={{ height: 40 }} />
      </ScrollView>
    </View>
  );
}

/* ─── Styles ─────────────────────────────────────────────────────── */
const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#F3F4F6" },

  header: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 16,
    paddingTop: Platform.OS === "android" ? 12 : 4,
    paddingBottom: 12,
    backgroundColor: "#F3F4F6",
  },
  backBtn: {
    width: 38,
    height: 38,
    borderRadius: 10,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.07,
    shadowRadius: 3,
    elevation: 2,
  },
  headerCenter: { alignItems: "center" },
  headerTitle: { fontSize: 20, fontWeight: "700", color: "#111827" },
  headerSub: { fontSize: 12, color: "#6B7A8D", marginTop: 1 },

  scrollContent: { paddingHorizontal: 16, paddingTop: 8, paddingBottom: 40 },

  card: {
    backgroundColor: "#fff",
    borderRadius: 16,
    padding: 18,
    marginBottom: 14,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.06,
    shadowRadius: 8,
    elevation: 3,
  },
  cardHeader: { flexDirection: "row", alignItems: "center", marginBottom: 14 },
  cardIconBg: {
    width: 34,
    height: 34,
    borderRadius: 9,
    backgroundColor: "#DCFCE7",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 10,
  },
  cardTitle: { fontSize: 16, fontWeight: "700", color: "#111827" },

  sectionLabel: {
    fontSize: 13,
    fontWeight: "600",
    color: "#374151",
    marginBottom: 8,
    letterSpacing: 0.2,
  },
  sectionHeading: {
    fontSize: 15,
    fontWeight: "700",
    color: "#111827",
    marginBottom: 10,
    marginTop: 2,
  },

  pickerBox: {
    flexDirection: "row",
    alignItems: "center",
    borderWidth: 1,
    borderColor: "#E5E7EB",
    borderRadius: 12,
    marginBottom: 14,
    backgroundColor: "#FAFAFA",
    paddingLeft: 10,
    overflow: "hidden",
  },
  pickerIcon: { marginRight: 4 },
  picker: { flex: 1, color: "#111827" },

  primaryBtn: {
    backgroundColor: GREEN,
    flexDirection: "row",
    paddingVertical: 14,
    borderRadius: 12,
    alignItems: "center",
    justifyContent: "center",
    shadowColor: GREEN,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 5,
  },
  primaryBtnText: { color: "#fff", fontSize: 15, fontWeight: "700" },

  parkingItem: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "#fff",
    borderRadius: 14,
    padding: 14,
    marginBottom: 10,
    borderWidth: 2,
    borderColor: "transparent",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.04,
    shadowRadius: 5,
    elevation: 2,
  },
  parkingItemSelected: { borderColor: GREEN, backgroundColor: "#F0FDF4" },
  rankBadge: {
    width: 30,
    height: 30,
    borderRadius: 8,
    backgroundColor: "#F3F4F6",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 12,
  },
  rankBadgeBest: { backgroundColor: "#DCFCE7" },
  rankText: { fontSize: 12, fontWeight: "700", color: "#374151" },
  parkingItemContent: { flex: 1 },
  parkingItemName: { fontSize: 14, fontWeight: "700", color: "#111827" },
  parkingItemSub: { fontSize: 12, color: "#6B7A8D", marginTop: 2 },
  bestBadge: {
    backgroundColor: GREEN,
    borderRadius: 8,
    paddingHorizontal: 8,
    paddingVertical: 3,
    marginLeft: 8,
  },
  bestBadgeText: { fontSize: 11, fontWeight: "700", color: "#fff" },

  savedSpotInfo: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "#F0FDF4",
    borderRadius: 8,
    paddingHorizontal: 10,
    paddingVertical: 6,
    marginBottom: 12,
    gap: 6,
  },
  savedSpotText: { fontSize: 12, color: "#166534", fontWeight: "500", flex: 1 },

  actionsRow: { flexDirection: "row", gap: 10 },
  actionBtn: {
    flex: 1,
    backgroundColor: GREEN,
    flexDirection: "row",
    paddingVertical: 13,
    borderRadius: 12,
    alignItems: "center",
    justifyContent: "center",
    shadowColor: GREEN,
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.25,
    shadowRadius: 6,
    elevation: 4,
  },
  actionBtnOutline: {
    backgroundColor: "#fff",
    borderWidth: 2,
    borderColor: GREEN,
    shadowColor: "#000",
    shadowOpacity: 0.04,
    elevation: 1,
  },
  actionBtnDisabled: { opacity: 0.45, borderColor: "#D1D5DB" },
  actionBtnLoading: { opacity: 0.7 },
  actionBtnText: { color: "#fff", fontSize: 14, fontWeight: "700" },
  actionBtnOutlineText: { color: GREEN },

  mapCard: {
    backgroundColor: "#fff",
    borderRadius: 16,
    overflow: "hidden",
    marginBottom: 14,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.07,
    shadowRadius: 8,
    elevation: 4,
  },
  mapLabelRow: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 14,
    paddingVertical: 10,
    gap: 6,
  },
  mapLabel: { fontSize: 14, fontWeight: "700", color: GREEN, flex: 1 },
  mapDistance: { fontSize: 13, fontWeight: "600", color: "#6B7A8D" },
  map: { height: 300, width: "100%" },
});
