/*
	Watch out, because all the surfaces are thin.
	Slice with 100% infill
*/

card_type = "class";

t=1.5;
j=0.1;

module case(height, width, depth, holeX, holeY, holeOffset, labelX, labelY, labelOffset)
{
	base(height, width, depth);
	
	translate([0, width+15, 0]) 
	lid(height, width, depth, holeX, holeY, holeOffset, labelX, labelY, labelOffset);

	%translate([t*2, t*2, 0]) cube([height, width, depth]);
	%translate([t*2, width+15+t*3, 0]) cube([height, width, depth]);
}

module base(height, width, depth)
{
	h=height+t*2;
	w=width+t*2;
	d=depth+t;
	roundness=t*3;
	roundness2=roundness-t;

	// base
	translate([-t, -t, 0])
	hull()
	{	
		translate([roundness-t, roundness-t, 0]) cylinder(r=roundness, h=t, $fn=20);
		translate([h+t*5-roundness, roundness-t, 0]) cylinder(r=roundness, h=t, $fn=20);
		translate([roundness-t, w+t*5-roundness, 0]) cylinder(r=roundness, h=t, $fn=20);
		translate([h+t*5-roundness, w+t*5-roundness, 0]) cylinder(r=roundness, h=t, $fn=20);
	}

	// walls
	difference()
	{
		hull()
		{
			translate([roundness, roundness, t]) cylinder(r=roundness, h=d, $fn=20);
			translate([h+t*2-roundness, roundness, t]) cylinder(r=roundness, h=d, $fn=20);
			translate([roundness, w+t*2-roundness, t]) cylinder(r=roundness, h=d, $fn=20);
			translate([h+t*2-roundness, w+t*2-roundness, t]) cylinder(r=roundness, h=d, $fn=20);
		}
		hull()
		{
			translate([roundness, roundness, t-j]) cylinder(r=roundness2, h=d+j*2, $fn=20);
			translate([h+t*2-roundness, roundness, t-j]) cylinder(r=roundness2, h=d+j*2, $fn=20);
			translate([roundness, w+t*2-roundness, t-j]) cylinder(r=roundness2, h=d+j*2, $fn=20);
			translate([h+t*2-roundness, w+t*2-roundness, t-j]) cylinder(r=roundness2, h=d+j*2, $fn=20);
		}
	}
}

module lid(height, width, depth, holeX, holeY, holeOffset, labelX, labelY, labelOffset)
{
	h=height+t*4;
	w=width+t*4;
	d=depth+t;
	r=holeX/2;
	s=holeX/holeY;
	o=holeOffset;
	roundness=t*3;
	roundness2=roundness-t;

	// top
	difference()
	{
		hull()
		{	
			translate([roundness-t, roundness-t, 0]) cylinder(r=roundness, h=t, $fn=20);
			translate([h+t*3-roundness, roundness-t, 0]) cylinder(r=roundness, h=t, $fn=20);
			translate([roundness-t, w+t*3-roundness, 0]) cylinder(r=roundness, h=t, $fn=20);
			translate([h+t*3-roundness, w+t*3-roundness, 0]) cylinder(r=roundness, h=t, $fn=20);
		}
		
		// window
		translate([h/2+t-o, w/2+t, -j]) scale([1, 1/s, 1]) cylinder(r=r, h=t+j*2);

		// label
		if(labelX > 0 && labelY > 0)
		{
			translate([h/2+t-labelX/2-labelOffset, w/2+t-labelY/2, -j]) cube([labelX, labelY, t+j*2]);
		}
	}
	
	// walls
	difference()
	{
		hull()
		{
			translate([roundness, roundness, t]) cylinder(r=roundness, h=d, $fn=20);
			translate([h+t*2-roundness, roundness, t]) cylinder(r=roundness, h=d, $fn=20);
			translate([roundness, w+t*2-roundness, t]) cylinder(r=roundness, h=d, $fn=20);
			translate([h+t*2-roundness, w+t*2-roundness, t]) cylinder(r=roundness, h=d, $fn=20);
		}
		hull()
		{
			translate([roundness, roundness, t-j]) cylinder(r=roundness2, h=d+j*2, $fn=20);
			translate([h+t*2-roundness, roundness, t-j]) cylinder(r=roundness2, h=d+j*2, $fn=20);
			translate([roundness, w+t*2-roundness, t-j]) cylinder(r=roundness2, h=d+j*2, $fn=20);
			translate([h+t*2-roundness, w+t*2-roundness, t-j]) cylinder(r=roundness2, h=d+j*2, $fn=20);
		}
	}
}


if(card_type == "class")
{
	case(height=62, width=44, depth=5, holeX=30, holeY=30, holeOffset=4, labelX=5, labelY=25, labelOffset=-18);
}
if(card_type == "overlord")
{
	case(height=89, width=58, depth=15, holeX=60, holeY=40, holeOffset=0, labelX=0, labelY=0, labelOffset=0);
}
