import Foundation

// 1:1 port of BLOCKS array from src/data/blocks.ts
// Every id, name, short, category, lat, lng, description is copied verbatim.

extension CampusBlock {
    static let all: [CampusBlock] = [
        CampusBlock(id: "main_gate", name: "Main Campus Gate",                  short: "GATE",   category: .gate,     lat: 12.821172, lng: 80.037893, description: "Main entrance from GST Road"),
        CampusBlock(id: "arch_gate", name: "Arch Gate",                         short: "ARCH G", category: .gate,     lat: 12.822998, lng: 80.041261, description: "Iconic arch entrance gate"),
        CampusBlock(id: "tp1",       name: "Tech Park Tower I",                 short: "TP-I",   category: .academic, lat: 12.824760, lng: 80.045193, description: "CSE, IT & Computing Depts"),
        CampusBlock(id: "tp2",       name: "Tech Park Tower II",                short: "TP-II",  category: .academic, lat: 12.824595, lng: 80.045874, description: "ECE, EEE Departments"),
        CampusBlock(id: "ub",        name: "University Building",               short: "UB",     category: .academic, lat: 12.823594, lng: 80.042616, description: "Academic, VC & Registrar offices"),
        CampusBlock(id: "crc",       name: "Class Room Complex",                short: "CRC",    category: .academic, lat: 12.820402, lng: 80.037989, description: "Lecture halls & classrooms"),
        CampusBlock(id: "civil",     name: "Civil Engineering Block",           short: "CIVIL",  category: .academic, lat: 12.820171, lng: 80.038536, description: "Civil & Structural Engg"),
        CampusBlock(id: "auto",      name: "Automobile Engineering Block",      short: "AUTO",   category: .academic, lat: 12.820309, lng: 80.039336, description: "Automobile Engineering"),
        CampusBlock(id: "arch",      name: "School of Architecture & Interior", short: "ARCH",   category: .academic, lat: 12.824106, lng: 80.044202, description: "Architecture & Interior Design"),
        CampusBlock(id: "mbo",       name: "Faculty of Management (MBO)",       short: "MBA",    category: .academic, lat: 12.823708, lng: 80.044223, description: "MBA & Management Studies"),
        CampusBlock(id: "mca",       name: "Mechanical Block A",                short: "MC-A",   category: .academic, lat: 12.820521, lng: 80.039156, description: "Mechanical Engg Block A"),
        CampusBlock(id: "mhg",       name: "Mechanical Hangar",                 short: "M-HGR",  category: .lab,      lat: 12.820528, lng: 80.040002, description: "Heavy machinery & workshop"),
        CampusBlock(id: "hitech",    name: "Hi-Tech Block",                     short: "HITECH", category: .lab,      lat: 12.820995, lng: 80.038911, description: "Advanced computing & R&D labs"),
        CampusBlock(id: "bel",       name: "Basic Engineering Lab",             short: "BEL",    category: .lab,      lat: 12.823165, lng: 80.043492, description: "First year engineering labs"),
        CampusBlock(id: "fab",       name: "Fab Lab",                           short: "FAB",    category: .lab,      lat: 12.822390, lng: 80.045563, description: "Fabrication & prototyping lab"),
        CampusBlock(id: "cvr",       name: "Sir C.V. Raman Research Park",      short: "CVR",    category: .lab,      lat: 12.824925, lng: 80.044418, description: "Innovation & research park"),
        CampusBlock(id: "tpg",       name: "Dr. T.P. Ganesan Auditorium",       short: "AUDIT",  category: .facility, lat: 12.824436, lng: 80.046502, description: "Main campus auditorium"),
        CampusBlock(id: "vfs",       name: "Vendhar Food Street",               short: "VFS",    category: .food,     lat: 12.823776, lng: 80.045528, description: "Campus food street"),
        CampusBlock(id: "java",      name: "Java Canteen",                      short: "JAVA",   category: .food,     lat: 12.823081, lng: 80.044580, description: "Popular campus cafe"),
        CampusBlock(id: "aqc",       name: "Aquatic Complex",                   short: "POOL",   category: .sports,   lat: 12.825128, lng: 80.050677, description: "Olympic swimming pool"),
        CampusBlock(id: "dhyan",     name: "Dhyan Chand Indoor Stadium",        short: "STAD",   category: .sports,   lat: 12.825056, lng: 80.048836, description: "Main indoor stadium"),
    ]
}

// Campus centre used as MapKit initial region
// mirrors CAMPUS_CENTER in CampusMapScreen.native.tsx
let CAMPUS_CENTER_LAT: Double = 12.82250
let CAMPUS_CENTER_LNG: Double = 80.04420
