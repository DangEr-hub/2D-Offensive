
function get_angle(desiredDirection, maxTurn) {
    var currentDirection = direction; // Assuming 'direction' is the current direction of the projectile

    // Normalize angles to range [0, 360)
    var normDesiredDirection = (desiredDirection + 360) % 360;
    var normCurrentDirection = (currentDirection + 360) % 360;

    // Calculate the shortest direction to turn (clockwise or counter-clockwise)
    var diff = normDesiredDirection - normCurrentDirection;

    // Adjust differences to find the shortest path (through 0/360 boundary if necessary)
    if (diff > 180) {
        diff -= 360;
    } else if (diff < -180) {
        diff += 360;
    }

    // Clamp the direction change to the maximum turn rate
    // This ensures the projectile turns by at most maxTurn degrees
    if (diff > maxTurn) {
        diff = maxTurn;
    } else if (diff < -maxTurn) {
        diff = -maxTurn;
    }

    // Return the adjusted difference, which is how much the direction should change
    return diff;
}

function equipped_item(item_type){
	return (global.ItemIndex[#global.Inventory[# ItemUsePosition, InventoryIndex.SlotID], ItemStat.Type] == item_type)	
}