export type ParkingArea = {
  id: number;
  name: string;
  lat: number;
  lng: number;
};

export const parkingAreas: ParkingArea[] = [
  {
    id: 1,
    name: "Main Gate Parking",
    lat: 12.8232,
    lng: 80.0454,
  },
  {
    id: 2,
    name: "Tech Park Parking",
    lat: 12.824,
    lng: 80.0461,
  },
  {
    id: 3,
    name: "Library Parking",
    lat: 12.8238,
    lng: 80.0445,
  },
  {
    id: 4,
    name: "Hostel Parking",
    lat: 12.8252,
    lng: 80.0468,
  },
];
