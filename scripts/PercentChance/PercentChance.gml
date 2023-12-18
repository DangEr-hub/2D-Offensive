/// @description PercentChance(Chance)
/// @param Chance
function PercentChance(argument0) {
	randomize();
	return (random(100) <= argument0);
}
