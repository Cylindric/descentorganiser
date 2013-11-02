/*
 * Author:  Mark Hanford
 * License: Creative Commons Attribution-ShareAlike 3.0 Unported License
 *          see http://creativecommons.org/licenses/by-sa/3.0/
 * URL:     http://www.thingiverse.com
 */

include <utils/build_plate.scad>;

 
/* [Common] */
part = "conditionmid"; // [conditionsingle:Conditions Single,conditionleft:Conditions Left,conditionmid:Conditions Middle,all:All]

/* [Advanced] */

// thickness of the walls of the stand
wall_thickness = 2;

// extra space around the cards
gap = 2;


/* [Printer] */
build_plate_selector = 3; //[0:Replicator 2,1: Replicator,2:Thingomatic,3:Manual]

//when Build Plate Selector is set to "manual" this controls the build plate x dimension
build_plate_manual_x = 150; //[100:400]

//when Build Plate Selector is set to "manual" this controls the build plate y dimension
build_plate_manual_y = 110; //[100:400]


/* [Hidden] */
// helper constants
x=0;y=1;z=2;
width=0;thickness=1;height=2;

// dimensions of the smaller cards
small_card_size = [41, 0.3, 63];

// dimensions of the larger cards
large_card_size = [57, 0.3, 80];

// Show the card deck?
showComponents = true;

// Short-cut for wall_thickness
t=wall_thickness;

// If true, rotate and position the part for printing; otherwise render for display
render_for_print = false;

// Condition-card stack size
num_cond_cards = 6;

// Jitter
j = 0.01;

// Curve resolution
$fn = 50;

// Size of the lower tray
conditionTokenTraySize = [
	t+gap+small_card_size[width]+gap+t,
	t+gap+small_card_size[width]+gap+t,
	10
];

// Size of the upper tray
conditionCardTraySize = [
	t+gap+small_card_size[width]+gap+t,
	t+gap+small_card_size[height],
	t+(num_cond_cards*small_card_size[thickness])+gap
];


module cardStack(size, num)
{
	color([0.9, 0.5, 0.1, 0.8])
	cube([size[x], size[y]*num, size[z]]);
}

module smallRoundToken()
{
	color([0.5, 0.5, 0])
	cylinder(h=2, r=19/2);
}

module traySidewall(size)
{
	union()
	{
		// back corner post
		translate([0, (size[z]-t), t-j])
		cube([t, size[y]-(size[z]-t), size[z]-t+j]);

		// front arch
		translate([0, (size[z]-t), t])
		intersection()
		{
			rotate([0, 90, 0])
			cylinder(h=t, r=(size[z]-t));
			
			translate([-j, -(size[z]-t+j), -j])
			cube([t+j+j, ((size[z]-t+j)), (size[z]-t)]);
		}
	}
}


module tab()
{
	tab_width = 4;
	tab_thickness = t/2;
	tab_length = 2;
	
	hull()
	{
		cube([j, tab_width, tab_thickness], center=true);
		
		translate([tab_length,0,0])
		scale(0.9)
		cube([j, tab_width, tab_thickness], center=true);
	}
}

module genericTray(size, type, reartab)
{
	difference()
	{
		union()
		{
			// base
			cube([size[x], size[y], t]);
			
			// connecting tabs
			if (type == "left" || type == "mid")
			{
				translate([size[x]-j, 8, t/2]) tab();
				translate([size[x]-j, size[y]-8, t/2]) tab();
			}
			
			// back wall
			translate([0, size[y]-t, 0])
			union()
			{
				cube([size[x], t, size[z]]);
				
				
				// connecting tabs
				if (type == "left" || type == "mid")
				{
					if (reartab)
					{
							translate([size[x]-j, t/2, size[z]/2]) rotate([90, 0, 0]) tab();
					}
				}
			}

			// left walls
			traySidewall(size);
			
			// right wall
			if (type == "right" || type == "single")
			{
				translate([(size[x] - t), 0, 0])
				traySidewall(size);
			}

		}
		
		if (type == "right" || type == "mid")
		{
			translate([0, 8, t/2]) tab();
			translate([0, size[y]-8, t/2]) tab();
			if (reartab)
			{
				translate([0, size[y]-(t/2), size[z]/2]) rotate([90, 0, 0]) tab();
			}
		}
	}

}

module conditionCardTray(type)
{
	union()
	{
		genericTray(conditionCardTraySize, type, false);

		if (showComponents)
		{
			translate([t+gap, gap, t+(small_card_size[y]*num_cond_cards)])
			rotate([270, 0, 0])
			%cardStack(small_card_size, num_cond_cards);
		}
	}
}

module conditionTokenTray(type)
{
	union()
	{
		genericTray(conditionTokenTraySize, type, true);

		if (showComponents)
		{
			%translate([12, 12, 2+j]) smallRoundToken();
			%translate([36, 37, 2+j]) smallRoundToken();
			%translate([16, 35, 2+j]) smallRoundToken();
			%translate([30, 18, 2+j]) smallRoundToken();
			%translate([35, 10, 4+j]) rotate([14,0,0]) smallRoundToken();
			%translate([20, 30, 4+j]) smallRoundToken();
		}
	}
}

module conditionStack(type)
{
	translate([conditionCardTraySize[x]*-0.5, conditionCardTraySize[y]*-0.5, 0])
	union()
	{
		translate([0, conditionCardTraySize[y]-conditionTokenTraySize[y], conditionCardTraySize[z]-j])
		conditionTokenTray(type);
		conditionCardTray(type);
	}
}

module printPart()
{
	if (part == "conditionsingle")
	{
		if(render_for_print) {
			translate([0, (conditionCardTraySize[z]+conditionTokenTraySize[z])*-0.5, conditionCardTraySize[y]*0.5])
			rotate([-90, 0, 0])
			conditionStack("single");
		} else {
			conditionStack("single");
		}
	}

	if (part == "conditionleft")
	{
		if(render_for_print) {
			translate([(conditionCardTraySize[z]+conditionTokenTraySize[z])*0.5, 0, conditionCardTraySize[x]*0.5])
			rotate([0, -90, 0])
			conditionStack("left");
		} else {
			conditionStack("left");
		}
	}

	if (part == "conditionmid")
	{
		if(render_for_print) {
			translate([(conditionCardTraySize[z]+conditionTokenTraySize[z])*0.5, 0, conditionCardTraySize[x]*0.5])
			rotate([0, -90, 0])
			conditionStack("mid");
		} else {
			conditionStack("mid");
		}
	}

	if (part == "conditionright")
	{
		if(render_for_print) {
			translate([0, (conditionCardTraySize[z]+conditionTokenTraySize[z])*0.5, conditionCardTraySize[y]*0.5])
			rotate([-90, 0, 180])
			conditionStack("right");
		} else {
			conditionStack("right");
		}
	}

	if (part == "all")
	{
		translate([-(conditionCardTraySize[x] + 10), 0, 0]) conditionStack("left");
		conditionStack("mid");
		translate([(conditionCardTraySize[x] + 10), 0, 0]) conditionStack("right");
	}
}

printPart();

if(render_for_print)
{
	%build_plate(build_plate_selector, build_plate_manual_x, build_plate_manual_y);
}
