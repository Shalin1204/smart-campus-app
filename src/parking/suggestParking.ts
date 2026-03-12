import { calculateDistance } from "./distanceUtils";
import { parkingAreas } from "./parkingLocations";

export const suggestParking = (destination: any) => {
  let bestParking = parkingAreas[0];
  let shortestDistance = Infinity;

  for (let i = 0; i < parkingAreas.length; i++) {
    const parking = parkingAreas[i];

    const distance = calculateDistance(
      destination.lat,
      destination.lng,
      parking.lat,
      parking.lng,
    );

    if (distance < shortestDistance) {
      shortestDistance = distance;
      bestParking = parking;
    }
  }

  return bestParking;
};
