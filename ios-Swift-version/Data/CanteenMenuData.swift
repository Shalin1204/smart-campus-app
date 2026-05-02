import Foundation

// Full 1:1 port of RAW_MENU (HR05_MENU + Queens Court) from CanteenScreen.tsx

extension MenuItem {
    static let all: [MenuItem] = hr05Menu + queensMenu

    // ── HR05 Food Plaza ──────────────────────────────────────────────────────

    static let hr05Menu: [MenuItem] = [

        // Starters Veg
        MenuItem(id: makeMenuId("hr05", "Achari Chaap Tikka"),       name: "Achari Chaap Tikka",       price: 200, isVeg: true,  category: "Starters Veg",    restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Masala Chaap Tikka"),        name: "Masala Chaap Tikka",        price: 220, isVeg: true,  category: "Starters Veg",    restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Malai Chaap Tikka"),         name: "Malai Chaap Tikka",         price: 250, isVeg: true,  category: "Starters Veg",    restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Haryali Paneer Tikka"),      name: "Haryali Paneer Tikka",      price: 250, isVeg: true,  category: "Starters Veg",    restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Achari Paneer Tikka"),       name: "Achari Paneer Tikka",       price: 230, isVeg: true,  category: "Starters Veg",    restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Tikka"),              name: "Paneer Tikka",              price: 200, isVeg: true,  category: "Starters Veg",    restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Malai Paneer Tikka"),        name: "Malai Paneer Tikka",        price: 250, isVeg: true,  category: "Starters Veg",    restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Mushroom Malai Tikka"),      name: "Mushroom Malai Tikka",      price: 250, isVeg: true,  category: "Starters Veg",    restaurant: "HR05 Food Plaza"),

        // Starters Non-Veg
        MenuItem(id: makeMenuId("hr05", "Chicken Tikka"),             name: "Chicken Tikka",             price: 250, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Malai Tikka"),       name: "Chicken Malai Tikka",       price: 300, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Haryali Tikka"),     name: "Chicken Haryali Tikka",     price: 300, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Kali Mirch Tikka"),  name: "Chicken Kali Mirch Tikka",  price: 300, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Achari Tikka"),      name: "Chicken Achari Tikka",      price: 300, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Tandoori Chicken (Half)"),   name: "Tandoori Chicken (Half)",   price: 200, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Tandoori Chicken (Full)"),   name: "Tandoori Chicken (Full)",   price: 400, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Afghani Chicken (Half)"),    name: "Afghani Chicken (Half)",    price: 300, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Afghani Chicken (Full)"),    name: "Afghani Chicken (Full)",    price: 600, isVeg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza"),

        // Parathas
        MenuItem(id: makeMenuId("hr05", "Aloo Paratha"),              name: "Aloo Paratha",              price: 60,  isVeg: true,  category: "Parathas",         restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Gobi Paratha"),              name: "Gobi Paratha",              price: 70,  isVeg: true,  category: "Parathas",         restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Onion Paratha"),             name: "Onion Paratha",             price: 70,  isVeg: true,  category: "Parathas",         restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Paratha"),            name: "Paneer Paratha",            price: 80,  isVeg: true,  category: "Parathas",         restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Mix Paratha"),               name: "Mix Paratha",               price: 100, isVeg: true,  category: "Parathas",         restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Tandoori Chicken Paratha"),  name: "Tandoori Chicken Paratha",  price: 110, isVeg: false, category: "Parathas",         restaurant: "HR05 Food Plaza"),

        // Raita
        MenuItem(id: makeMenuId("hr05", "Plain Raita"),               name: "Plain Raita",               price: 80,  isVeg: true,  category: "Raita",            restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Boondi Raita"),              name: "Boondi Raita",              price: 100, isVeg: true,  category: "Raita",            restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Mix Raita"),                 name: "Mix Raita",                 price: 150, isVeg: true,  category: "Raita",            restaurant: "HR05 Food Plaza"),

        // Fast Food
        MenuItem(id: makeMenuId("hr05", "Veg Chowmein"),              name: "Veg Chowmein",              price: 130, isVeg: true,  category: "Fast Food",        restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Chowmein"),           name: "Paneer Chowmein",           price: 150, isVeg: true,  category: "Fast Food",        restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Chowmein"),          name: "Chicken Chowmein",          price: 200, isVeg: false, category: "Fast Food",        restaurant: "HR05 Food Plaza"),

        // Rice Combo
        MenuItem(id: makeMenuId("hr05", "Rajma Chawal"),              name: "Rajma Chawal",              price: 150, isVeg: true,  category: "Rice Combo",       restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chole Chawal"),              name: "Chole Chawal",              price: 120, isVeg: true,  category: "Rice Combo",       restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Dal Chawal"),                name: "Dal Chawal",                price: 120, isVeg: true,  category: "Rice Combo",       restaurant: "HR05 Food Plaza"),

        // Main Course Veg
        MenuItem(id: makeMenuId("hr05", "Dal Makhani"),               name: "Dal Makhani",               price: 180, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Dal Fry"),                   name: "Dal Fry",                   price: 150, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Dal Tadka"),                 name: "Dal Tadka",                 price: 150, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Bhindi Masala"),             name: "Bhindi Masala",             price: 150, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Shahi Paneer"),              name: "Shahi Paneer",              price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Kadai Paneer"),              name: "Kadai Paneer",              price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Butter Masala"),      name: "Paneer Butter Masala",      price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Tikka Butter Masala"),name: "Paneer Tikka Butter Masala",price: 280, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Bhurji"),             name: "Paneer Bhurji",             price: 280, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Do Pyaza"),           name: "Paneer Do Pyaza",           price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Handi"),              name: "Paneer Handi",              price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Matar Paneer"),              name: "Matar Paneer",              price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Palak Paneer"),              name: "Palak Paneer",              price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Aloo Palak"),                name: "Aloo Palak",                price: 180, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Palak Kofta"),               name: "Palak Kofta",               price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Kali Mirch"),         name: "Paneer Kali Mirch",         price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Lababdar"),           name: "Paneer Lababdar",           price: 250, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Punjabi"),            name: "Paneer Punjabi",            price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chana Masala"),              name: "Chana Masala",              price: 180, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Mushroom Masala"),           name: "Mushroom Masala",           price: 220, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Butter Chaap"),              name: "Butter Chaap",              price: 200, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Malai Chaap"),               name: "Malai Chaap",               price: 250, isVeg: true,  category: "Main Course",      restaurant: "HR05 Food Plaza"),

        // Rice
        MenuItem(id: makeMenuId("hr05", "Plain Rice"),                name: "Plain Rice",                price: 70,  isVeg: true,  category: "Rice",             restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Jeera Rice"),                name: "Jeera Rice",                price: 100, isVeg: true,  category: "Rice",             restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Veg Pulao"),                 name: "Veg Pulao",                 price: 120, isVeg: true,  category: "Rice",             restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Veg Fried Rice"),            name: "Veg Fried Rice",            price: 130, isVeg: true,  category: "Rice",             restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Fried Rice"),         name: "Paneer Fried Rice",         price: 150, isVeg: true,  category: "Rice",             restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Fried Rice"),        name: "Chicken Fried Rice",        price: 160, isVeg: false, category: "Rice",             restaurant: "HR05 Food Plaza"),

        // Biryani
        MenuItem(id: makeMenuId("hr05", "Veg Biryani"),               name: "Veg Biryani",               price: 140, isVeg: true,  category: "Biryani",          restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Biryani"),            name: "Paneer Biryani",            price: 160, isVeg: true,  category: "Biryani",          restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Biryani"),           name: "Chicken Biryani",           price: 170, isVeg: false, category: "Biryani",          restaurant: "HR05 Food Plaza"),

        // Main Course Non-Veg
        MenuItem(id: makeMenuId("hr05", "Butter Chicken"),            name: "Butter Chicken",            price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Kadai Chicken"),             name: "Kadai Chicken",             price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Lemon Chicken"),             name: "Lemon Chicken",             price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Do Pyaza"),          name: "Chicken Do Pyaza",          price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Tikka Masala"),      name: "Chicken Tikka Masala",      price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Kali Mirch"),        name: "Chicken Kali Mirch",        price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Cream Chicken"),             name: "Cream Chicken",             price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Lababdar"),          name: "Chicken Lababdar",          price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Handi"),             name: "Chicken Handi",             price: 300, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Chicken Kali Mirch (Full)"), name: "Chicken Kali Mirch (Full)", price: 600, isVeg: false, category: "Main Course",      restaurant: "HR05 Food Plaza"),

        // Eggs
        MenuItem(id: makeMenuId("hr05", "Egg Bhurji"),                name: "Egg Bhurji",                price: 160, isVeg: false, category: "Eggs",             restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Egg Curry"),                 name: "Egg Curry",                 price: 200, isVeg: false, category: "Eggs",             restaurant: "HR05 Food Plaza"),

        // Breads
        MenuItem(id: makeMenuId("hr05", "Tandoori Roti"),             name: "Tandoori Roti",             price: 18,  isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Butter Roti"),               name: "Butter Roti",               price: 20,  isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Missi Roti"),                name: "Missi Roti",                price: 25,  isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Laccha Paratha"),            name: "Laccha Paratha",            price: 35,  isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Plain Naan"),                name: "Plain Naan",                price: 35,  isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Butter Naan"),               name: "Butter Naan",               price: 40,  isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Garlic Naan"),               name: "Garlic Naan",               price: 70,  isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Paneer Naan"),               name: "Paneer Naan",               price: 110, isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Stuff Naan"),                name: "Stuff Naan",                price: 90,  isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Kashmiri Naan"),             name: "Kashmiri Naan",             price: 120, isVeg: true,  category: "Breads",           restaurant: "HR05 Food Plaza"),

        // Beverages
        MenuItem(id: makeMenuId("hr05", "Sweet Lassi (Regular)"),     name: "Sweet Lassi (Regular)",     price: 30,  isVeg: true,  category: "Beverages",        restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Sweet Lassi (Large)"),       name: "Sweet Lassi (Large)",       price: 50,  isVeg: true,  category: "Beverages",        restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Butter Milk"),               name: "Butter Milk",               price: 30,  isVeg: true,  category: "Beverages",        restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Curd"),                      name: "Curd",                      price: 30,  isVeg: true,  category: "Beverages",        restaurant: "HR05 Food Plaza"),

        // Thali
        MenuItem(id: makeMenuId("hr05", "Veg Thali"),                 name: "Veg Thali",                 price: 60,  isVeg: true,  category: "Thali",            restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Non Veg Thali"),             name: "Non Veg Thali",             price: 80,  isVeg: false, category: "Thali",            restaurant: "HR05 Food Plaza"),
        MenuItem(id: makeMenuId("hr05", "Amritsari Thali"),           name: "Amritsari Thali",           price: 120, isVeg: true,  category: "Thali",            restaurant: "HR05 Food Plaza"),
    ]

    // ── Queens Court ─────────────────────────────────────────────────────────

    static let queensMenu: [MenuItem] = [
        MenuItem(id: makeMenuId("queens", "Chicken Biryani (Half)"),  name: "Chicken Biryani (Half)",    price: 90,  isVeg: false, category: "Biryani",          restaurant: "Queens Court"),
        MenuItem(id: makeMenuId("queens", "Chicken Biryani (Full)"),  name: "Chicken Biryani (Full)",    price: 150, isVeg: false, category: "Biryani",          restaurant: "Queens Court"),
        MenuItem(id: makeMenuId("queens", "Egg Biryani (Half)"),      name: "Egg Biryani (Half)",        price: 55,  isVeg: false, category: "Biryani",          restaurant: "Queens Court"),
        MenuItem(id: makeMenuId("queens", "Egg Biryani (Full)"),      name: "Egg Biryani (Full)",        price: 90,  isVeg: false, category: "Biryani",          restaurant: "Queens Court"),
        MenuItem(id: makeMenuId("queens", "Plain Biryani (Half)"),    name: "Plain Biryani (Half)",      price: 50,  isVeg: true,  category: "Biryani",          restaurant: "Queens Court"),
        MenuItem(id: makeMenuId("queens", "Plain Biryani (Full)"),    name: "Plain Biryani (Full)",      price: 80,  isVeg: true,  category: "Biryani",          restaurant: "Queens Court"),
        MenuItem(id: makeMenuId("queens", "Veg Biryani (Half)"),      name: "Veg Biryani (Half)",        price: 75,  isVeg: true,  category: "Biryani",          restaurant: "Queens Court"),
        MenuItem(id: makeMenuId("queens", "Veg Biryani (Full)"),      name: "Veg Biryani (Full)",        price: 110, isVeg: true,  category: "Biryani",          restaurant: "Queens Court"),
    ]
}
