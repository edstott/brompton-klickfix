
//Bodge amount for overlapping parts in difference operations
b = 0.1;

//Brompton socket parameters
bs_r = 13.7/2;	//Radius of groove
bs_h = 70;		//Height of socket
bs_t = 1.2;		//Clearance around mounting block
bs_w = 67.5+2*bs_t-2*bs_r;	//Width of socket between groove centres
bs_a = 7.4;		//Tilt angle of grooves from vertical
bs_t = 3;		//Thickness of socket shell
bs_s = 1;		//Size of step in groove
bs_sp = 2/3;	//Position of step relative to socket height
bs_ow = 34;		//Width of cut-out in back of socket
bs_tc = [15,bs_t+b,20];	//Size of latch hole
bs_th = 27;		//Height of latch hole centre

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

//Create brompton socket
difference() {
	//External shape of socket
    rd_tpz(bs_h,bs_w,bs_a,bs_r+bs_t);
	//Remove Lower part of inner
    translate([0,0,-b])
        rd_tpz(bs_h*bs_sp+b*2,bs_w+b*sin(bs_a),bs_a,bs_r);
	//Remove Upper part of inner
    translate([0,0,bs_h*bs_sp])
        rd_tpz(bs_h*(1-bs_sp)+b,bs_w-2*bs_h*bs_sp*tan(bs_a)-2*bs_s ,bs_a,bs_r);
	//Remove Rear cut-out
    translate([0,-bs_r+b/2,0])
        rotate([90,0,0])
            linear_extrude(height=bs_t+b,convexity=10)
                polygon([[-bs_w/2,-b],[-bs_ow/2,(bs_w-bs_ow)/2],[-bs_ow/2,bs_h+b],[bs_ow/2,bs_h+b],[bs_ow/2,(bs_w-bs_ow)/2],[bs_w/2,-b]]);
    //Remove Latch hole
	translate([0,bs_r+bs_t/2,bs_th])
        cube(bs_tc,center=true);
}

//Add fillets at front of socket
translate([-bs_w/2-bs_r-bs_t,0,0])
    b_fill(bs_r+bs_t,bs_a,bs_h);
mirror([1,0,0])
    translate([-bs_w/2-bs_r-bs_t,0,0])
        b_fill(bs_r+bs_t,bs_a,bs_h);
