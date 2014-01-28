/*
	Watch out, because all the surfaces are thin.
	Slice with 100% infill

	To try the size out, set debug_size to true and print the outline. 
	Test the card while the thin print is still on the bed!
*/

// Which type of box to print?
card_type = "class";

// Thickness of the walls
t=1.2;

// Small gap between the base and the lid
gap=3;

// Reinforce?
reinforce=false;

// Jitter to ensure there are no coincident-surface problems
j=0.1;

// Roundness detail. Mostly $fn will be set to this
detail=20;

// Enable this to print a simple outline to verify card size will fit
debug_size=false;

// Version
version=1;

module case(height, width, depth, holeX, holeY, holeOffset, labelX, labelY, labelOffset)
{
	base(height, width, depth);
	
	if(debug_size==false)
	{
		translate([0, width+15, 0]) 
		lid(height, width, depth, holeX, holeY, holeOffset, labelX, labelY, labelOffset);

		translate([height/2+width/2+10, height/2, 0]) 
		rotate([0, 0, 90]) 
		divider(height, width);
	}
}

module divider(height, width)
{
	h=height;
	w=width;
	roundness=t*3;

	difference()
	{
		// base
		roundbox([h, w, t], roundness, 0);
		
		//translate([15, -15, t/2])
		//rotate([0, 0, 90])
		//scale([0.8, 0.8, 1])
		//linear_extrude(height=t)
		//import("Descent-D.dxf");
	}
}


module base(height, width, depth)
{
	// The actual size of the base is a bit (one "t") bigger than a card
	h=height+t;
	w=width+t;
	d=depth+t;
	roundness=t*3;

	union()
	{
		difference()
		{
			union()
			{
				if(reinforce)
				{
					// Thin base (widest part)
					roundbox([h+t*4, w+t*4, t], roundness, 0);

					// Reinforcement
					roundbox([h+t*3, w+t*3, t*2], roundness, 0);
				}
				else
				{
					// Thin base (widest part)
					roundbox([h+t*3, w+t*3, t], roundness, 0);
				}

				// Walls
				roundbox([h+t*2, w+t*2, d+t], roundness, 0);
			}
			
			// Main hole
			translate([0, 0, t]) 
			roundbox([h, w, d+j], roundness, 0);
			
			// Thumb holes
			translate([0, 0, d+t*2]) scale([1, 1, d/(w/3)]) 
			rotate([0, 90, 0]) 
			cylinder(r=w/3, h=h+t*2+j*2, center=true, $fn=detail);
			
		}
		
		// sample box for the cards
		//%translate([0, 0, t]) roundbox([height, width, depth], roundness, 0);
	}
}

module lid(height, width, depth, holeX, holeY, holeOffset, labelX, labelY, labelOffset)
{
	// The size of the base is a bit (one "t") bigger than a card
	base_h=height+t;
	base_w=width+t;
	base_d=depth+t;
	
	// The size of the lid is a bit (gap) bigger than the base all around
	h=base_h+gap+t*2;
	w=base_w+gap+t*2;
	d=base_d;

	r=holeX/2;
	s=holeX/holeY;
	o=holeOffset;
	roundness=t*3;

	union()
	{
		difference()
		{
			union()
			{
				if(reinforce)
				{
					// Thin base (widest part)
					roundbox([h+t*4, w+t*4, t], roundness, 0);

					// Reinforcement
					roundbox([h+t*3, w+t*3, t*2], roundness, 0);
				}
				else
				{
					// Thin base (widest part)
					roundbox([h+t*3, w+t*3, t], roundness, 0);
				}

				// Walls
				roundbox([h+t*2, w+t*2, d+t], roundness, 0);
			}
			
			// Main hole
			translate([0, 0, t]) 
			roundbox([h, w, d+j], roundness, 0);
			
			// Window
			translate([o, 0, -j]) scale([1, 1/s, 1]) cylinder(r=r, h=t+j*2, $fn=detail*2);

			// Label
			if(labelX > 0 && labelY > 0)
			{
				translate([labelOffset, 0, t/2]) cube([labelX, labelY, t+j*2], center=true, $fn=detail);
			}
		}
		
		if(version>0)
		{
			translate([h/2, -(version-1)*t, t]) 
			union()
			{
				for(i = [0:version-1])
				{
					translate([0, t*2*i, 0])
					cylinder(h=t/2, center=true);
				}
			}
		}
	}
}

// Size is the outside dimension
module roundbox(size, r, t)
{
	difference()
	{
		hull()
		{
			translate([-r, -r, 0]) translate([ size[0]*0.5,  size[1]*0.5, 0]) cylinder(r=r, h=size[2], $fn=detail);
			translate([ r, -r, 0]) translate([-size[0]*0.5,  size[1]*0.5, 0]) cylinder(r=r, h=size[2], $fn=detail);
			translate([-r,  r, 0]) translate([ size[0]*0.5, -size[1]*0.5, 0]) cylinder(r=r, h=size[2], $fn=detail);
			translate([ r,  r, 0]) translate([-size[0]*0.5, -size[1]*0.5, 0]) cylinder(r=r, h=size[2], $fn=detail);
		}
		if(t>0)
		{
			hull()
			{
				translate([-r, -r, -j]) translate([ size[0]*0.5,  size[1]*0.5, 0]) cylinder(r=r-t, h=size[2]+j*2, $fn=detail);
				translate([ r, -r, -j]) translate([-size[0]*0.5,  size[1]*0.5, 0]) cylinder(r=r-t, h=size[2]+j*2, $fn=detail);
				translate([-r,  r, -j]) translate([ size[0]*0.5, -size[1]*0.5, 0]) cylinder(r=r-t, h=size[2]+j*2, $fn=detail);
				translate([ r,  r, -j]) translate([-size[0]*0.5, -size[1]*0.5, 0]) cylinder(r=r-t, h=size[2]+j*2, $fn=detail);
			}
		}
	}
}



if(card_type == "class")
{
	case(height=64, width=41, depth=5, holeX=30, holeY=30, holeOffset=4, labelX=5, labelY=25, labelOffset=-18);
}
if(card_type == "overlord")
{
	case(height=89, width=58, depth=15, holeX=60, holeY=40, holeOffset=0, labelX=0, labelY=0, labelOffset=0);
}
