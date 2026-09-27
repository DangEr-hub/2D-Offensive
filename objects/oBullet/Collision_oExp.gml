// Define the push force magnitude
other.PushForce = global.ItemIndex[#stats.Item_id, ITEMSTATS.Damage]*.5;
other.PushTimer = other.PushForce*.1;
other.PushDirection = direction;