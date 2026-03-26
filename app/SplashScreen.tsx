import React, { useEffect } from "react";
import { View, StyleSheet } from "react-native";
import { Image } from "expo-image";
import { useRouter } from "expo-router";

export default function SplashScreen() {
  const router = useRouter();

  useEffect(() => {
    const timer = setTimeout(() => {
      router.replace("/DashboardScreen");
    }, 3000);

    return () => clearTimeout(timer);
  }, [router]);

  return (
    <View style={styles.container}>
      <Image
        source={require("../assets/images/intro.gif")}
        style={styles.gif}
        contentFit="contain"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#ffffff",
  },
  gif: {
    width: 250,
    height: 250,
  },
});
