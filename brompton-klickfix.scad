
//Bodge amount for overlapping parts in difference operations
b = 0.1;

module fillet (r,l) {
	rotate([0,0,180])
		translate([-r,-r,0])
			difference() {
				cube([r,r,l]);
				translate([0,0,-l/2])
					cylinder(2*l,r,r,$fn=16);
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
module b_socket () {
	//Parameters
	r = 13.7/2;	//Radius of groove
	h = 70;		//Height of socket
	c = 1.2;		//Clearance around mounting block
	w = 67.5+2*c-2*r;	//Width of socket between groove centres
	a = 7.4;		//Tilt angle of grooves from vertical
	t = 3;		//Thickness of socket shell
	s = 1;		//Size of step in groove
	sp = 2/3;	//Position of step relative to socket height
	ow = 34;		//Width of cut-out in back of socket
	tc = [15,t+b,20];	//Size of latch hole
	th = 27;		//Height of latch hole centre
	difference() {
		//External shape of socket
		rd_tpz(h,w,a,r+t);
		//Remove Lower part of inner
		translate([0,0,-b])
			rd_tpz(h*sp+b*2,w+b*sin(a),a,r);
		//Remove Upper part of inner
		translate([0,0,h*sp])
			rd_tpz(h*(1-sp)+b,w-2*h*sp*tan(a)-2*s ,a,r);
		//Remove Rear cut-out
		translate([0,-r+b/2,0])
			rotate([90,0,0])
				linear_extrude(height=t+b,convexity=10)
					polygon([[-w/2,-b],[-ow/2,(w-ow)/2],[-ow/2,h+b],[ow/2,h+b],[ow/2,(w-ow)/2],[w/2,-b]]);
		//Remove Latch hole
		translate([0,r+t/2,th])
			cube(tc,center=true);
	}

	//Add fillets at front of socket
	translate([-w/2-r-t,0,0])
		b_fill(r+t,a,h);
	mirror([1,0,0])
		translate([-w/2-r-t,0,0])
			b_fill(r+t,a,h);
}

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
				translate([-sw/2+sr+i*(sw-2*sr),d/2-sr,-h/2+sr+j*(h-2*sr)])
					sphere(sr,$fn=16);
				translate([-sw/2+sr+i*(sw-2*sr),0,-h/2+sr+j*(h-2*sr)])
					rotate([90,0,0])
						cylinder(d/2,sr,sr,$fn=16);
			}
	
	for(i=[0,1]) {
		c = -hc/2+i*hc; //Centre of this hook
		translate([c,0,0])
			cube([hw,d,h],true);
		translate([c-hw/2,d/2-ht,h/2]){
			cylinder(ht,sr,sr);
			cube([hw,ht,hl/2]);}
		translate([c-hw/2,d/2-ht,h/2])
			rotate([0,90,0])
				rotate([0,0,180])
					fillet(sr,hw);
	}

}



//b_socket();

translate([0,0,100])
	kfix_plug();