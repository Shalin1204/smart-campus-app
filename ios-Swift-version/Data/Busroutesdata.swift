import Foundation

// ── Direct port of busRoutes.ts ─────────────────────────────────────────────
// Every route/stop/time is copied 1:1 from the TypeScript data file.

extension BusRoute {
    static let all: [BusRoute] = [

        // Route 11 – Avadi
        BusRoute(routeNo: "11", routeName: "Avadi", stops: [
            BusStop(stop: "Avadi",                    time: "06:15"),
            BusStop(stop: "Decathlon Service Road",   time: "06:40"),
            BusStop(stop: "Porur Toll Gate",          time: "06:45"),
        ], campusArrival: "07:40"),

        // Route 11A – Waves
        BusRoute(routeNo: "11A", routeName: "Waves", stops: [
            BusStop(stop: "Waves",           time: "06:30"),
            BusStop(stop: "Collector Nagar", time: "06:32"),
            BusStop(stop: "Golden Flats",    time: "06:35"),
        ], campusArrival: "07:40"),

        // Route 11B – Ambattur
        BusRoute(routeNo: "11B", routeName: "Ambattur", stops: [
            BusStop(stop: "Ambattur OT",         time: "06:25"),
            BusStop(stop: "Telephone Exchange",  time: "06:32"),
            BusStop(stop: "Porur Toll Gate",     time: "06:53"),
        ], campusArrival: "07:40"),

        // Route 11C – Thirumullaivoyal
        BusRoute(routeNo: "11C", routeName: "Thirumullaivoyal", stops: [
            BusStop(stop: "VGN Apartments",    time: "06:20"),
            BusStop(stop: "Thirumullaivoyal",  time: "06:23"),
            BusStop(stop: "Saraswathi Nagar",  time: "06:25"),
            BusStop(stop: "Dunlop",            time: "06:28"),
            BusStop(stop: "Ambattur Estate",   time: "06:30"),
            BusStop(stop: "Wavin",             time: "06:35"),
        ], campusArrival: "07:40"),

        // Route 11D – Avadi (long)
        BusRoute(routeNo: "11D", routeName: "Avadi", stops: [
            BusStop(stop: "Avadi",            time: "06:05"),
            BusStop(stop: "Vaishnava College",time: "06:12"),
            BusStop(stop: "Saraswathi Nagar", time: "06:18"),
            BusStop(stop: "Ambattur OT",      time: "06:20"),
            BusStop(stop: "Dunlop",           time: "06:28"),
            BusStop(stop: "Ambattur Estate",  time: "06:30"),
            BusStop(stop: "Golden Flats",     time: "06:35"),
            BusStop(stop: "Collector Nagar",  time: "06:38"),
            BusStop(stop: "Thirumangalam",    time: "06:40"),
            BusStop(stop: "Nerkundram",       time: "06:50"),
            BusStop(stop: "Maduravoyal",      time: "07:00"),
            BusStop(stop: "Porur Toll Gate",  time: "07:05"),
        ], campusArrival: "07:40"),

        // Route 22 – Mylapore
        BusRoute(routeNo: "22", routeName: "Mylapore", stops: [
            BusStop(stop: "Ezhilagam (Kannagi Silai)", time: "06:05"),
            BusStop(stop: "V House",                   time: "06:08"),
            BusStop(stop: "Yellow Pages (Ajantha)",    time: "06:12"),
            BusStop(stop: "Valluvar Silai",            time: "06:15"),
            BusStop(stop: "Mylapore LUZ",              time: "06:18"),
        ], campusArrival: "07:40"),

        // Route 33 – Avichi School
        BusRoute(routeNo: "33", routeName: "Avichi School", stops: [
            BusStop(stop: "Avichi School",        time: "06:15"),
            BusStop(stop: "Mega Mart",            time: "06:18"),
            BusStop(stop: "Vembuliamman Kovil",   time: "06:20"),
            BusStop(stop: "Kesavarthini",         time: "06:22"),
            BusStop(stop: "Valasaravakkam",       time: "06:26"),
            BusStop(stop: "Butt Road",            time: "06:35"),
            BusStop(stop: "Tambaram Hindu Mission",time: "07:00"),
        ], campusArrival: "07:40"),

        // Route 33B – Porur Roundana
        BusRoute(routeNo: "33B", routeName: "Porur Roundana", stops: [
            BusStop(stop: "Porur Roundana",                  time: "06:20"),
            BusStop(stop: "Sakthi Nagar (Saravana Stores)",  time: "06:22"),
            BusStop(stop: "Mugalivakkam",                    time: "06:24"),
            BusStop(stop: "Ramapuram (MIOT)",                time: "06:26"),
        ], campusArrival: "07:40"),

        // Route 33C – Vanagaram
        BusRoute(routeNo: "33C", routeName: "Vanagaram", stops: [
            BusStop(stop: "Vanagaram Bus Stop",       time: "06:10"),
            BusStop(stop: "Velapanchavadi Bus Stop",  time: "06:15"),
            BusStop(stop: "Saveetha Dental College",  time: "06:20"),
            BusStop(stop: "Kumananchavadi Signal",    time: "06:24"),
            BusStop(stop: "Mangadu Bus Stop",         time: "06:27"),
            BusStop(stop: "Muthukumaran College",     time: "06:30"),
            BusStop(stop: "Kundrathur School",        time: "06:35"),
            BusStop(stop: "Kundrathur Bus Stand",     time: "06:38"),
            BusStop(stop: "Metha Nagar",              time: "06:40"),
            BusStop(stop: "Anakaputhur Bus Stop",     time: "06:45"),
            BusStop(stop: "Pammal Bus Stop",          time: "06:50"),
        ], campusArrival: "07:40"),

        // Route 55ECR – Neelangarai
        BusRoute(routeNo: "55ECR", routeName: "Neelangarai", stops: [
            BusStop(stop: "Neelangarai",          time: "05:55"),
            BusStop(stop: "Palavakkam",           time: "05:58"),
            BusStop(stop: "Kottivakkam",          time: "06:00"),
            BusStop(stop: "Thiruvanmiyur RTO",    time: "06:05"),
            BusStop(stop: "Thiruvanmiyur Kovil",  time: "06:08"),
            BusStop(stop: "Thiruvanmiyur JN",     time: "06:10"),
            BusStop(stop: "SRP Tools",            time: "06:15"),
            BusStop(stop: "Baby Nagar",           time: "06:20"),
        ], campusArrival: "07:40"),

        // Route 55A – Velachery
        BusRoute(routeNo: "55A", routeName: "Velachery", stops: [
            BusStop(stop: "Vijaya Nagar",        time: "06:25"),
            BusStop(stop: "Echangadu Signal",    time: "06:35"),
            BusStop(stop: "Vels College",        time: "06:40"),
        ], campusArrival: "07:40"),

        // Route 55B – Pallikaranai
        BusRoute(routeNo: "55B", routeName: "Pallikaranai", stops: [
            BusStop(stop: "Puzhudhivakkam (MRTS)",      time: "06:20"),
            BusStop(stop: "Pallikaranai Govt School",   time: "06:32"),
            BusStop(stop: "Pallikaranai Jayachandran",  time: "06:35"),
        ], campusArrival: "07:40"),

        // Route 55C – Santhosapuram
        BusRoute(routeNo: "55C", routeName: "Santhosapuram", stops: [
            BusStop(stop: "Santhosapuram",     time: "06:40"),
            BusStop(stop: "Sempakkam",         time: "06:41"),
            BusStop(stop: "Kamarajapuram",     time: "06:42"),
            BusStop(stop: "Mahalakshmi Nagar", time: "06:44"),
            BusStop(stop: "Selaiyur",          time: "06:47"),
            BusStop(stop: "Christ King School",time: "06:48"),
            BusStop(stop: "Air Force",         time: "06:50"),
        ], campusArrival: "07:40"),

        // Route 55D – Kaiveli
        BusRoute(routeNo: "55D", routeName: "Kaiveli", stops: [
            BusStop(stop: "Kaiveli",                time: "06:25"),
            BusStop(stop: "Balaji Dental College",  time: "06:32"),
            BusStop(stop: "Pallikaranai Oil Mill",  time: "06:40"),
        ], campusArrival: "07:40"),

        // Route 55E – Medavakkam
        BusRoute(routeNo: "55E", routeName: "Medavakkam", stops: [
            BusStop(stop: "Medavakkam (Nilgiris)", time: "06:30"),
            BusStop(stop: "Medavakkam X Road",     time: "06:32"),
            BusStop(stop: "Camp Road",             time: "06:35"),
        ], campusArrival: "07:40"),

        // Route 55F – Medavakkam (long)
        BusRoute(routeNo: "55F", routeName: "Medavakkam", stops: [
            BusStop(stop: "Vijaya Nagar",              time: "06:27"),
            BusStop(stop: "Kaiveli",                   time: "06:30"),
            BusStop(stop: "Balaji Dental College",     time: "06:35"),
            BusStop(stop: "Pallikaranai Jayachandran", time: "06:40"),
            BusStop(stop: "Vijaya Nagaram",            time: "06:45"),
            BusStop(stop: "Santhosapuram",             time: "06:47"),
            BusStop(stop: "Gowrivakkam",               time: "06:50"),
            BusStop(stop: "Kamarajapuram",             time: "06:52"),
            BusStop(stop: "Mahalakshmi Nagar",         time: "06:55"),
            BusStop(stop: "Camp Road",                 time: "07:00"),
            BusStop(stop: "Poondi Bazzar",             time: "07:03"),
        ], campusArrival: "07:40"),

        // Route 66 – Loyola College
        BusRoute(routeNo: "66", routeName: "Loyola College", stops: [
            BusStop(stop: "Valluvar Kottam",        time: "06:20"),
            BusStop(stop: "Loyola College",         time: "06:25"),
            BusStop(stop: "Choolaimedu",            time: "06:30"),
            BusStop(stop: "Metha Nagar",            time: "06:32"),
            BusStop(stop: "Ampa Mall",              time: "06:37"),
            BusStop(stop: "Maduravoyal (Erikarai)", time: "06:50"),
        ], campusArrival: "07:40"),

        // Route 66A – Thirumangalam (late route)
        BusRoute(routeNo: "66A", routeName: "Thirumangalam", stops: [
            BusStop(stop: "Anna Nagar Roundana", time: "10:30"),
            BusStop(stop: "Shanthi Colony",      time: "10:35"),
            BusStop(stop: "Thirumangalam",       time: "10:38"),
            BusStop(stop: "Rohini Theatre",      time: "10:40"),
        ], campusArrival: "10:59"),

        // Route 66B – Koyambedu
        BusRoute(routeNo: "66B", routeName: "Koyambedu", stops: [
            BusStop(stop: "SAF",                time: "06:22"),
            BusStop(stop: "MMDA",               time: "06:25"),
            BusStop(stop: "Ambica Empire",      time: "06:30"),
            BusStop(stop: "Vadapalani",         time: "06:32"),
            BusStop(stop: "Ashok Pillar",       time: "06:38"),
            BusStop(stop: "Kasi Theatre",       time: "06:40"),
            BusStop(stop: "Ekattuthangal",      time: "06:42"),
            BusStop(stop: "Guindy Kathipara",   time: "06:45"),
            BusStop(stop: "Chrompet MIT",       time: "07:00"),
            BusStop(stop: "Perungalathur",      time: "07:10"),
        ], campusArrival: "07:40"),

        // Route 88 – Nesapakkam
        BusRoute(routeNo: "88", routeName: "Nesapakkam", stops: [
            BusStop(stop: "Sathya School",           time: "06:25"),
            BusStop(stop: "Pondicherry Guest House", time: "06:27"),
            BusStop(stop: "Nesapakkam",              time: "06:30"),
            BusStop(stop: "Hotel Saravanabhavan",    time: "06:32"),
            BusStop(stop: "KK Nagar Depot",         time: "06:35"),
            BusStop(stop: "Chrompet",               time: "07:00"),
        ], campusArrival: "07:40"),

        // Route 122 – Manali
        BusRoute(routeNo: "122", routeName: "Manali", stops: [
            BusStop(stop: "Manali",                   time: "05:50"),
            BusStop(stop: "Pal Pannai",               time: "05:55"),
            BusStop(stop: "Thapalpetti",              time: "05:57"),
            BusStop(stop: "Moolakadai",               time: "06:00"),
            BusStop(stop: "Perambur Church",          time: "06:10"),
            BusStop(stop: "Agaram",                   time: "06:12"),
            BusStop(stop: "Don Bosco School",         time: "06:13"),
            BusStop(stop: "Kolathur Moogambigai",     time: "06:15"),
            BusStop(stop: "Retteri",                  time: "06:20"),
            BusStop(stop: "Temple School",            time: "06:22"),
            BusStop(stop: "Senthil Nagar",            time: "06:25"),
        ], campusArrival: "07:40"),

        // Route 122A – Redhills
        BusRoute(routeNo: "122A", routeName: "Redhills", stops: [
            BusStop(stop: "Redhills Bus Stand",                time: "06:00"),
            BusStop(stop: "Redhills Market",                   time: "06:03"),
            BusStop(stop: "Nallalaghu Nadar Polytechnic",      time: "06:05"),
            BusStop(stop: "Kavankarai",                        time: "06:07"),
            BusStop(stop: "Puzhal Signal",                     time: "06:10"),
            BusStop(stop: "Camp Signal",                       time: "06:13"),
            BusStop(stop: "Narayana School",                   time: "06:16"),
            BusStop(stop: "Vinayagapuram Bus Stop",            time: "06:18"),
            BusStop(stop: "Retteri Bridge",                    time: "06:20"),
        ], campusArrival: "07:40"),

        // Route 133 – Tiruvottiyur
        BusRoute(routeNo: "133", routeName: "Tiruvottiyur", stops: [
            BusStop(stop: "Ernavur Bridge",           time: "05:50"),
            BusStop(stop: "Wimco Nagar (Beach Road)", time: "05:51"),
            BusStop(stop: "Tiruvottiyur",             time: "05:53"),
            BusStop(stop: "Ellaiamman Kovil",         time: "05:55"),
            BusStop(stop: "Thangal",                  time: "05:57"),
            BusStop(stop: "N4 Police Station",        time: "06:00"),
            BusStop(stop: "Kasimedu Signal",          time: "06:01"),
            BusStop(stop: "Royapuram Police Station", time: "06:03"),
            BusStop(stop: "Royapuram Bridge Signal",  time: "06:05"),
            BusStop(stop: "Beach Station",            time: "06:08"),
            BusStop(stop: "Shanthi Theatre",          time: "06:15"),
            BusStop(stop: "DMS",                      time: "06:18"),
            BusStop(stop: "Teynampet Signal",         time: "06:20"),
            BusStop(stop: "Nanthanam Signal",         time: "06:22"),
            BusStop(stop: "Saidapet",                 time: "06:25"),
        ], campusArrival: "07:40"),

        // Route 144 – Kelleys
        BusRoute(routeNo: "144", routeName: "Kelleys", stops: [
            BusStop(stop: "Doveton",               time: "06:05"),
            BusStop(stop: "Dr. Alagappa Road",     time: "06:07"),
            BusStop(stop: "Ponniamman Koil",       time: "06:09"),
            BusStop(stop: "Kelleys",               time: "06:13"),
            BusStop(stop: "Senthil Hospital",      time: "06:15"),
            BusStop(stop: "Ayanavaram Signal",     time: "06:17"),
            BusStop(stop: "Noor Hotel",            time: "06:19"),
            BusStop(stop: "Joint Office",          time: "06:21"),
            BusStop(stop: "Railway Quarters",      time: "06:23"),
            BusStop(stop: "ICF",                   time: "06:25"),
            BusStop(stop: "Nathamuni",             time: "06:29"),
            BusStop(stop: "Anna Nagar West Depot", time: "06:34"),
        ], campusArrival: "07:40"),

        // Route 177 – Anna Nagar
        BusRoute(routeNo: "177", routeName: "Anna Nagar", stops: [
            BusStop(stop: "Korattur",                time: "06:05"),
            BusStop(stop: "Saravana Store (Padi)",   time: "06:08"),
            BusStop(stop: "Vasantham Colony",        time: "06:13"),
            BusStop(stop: "K4 Police Station",       time: "06:15"),
            BusStop(stop: "Lotus Colony",            time: "06:17"),
            BusStop(stop: "Chinthamani",             time: "06:18"),
            BusStop(stop: "Shenoy Nagar",            time: "06:20"),
            BusStop(stop: "Aminjikarai Market",      time: "06:21"),
            BusStop(stop: "Anna Arch",               time: "06:23"),
            BusStop(stop: "Arumbakkam",              time: "06:25"),
            BusStop(stop: "Rohini Theatre",          time: "06:28"),
            BusStop(stop: "Nerkundram",              time: "06:33"),
            BusStop(stop: "Porur Toll Gate",         time: "06:40"),
        ], campusArrival: "07:40"),

        // Route 188 – Thoraipakkam
        BusRoute(routeNo: "188", routeName: "Thoraipakkam", stops: [
            BusStop(stop: "Thoraipakkam",           time: "06:00"),
            BusStop(stop: "PTC Mettu Kuppam",       time: "06:05"),
            BusStop(stop: "Karappakkam",            time: "06:10"),
            BusStop(stop: "Sholinganallur Junction",time: "06:15"),
            BusStop(stop: "Sathyabama",             time: "06:20"),
            BusStop(stop: "Navalur Signal",         time: "06:26"),
        ], campusArrival: "07:40"),

        // Route 188A – Siruseri
        BusRoute(routeNo: "188A", routeName: "Siruseri", stops: [
            BusStop(stop: "Siruseri (Sipcot)",              time: "06:30"),
            BusStop(stop: "Kazhipattur (TVH Apartment)",    time: "06:32"),
            BusStop(stop: "Padur",                          time: "06:35"),
            BusStop(stop: "Hindustan College",              time: "06:37"),
            BusStop(stop: "Chettinadu Hospital",            time: "06:39"),
            BusStop(stop: "Kelambakkam Junction",           time: "06:40"),
            BusStop(stop: "Pudhupakkam",                    time: "06:44"),
            BusStop(stop: "Pudhupakkam (Anjaneyar Kovil)",  time: "06:46"),
            BusStop(stop: "Mampakkam",                      time: "06:50"),
            BusStop(stop: "Keezhkottaiyur",                 time: "06:55"),
            BusStop(stop: "Kandigai",                       time: "07:00"),
            BusStop(stop: "Kolappakkam",                    time: "07:05"),
            BusStop(stop: "Vandalur",                       time: "07:10"),
        ], campusArrival: "07:40"),
    ]
}