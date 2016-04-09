w = 18;
h = 5;
hr = 3.25;
hd = 13.5;
d = hd+hr+1;

module tab() {
difference(){
	translate([-w/2,0])rotate([90,0,90])
		linear_extrude(w) {
			translate([h/2,h/2]) circle(h/2,$fn=16);
			translate([h/2,0]) square([d-h/2,h]);
		}
	translate([0,hd,(h-1)/2-h])cylinder(h,hr,hr,$fn=16);
	translate([0,hd,(h-1)/2+1])cylinder(h,hr,hr,$fn=16);
}
}
tab();