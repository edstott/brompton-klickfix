use <edlib.scad>

module kfix_plug () {
	//Parameters
	h = 35;		//Height of plug
	d = 12.5;	//Depth of plug
	sw = 35;	//Width of square
	sr = 1.6;	//Radius of square corners
	hc = 68;	//Hook spacing
	hw = 15;	//Hook width
	hl = 6;		//Hook length
	ht = 3.5;	//Hook thickness
	
	//Square plug
	hull()
		for(i=[0,1])
			for(j=[0,1]) {
				translate([-sw/2+sr+i*(sw-2*sr),sr,sr+j*(h-2*sr)])
					sphere(sr,$fn=16);
				translate([-sw/2+sr+i*(sw-2*sr),d,sr+j*(h-2*sr)])
					rotate([90,0,0])
						cylinder(d/2,sr,sr,$fn=16);
			}
	//Hooks
	for(i=[0,1]) {
		c = -hc/2+i*hc; //Centre of this hook
		translate([c-hw/2,0,0]){
			cube([hw,d,h]);
			translate([0,0,h])
				hull(){
					translate([sr,0,hl-sr])
						rotate([-90,0,0])
							cylinder(ht,sr,sr,$fn=16);
					translate([hw-sr,0,hl-sr])
						rotate([-90,0,0])
							cylinder(ht,sr,sr,$fn=16);
					cube([hw,ht,hl/2]);}
			translate([0,ht,h])
				rotate([0,90,0])
					rotate([0,0,90])
						fillet(sr,hw);
		}
	}
	

}