use <edlib.scad>

//Round fillet for front of brompton socket
//r = radius of fillet
//a = tilt angle
//h = height of fillet
module b_fill (r,a,h) {
    intersection(){
        rotate([0,a,0]){
			//Create fillet by subtracting two cylinders from a cube
            difference(){
                translate([-r,0,-h/2])
                   cube([2*r,r,2*h]);
                translate([-r,0,-h/2])
                    cylinder(2*h,r,r);
                translate([r,0,-h/2])
                    cylinder(2*h,r-b,r-b);
            }
        }
		//Intersect with cube to get desired height
		translate([0,0,h/2])
			cube([2*h,r*4,h],true);
    }
}

//Brompton socket
module b_socket (h=70,fillets=false) {
	//Parameters
	r = 13.7/2;			//Radius of groove
	c = 2.45;			//Clearance around mounting block
	w = 67.5+2*c-2*r;	//Width of socket between groove centres
	a = 7.4;			//Tilt angle of grooves from vertical
	t = 3;				//Thickness of socket shell
	s = 1;				//Size of step in groove
	sp = 2/3;			//Position of step relative to socket height
	ow = 34;			//Width of cut-out in back of socket
	tc = [15,t,20];	//Size of latch hole
	th = 27;			//Height of latch hole centre
	translate([0,-r-t,0])
		difference() {
			//External shape of socket
			rd_tpz(h,w,a,r+t);
			//Remove Lower part of inner
			rd_tpz(h*sp,w,a,r);
			//Remove Upper part of inner
			translate([0,0,h*sp])
				rd_tpz(h*(1-sp),w-2*h*sp*tan(a)-2*s ,a,r);
			//Remove Rear cut-out
			translate([0,-r,0])
				rotate([90,0,0])
					linear_extrude(height=t,convexity=10)
						polygon([[-w/2,0],[-ow/2,(w-ow)/2],[-ow/2,h],[ow/2,h],[ow/2,(w-ow)/2],[w/2,0]]);
			//Remove Latch hole
			translate([0,r+t/2,th])
				cube(tc,center=true);
		}

	//Add fillets at front of socket
	if (fillets){
	translate([-w/2-r-t,-r-t,0])
		b_fill(r+t,a,h);
	mirror([1,0,0])
		translate([-w/2-r-t,-r-t,0])
			b_fill(r+t,a,h);
	}
}