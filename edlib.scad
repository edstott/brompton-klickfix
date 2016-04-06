
//A round fillet
module fillet (r,l) {
	rotate([0,0,180])
		translate([-r,-r,0])
			difference() {
				cube([r,r,l]);
				translate([0,0,-l/2])
					cylinder(2*l,r,r,$fn=16);
    }
}

//Cylinder with widened top and bottom
module spool(sd,sl,nt=16,nb=16) {
	t = 0.1;
	cylinder(sl,sd/2,sd/2,$fn=16);
	cylinder(sd,sd*1.8/2+t,sd*1.8/2+t,$fn=nb);
	translate([0,0,sl-sd])
		cylinder(sd,sd*1.8/2+t,sd*1.8/2+t,$fn=nt);
}

//Cube with 8 rounded edges and 4 square edges
module semi_rounded_cube(w,d,h,r) {
    hull()
        for(i=[0,1])
            for(j=[0,1])
                translate([r+i*(w-2*r),r+j*(d-2*r),0]){
                    cylinder(r,r,r,$fn=16);
                    translate([0,0,h-r])
                        sphere(r,$fn=16);
                }
}

//Cube with 5 rounded edges and 7 square edges
module demi_rounded_cube(w,d,h,r) {
    hull()
        for(i=[0,1])
            translate([r+i*(w-2*r),0,0]){
                translate([0,r,0])
                    cylinder(r,r,r,$fn=16);
                translate([-r,d-2*r,0])
                    cube([2*r,2*r,2*r]);
                translate([0,r,h-r])
                    sphere(r,$fn=16);
                translate([0,d-r,h-r])
                    rotate([-90,0,0])
                        cylinder(r,r,r,$fn=16);
            }

}

//Extruded trapezium with rounded sides
//h=height
//w=width of base between centres of rounded sides
//a=angle of sides from vertical
//r=radius of rounded sides (thickness = 2*r)
module rd_tpz(h,w,a,r) {
    union() {
        intersection() {
			//Create two cylinders for the rounded sides
            union() {
                translate([-w/2,0,0])
                    rotate([0,a,0])
                        translate([0,0,-h/2])
                            cylinder(2*h,r,r);               
                translate([w/2,0,0])
                    rotate([0,-a,0])
                        translate([0,0,-h/2])
                            cylinder(2*h,r,r);
            }
			//Intersect with cube to get desired height
            {
                translate([0,0,h/2])
                    cube([2*w,r*4,h],true);
            }
       }

	//Fill in between cylinders with an extruded trapezium
    w_t=w-2*h*tan(a);
    translate([0,r,0])
        rotate([90,0,0])
            linear_extrude(height=2*r,convexity=10)
                polygon([[-w/2,0],[-w_t/2,h],[w_t/2,h],[w/2,0]]);
    }
}


module flare(length,radius,flareRadius){
	translate ([0,0,flareRadius]) rotate_extrude() translate([radius+flareRadius,0,0]) difference(){
		translate([-flareRadius,-flareRadius,0]) square(flareRadius,flareRadius);
		circle(flareRadius);
		}
	cylinder (length,radius,radius);
}
