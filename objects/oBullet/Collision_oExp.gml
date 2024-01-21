// Define the push force magnitude
other.PushForce = global.ItemIndex[#Weapon, ItemStat.Damage]*.5;
other.PushTimer = other.PushForce*.1;
other.PushDirection = direction;