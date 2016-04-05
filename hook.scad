h = 5;
w = 25;
d = 5;
bt = 6;	//Base thickness
bd = 9; //Base depth
sr = 3.25;
sd = 1;
sl = 4.5; //Socket length

difference(){
	union(){
		translate([w/2,bd-d,bt]) rotate([0,-90,0]) linear_extrude(w) polygon([[0,0],[0,d],[h,0]]);
		translate([-w/2,0,0]) cube([w,bd,bt]);
	}
	translate([0,sd+sr,0]) cylinder(sl,sr,sr,$fn=16);
}
