/**
 * Web fallback for Parking ID screen.
 * react-native-maps is native-only — this file is loaded by Metro on web.
 */
import React from "react";
import { View, Text, StyleSheet } from "react-native";

export default function ParkingIDScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>🚗 Parking ID</Text>
      <Text style={styles.sub}>
        This feature is only available on the Android / iOS app.
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: "center", justifyContent: "center", padding: 32, backgroundColor: "#F3F4F6" },
  title: { fontSize: 24, fontWeight: "700", color: "#111827", marginBottom: 12 },
  sub: { fontSize: 15, color: "#6B7A8D", textAlign: "center", lineHeight: 22 },
});
