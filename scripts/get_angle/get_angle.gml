function get_angle(desiredDirection, maxTurn) {
    var currentDirection = direction; // Assuming 'direction' is the current direction of the projectile

    // Normalize angles to range [0, 360)
    var normDesiredDirection = (desiredDirection + 360) % 360;
    var normCurrentDirection = (currentDirection + 360) % 360;

    // Calculate the shortest direction to turn (clockwise or counter-clockwise)
    var diff = normDesiredDirection - normCurrentDirection;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    // Clamp the direction change to the maximum turn rate
    if (diff > maxTurn) diff = maxTurn;
    if (diff < -maxTurn) diff = -maxTurn;

    return diff;
}

function equipped_item(item_type){
	return (global.ItemIndex[#global.Inventory[# ItemUsePosition, InventoryIndex.SlotID], ItemStat.Type] == item_type)	
}