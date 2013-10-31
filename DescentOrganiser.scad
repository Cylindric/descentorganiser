/*
 * Author:  Mark Hanford
 * License: Creative Commons Attribution-ShareAlike 3.0 Unported License
 *          see http://creativecommons.org/licenses/by-sa/3.0/
 * URL:     http://www.thingiverse.com
 */

/* [Common] */
part = "conditions"; // [conditions:Conditions]

/* [Advanced] */

// thickness of the walls of the stand
wall_thickness = 2;

// extra space around the cards
gap = 2;


/* [Hidden] */
// helper constants
x=0;y=1;z=2;
width=0;thickness=1;height=2;

// dimensions of the smaller cards
small_card_size = [41, 0.3, 63];

// dimensions of the larger cards
large_card_size = [57, 0.3, 80];

// Show the card deck?
showCards = true;

// Short-cut for wall_thickness
t=wall_thickness;


module cardStack(size, num)
{
	color([0.9, 0.5, 0.1, 0.8])
	cube([size[x], size[y]*num, size[z]]);
}

module conditionTokens()
{
	color([0.9, 0, 0, 0.8])
	cube([small_card_size[x], 40, 20]);
}

conditionTokenTraySize = [
	t+gap+small_card_size[width]+gap+t,
	t+gap+small_card_size[width]+gap+t,
	10
];

module conditionTokenTray()
{
	difference()
	{
		cube(conditionTokenTraySize);
		translate([t, -t, t])
		cube(conditionTokenTraySize - [2*t, 0, 0]);
	}
}

conditionCardTraySize = [
	t+gap+small_card_size[width]+gap+t,
	t+gap+small_card_size[height]+gap+t,
	10
];

module conditionCardTray()
{
	difference()
	{
		cube(conditionCardTraySize);
		translate([t, -t, t])
		cube(conditionCardTraySize-[2*t, 0, 0]);
	}
}

module conditionStack()
{
	union()
	{
		translate([0, conditionCardTraySize[y]-conditionTokenTraySize[y], conditionCardTraySize[z]])
		conditionTokenTray();
		conditionCardTray();
	}
}

module printPart()
{
	if (part == "conditions")
	{
		conditionStack();
	}
}

printPart();