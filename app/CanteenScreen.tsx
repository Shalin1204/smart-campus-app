import React, { useState } from 'react';
import {
  View, Text, StyleSheet, TouchableOpacity,
  ScrollView, StatusBar, TextInput
} from 'react-native';
import { useRouter } from 'expo-router';

/* TYPES */

type MenuItem = {
  id: string;
  name: string;
  price: number;
  veg: boolean;
  category: string;
  restaurant: string;
};

type CartItem = MenuItem & { qty: number };

/* DATA */

function makeId(restaurant: string, name: string) {
  return `${restaurant}_${name}`.replace(/\s+/g, '_').toLowerCase();
}

const HR05_MENU: MenuItem[] = [
  // Starters Veg
  { id: makeId("hr05", "Achari Chaap Tikka"), name: "Achari Chaap Tikka", price: 200, veg: true, category: "Starters Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Masala Chaap Tikka"), name: "Masala Chaap Tikka", price: 220, veg: true, category: "Starters Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Malai Chaap Tikka"), name: "Malai Chaap Tikka", price: 250, veg: true, category: "Starters Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Haryali Paneer Tikka"), name: "Haryali Paneer Tikka", price: 250, veg: true, category: "Starters Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Achari Paneer Tikka"), name: "Achari Paneer Tikka", price: 230, veg: true, category: "Starters Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Tikka"), name: "Paneer Tikka", price: 200, veg: true, category: "Starters Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Malai Paneer Tikka"), name: "Malai Paneer Tikka", price: 250, veg: true, category: "Starters Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Mushroom Malai Tikka"), name: "Mushroom Malai Tikka", price: 250, veg: true, category: "Starters Veg", restaurant: "HR05 Food Plaza" },

  // Starters Non-Veg
  { id: makeId("hr05", "Chicken Tikka"), name: "Chicken Tikka", price: 250, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Malai Tikka"), name: "Chicken Malai Tikka", price: 300, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Haryali Tikka"), name: "Chicken Haryali Tikka", price: 300, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Kali Mirch Tikka"), name: "Chicken Kali Mirch Tikka", price: 300, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Achari Tikka"), name: "Chicken Achari Tikka", price: 300, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Tandoori Chicken (Half)"), name: "Tandoori Chicken (Half)", price: 200, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Tandoori Chicken (Full)"), name: "Tandoori Chicken (Full)", price: 400, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Afghani Chicken (Half)"), name: "Afghani Chicken (Half)", price: 300, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Afghani Chicken (Full)"), name: "Afghani Chicken (Full)", price: 600, veg: false, category: "Starters Non-Veg", restaurant: "HR05 Food Plaza" },

  // Parathas
  { id: makeId("hr05", "Aloo Paratha"), name: "Aloo Paratha", price: 60, veg: true, category: "Parathas", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Gobi Paratha"), name: "Gobi Paratha", price: 70, veg: true, category: "Parathas", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Onion Paratha"), name: "Onion Paratha", price: 70, veg: true, category: "Parathas", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Paratha"), name: "Paneer Paratha", price: 80, veg: true, category: "Parathas", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Mix Paratha"), name: "Mix Paratha", price: 100, veg: true, category: "Parathas", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Tandoori Chicken Paratha"), name: "Tandoori Chicken Paratha", price: 110, veg: false, category: "Parathas", restaurant: "HR05 Food Plaza" },

  // Raita
  { id: makeId("hr05", "Plain Raita"), name: "Plain Raita", price: 80, veg: true, category: "Raita", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Boondi Raita"), name: "Boondi Raita", price: 100, veg: true, category: "Raita", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Mix Raita"), name: "Mix Raita", price: 150, veg: true, category: "Raita", restaurant: "HR05 Food Plaza" },

  // Fast Food
  { id: makeId("hr05", "Veg Chowmein"), name: "Veg Chowmein", price: 130, veg: true, category: "Fast Food", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Chowmein"), name: "Paneer Chowmein", price: 150, veg: true, category: "Fast Food", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Chowmein"), name: "Chicken Chowmein", price: 200, veg: false, category: "Fast Food", restaurant: "HR05 Food Plaza" },

  // Rice Combo
  { id: makeId("hr05", "Rajma Chawal"), name: "Rajma Chawal", price: 150, veg: true, category: "Rice Combo", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chole Chawal"), name: "Chole Chawal", price: 120, veg: true, category: "Rice Combo", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Dal Chawal"), name: "Dal Chawal", price: 120, veg: true, category: "Rice Combo", restaurant: "HR05 Food Plaza" },

  // Main Course Veg
  { id: makeId("hr05", "Dal Makhani"), name: "Dal Makhani", price: 180, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Dal Fry"), name: "Dal Fry", price: 150, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Dal Tadka"), name: "Dal Tadka", price: 150, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Bhindi Masala"), name: "Bhindi Masala", price: 150, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Shahi Paneer"), name: "Shahi Paneer", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Kadai Paneer"), name: "Kadai Paneer", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Butter Masala"), name: "Paneer Butter Masala", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Tikka Butter Masala"), name: "Paneer Tikka Butter Masala", price: 280, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Bhurji"), name: "Paneer Bhurji", price: 280, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Do Pyaza"), name: "Paneer Do Pyaza", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Handi"), name: "Paneer Handi", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Matar Paneer"), name: "Matar Paneer", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Palak Paneer"), name: "Palak Paneer", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Aloo Palak"), name: "Aloo Palak", price: 180, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Palak Kofta"), name: "Palak Kofta", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Kali Mirch"), name: "Paneer Kali Mirch", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Lababdar"), name: "Paneer Lababdar", price: 250, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Punjabi"), name: "Paneer Punjabi", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chana Masala"), name: "Chana Masala", price: 180, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Mushroom Masala"), name: "Mushroom Masala", price: 220, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Butter Chaap"), name: "Butter Chaap", price: 200, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Malai Chaap"), name: "Malai Chaap", price: 250, veg: true, category: "Main Course", restaurant: "HR05 Food Plaza" },

  // Rice
  { id: makeId("hr05", "Plain Rice"), name: "Plain Rice", price: 70, veg: true, category: "Rice", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Jeera Rice"), name: "Jeera Rice", price: 100, veg: true, category: "Rice", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Veg Pulao"), name: "Veg Pulao", price: 120, veg: true, category: "Rice", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Veg Fried Rice"), name: "Veg Fried Rice", price: 130, veg: true, category: "Rice", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Veg Biryani"), name: "Veg Biryani", price: 140, veg: true, category: "Biryani", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Fried Rice"), name: "Paneer Fried Rice", price: 150, veg: true, category: "Rice", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Biryani"), name: "Paneer Biryani", price: 160, veg: true, category: "Biryani", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Fried Rice"), name: "Chicken Fried Rice", price: 160, veg: false, category: "Rice", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Biryani"), name: "Chicken Biryani", price: 170, veg: false, category: "Biryani", restaurant: "HR05 Food Plaza" },

  // Main Course Non-Veg
  { id: makeId("hr05", "Butter Chicken"), name: "Butter Chicken", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Kadai Chicken"), name: "Kadai Chicken", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Lemon Chicken"), name: "Lemon Chicken", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Do Pyaza"), name: "Chicken Do Pyaza", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Tikka Masala"), name: "Chicken Tikka Masala", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Kali Mirch"), name: "Chicken Kali Mirch", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Cream Chicken"), name: "Cream Chicken", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Lababdar"), name: "Chicken Lababdar", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Handi"), name: "Chicken Handi", price: 300, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Chicken Kali Mirch (Full)"), name: "Chicken Kali Mirch (Full)", price: 600, veg: false, category: "Main Course", restaurant: "HR05 Food Plaza" },

  // Eggs
  { id: makeId("hr05", "Egg Bhurji"), name: "Egg Bhurji", price: 160, veg: false, category: "Eggs", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Egg Curry"), name: "Egg Curry", price: 200, veg: false, category: "Eggs", restaurant: "HR05 Food Plaza" },

  // Breads
  { id: makeId("hr05", "Tandoori Roti"), name: "Tandoori Roti", price: 18, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Butter Roti"), name: "Butter Roti", price: 20, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Missi Roti"), name: "Missi Roti", price: 25, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Laccha Paratha"), name: "Laccha Paratha", price: 35, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Plain Naan"), name: "Plain Naan", price: 35, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Butter Naan"), name: "Butter Naan", price: 40, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Garlic Naan"), name: "Garlic Naan", price: 70, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Paneer Naan"), name: "Paneer Naan", price: 110, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Stuff Naan"), name: "Stuff Naan", price: 90, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Kashmiri Naan"), name: "Kashmiri Naan", price: 120, veg: true, category: "Breads", restaurant: "HR05 Food Plaza" },

  // Beverages
  { id: makeId("hr05", "Sweet Lassi (Regular)"), name: "Sweet Lassi (Regular)", price: 30, veg: true, category: "Beverages", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Sweet Lassi (Large)"), name: "Sweet Lassi (Large)", price: 50, veg: true, category: "Beverages", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Butter Milk"), name: "Butter Milk", price: 30, veg: true, category: "Beverages", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Curd"), name: "Curd", price: 30, veg: true, category: "Beverages", restaurant: "HR05 Food Plaza" },

  // Thali
  { id: makeId("hr05", "Veg Thali"), name: "Veg Thali", price: 60, veg: true, category: "Thali", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Non Veg Thali"), name: "Non Veg Thali", price: 80, veg: false, category: "Thali", restaurant: "HR05 Food Plaza" },
  { id: makeId("hr05", "Amritsari Thali"), name: "Amritsari Thali", price: 120, veg: true, category: "Thali", restaurant: "HR05 Food Plaza" }
];

const RAW_MENU: MenuItem[] = [
  ...HR05_MENU,
  { id: makeId("queens","Chicken Biryani (Half)"), name:"Chicken Biryani (Half)", price:90, veg:false, category:"Biryani", restaurant:"Queens Court"},
  { id: makeId("queens","Chicken Biryani (Full)"), name:"Chicken Biryani (Full)", price:150, veg:false, category:"Biryani", restaurant:"Queens Court"},
  { id: makeId("queens","Egg Biryani (Half)"), name:"Egg Biryani (Half)", price:55, veg:false, category:"Biryani", restaurant:"Queens Court"},
  { id: makeId("queens","Egg Biryani (Full)"), name:"Egg Biryani (Full)", price:90, veg:false, category:"Biryani", restaurant:"Queens Court"},
  { id: makeId("queens","Plain Biryani (Half)"), name:"Plain Biryani (Half)", price:50, veg:true, category:"Biryani", restaurant:"Queens Court"},
  { id: makeId("queens","Plain Biryani (Full)"), name:"Plain Biryani (Full)", price:80, veg:true, category:"Biryani", restaurant:"Queens Court"},
  { id: makeId("queens","Veg Biryani (Half)"), name:"Veg Biryani (Half)", price:75, veg:true, category:"Biryani", restaurant:"Queens Court"},
  { id: makeId("queens","Veg Biryani (Full)"), name:"Veg Biryani (Full)", price:110, veg:true, category:"Biryani", restaurant:"Queens Court"}
];

const RESTAURANTS = [
  { key:'All', label:'All'},
  { key:'HR05 Food Plaza', label:'HR05'},
  { key:'Queens Court', label:'Queens Court'}
];

const CATEGORIES = ['All', ...Array.from(new Set(RAW_MENU.map(i=>i.category)))];

/* CART */

function useCart(){
  const [cart,setCart] = useState<CartItem[]>([]);

  const add = (item:MenuItem)=>{
    setCart(prev=>{
      const found = prev.find(c=>c.id===item.id);
      if(found) return prev.map(c=>c.id===item.id?{...c,qty:c.qty+1}:c);
      return [...prev,{...item,qty:1}]
    })
  }

  const remove=(id:string)=>{
    setCart(prev=>{
      const found=prev.find(c=>c.id===id);
      if(!found) return prev;
      if(found.qty===1) return prev.filter(c=>c.id!==id);
      return prev.map(c=>c.id===id?{...c,qty:c.qty-1}:c)
    })
  }

  const qty=(id:string)=>cart.find(c=>c.id===id)?.qty ?? 0;
  const total=cart.reduce((s,c)=>s+c.price*c.qty,0);
  const count=cart.reduce((s,c)=>s+c.qty,0);

  const clear=()=>setCart([]);

  return {cart,add,remove,qty,total,count,clear}
}

/* VEG BADGE */

function VegBadge({veg}:{veg:boolean}){
  return(
    <View style={[styles.vegBadge,{borderColor:veg?'#16A34A':'#DC2626'}]}>
      <View style={[styles.vegDot,{backgroundColor:veg?'#16A34A':'#DC2626'}]}/>
    </View>
  )
}

/* MENU CARD */

function MenuCard({item,qty,onAdd,onRemove}:{item:MenuItem;qty:number;onAdd:()=>void;onRemove:()=>void}){
  return(
    <View style={styles.menuCard}>
      <VegBadge veg={item.veg}/>
      <View style={{flex:1,marginLeft:10}}>
        <Text style={styles.itemName}>{item.name}</Text>
        <Text style={styles.itemPrice}>₹{item.price}</Text>
      </View>

      {qty===0 ? (
        <TouchableOpacity style={styles.addBtn} onPress={onAdd}>
          <Text style={styles.addBtnText}>ADD</Text>
        </TouchableOpacity>
      ) : (
        <View style={styles.qtyRow}>
          <TouchableOpacity style={styles.qtyBtn} onPress={onRemove}>
            <Text style={styles.qtyBtnText}>−</Text>
          </TouchableOpacity>
          <Text style={styles.qtyNum}>{qty}</Text>
          <TouchableOpacity style={styles.qtyBtn} onPress={onAdd}>
            <Text style={styles.qtyBtnText}>+</Text>
          </TouchableOpacity>
        </View>
      )}
    </View>
  )
}

/* SCREEN */

export default function CanteenScreen(){

  const router = useRouter();
  const {cart,add,remove,qty,total,count,clear} = useCart();

  const [restaurant,setRestaurant] = useState('All');
  const [category,setCategory] = useState('All');
  const [vegOnly,setVegOnly] = useState(false);
  const [search,setSearch] = useState('');

  const filtered = RAW_MENU.filter(item =>
    (restaurant==='All'||item.restaurant===restaurant) &&
    (category==='All'||item.category===category) &&
    (!vegOnly||item.veg) &&
    item.name.toLowerCase().includes(search.toLowerCase())
  );

  const grouped = filtered.reduce<Record<string,MenuItem[]>>((acc,item)=>{
    if(!acc[item.category]) acc[item.category]=[];
    acc[item.category].push(item);
    return acc;
  },{})

  return(
  <View style={styles.container}>

    <StatusBar barStyle="dark-content" backgroundColor="#F8F9FB"/>

    {/* HEADER */}

    <View style={styles.header}>
      <TouchableOpacity onPress={()=>router.back()} style={styles.backBtn}>
        <Text style={styles.backText}>‹</Text>
      </TouchableOpacity>

      <View style={{flex:1}}>
        <Text style={styles.headerTitle}>
          {restaurant==="All"?"Food Court":restaurant}
        </Text>
        <Text style={styles.headerSub}>
          SRM KTR · {RAW_MENU.length} items
        </Text>
      </View>

      <Text style={styles.cartIcon}>🛒</Text>
    </View>

    {/* SEARCH */}

    <TextInput
      style={styles.search}
      placeholder="Search dishes..."
      value={search}
      onChangeText={setSearch}
    />

    {/* RESTAURANT TABS */}

    <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.tabs} style={styles.tabsScroll}>

      {RESTAURANTS.map(r=>(
        <TouchableOpacity
          key={r.key}
          onPress={()=>setRestaurant(r.key)}
          style={[styles.tab, restaurant===r.key && styles.tabActive]}>
          <Text style={[styles.tabText, restaurant===r.key && styles.tabTextActive]}>
            {r.label}
          </Text>
        </TouchableOpacity>
      ))}

      <TouchableOpacity
        onPress={()=>setVegOnly(!vegOnly)}
        style={[styles.vegToggle,vegOnly&&styles.vegToggleActive]}>

        <View style={[styles.vegDot,{backgroundColor:vegOnly?'#16A34A':'#9CA3AF',width:8,height:8}]}/>
        <Text style={styles.vegToggleText}>Veg Only</Text>

      </TouchableOpacity>

    </ScrollView>

    {/* MENU */}

    <ScrollView contentContainerStyle={styles.menuList}>

      {Object.entries(grouped).map(([cat,items])=>(
        <View key={cat}>

          <View style={styles.catHeader}>
            <Text style={styles.catTitle}>{cat}</Text>
            <Text style={styles.catCount}>{items.length} items</Text>
          </View>

          {items.map(item=>(
            <MenuCard
              key={item.id}
              item={item}
              qty={qty(item.id)}
              onAdd={()=>add(item)}
              onRemove={()=>remove(item.id)}
            />
          ))}

        </View>
      ))}

      <View style={{height:100}}/>

    </ScrollView>

  </View>
  )
}

/* STYLES */

const styles = StyleSheet.create({

container:{flex:1,backgroundColor:'#F8F9FB'},

header:{paddingTop:54,paddingHorizontal:16,paddingBottom:10,flexDirection:'row',alignItems:'center'},

backBtn:{width:36,height:36,borderRadius:10,backgroundColor:'#EFEFEF',alignItems:'center',justifyContent:'center',marginRight:12},

backText:{fontSize:22,fontWeight:'600'},

headerTitle:{fontSize:24,fontWeight:'800'},

headerSub:{fontSize:12,color:'#9CA3AF'},

cartIcon:{fontSize:26},

search:{margin:16,backgroundColor:'#FFF',borderRadius:12,padding:12,borderWidth:1,borderColor:'#E5E7EB'},

tabsScroll:{
maxHeight:55,
minHeight:55,
marginBottom:10
},

tabs:{
paddingHorizontal:16,
flexDirection:'row',
alignItems:'center',
paddingBottom: 5,
},

tab:{
paddingHorizontal:18,
paddingVertical:8,
borderRadius:20,
backgroundColor:'#FFF',
borderWidth:1,
borderColor:'#E5E7EB',
marginRight:8
},

tabActive:{
backgroundColor:'#111827',
borderColor:'#111827'
},

tabText:{fontSize:13,fontWeight:'600',color:'#374151'},

tabTextActive:{color:'#FFF'},

vegToggle:{
flexDirection:'row',
alignItems:'center',
paddingHorizontal:12,
paddingVertical:7,
borderRadius:20,
borderWidth:1,
borderColor:'#E5E7EB',
backgroundColor:'#FFF'
},

vegToggleActive:{
borderColor:'#16A34A',
backgroundColor:'#F0FDF4'
},

vegToggleText:{
fontSize:13,
marginLeft:4
},

menuList:{paddingHorizontal:16},

catHeader:{flexDirection:'row',justifyContent:'space-between',marginTop:16},

catTitle:{fontSize:15,fontWeight:'700'},

catCount:{fontSize:12,color:'#9CA3AF'},

menuCard:{
flexDirection:'row',
alignItems:'center',
backgroundColor:'#FFF',
borderRadius:12,
padding:12,
marginBottom:6
},

vegBadge:{
width:16,
height:16,
borderRadius:3,
borderWidth:1.5,
alignItems:'center',
justifyContent:'center'
},

vegDot:{
width:7,
height:7,
borderRadius:4
},

itemName:{fontSize:14,fontWeight:'600'},

itemPrice:{fontSize:13,color:'#FF6B35',fontWeight:'700',marginTop:2},

addBtn:{
paddingHorizontal:16,
paddingVertical:7,
borderRadius:8,
borderWidth:1.5,
borderColor:'#FF6B35'
},

addBtnText:{color:'#FF6B35',fontWeight:'800'},

qtyRow:{flexDirection:'row',alignItems:'center'},

qtyBtn:{
width:28,
height:28,
borderRadius:8,
backgroundColor:'#FF6B35',
alignItems:'center',
justifyContent:'center'
},

qtyBtnText:{color:'#FFF',fontSize:16,fontWeight:'700'},

qtyNum:{fontSize:15,fontWeight:'700',marginHorizontal:8}

});