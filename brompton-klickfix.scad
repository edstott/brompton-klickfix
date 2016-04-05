
use <flare.scad>

//Bodge amount for overlapping parts in difference operations
b = 0.1;

//Klickfix lift
kl = 120;


//Main body dimensions
w = 83;
d = 19.7;
h = kl+35;

//Split height
spl = 80;

//Brompton socket height
bsh = 70;
	
//Stiffeners
sd = 5;

//Corner radius
r = 1.6;

module fillet (r,l) {
	rotate([0,0,180])
		translate([-r,-r,0])
			difference() {
				cube([r,r,l]);
				translate([0,0,-l/2])
					cylinder(2*l,r,r,$fn=16);
    }
}

module spool(sd,sl) {
	t = 0.1;
	cylinder(sl,sd/2,sd/2,$fn=16);
	cylinder(sd,sd*1.8/2+t,sd*1.8/2+t,$fn=16);
	translate([0,0,sl-sd])
		cylinder(sd,sd*1.8/2+t,sd*1.8/2+t,$fn=6);
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
	h = bsh;		//Height of socket
	c = 2.45;		//Clearance around mounting block
	w = 67.5+2*c-2*r;	//Width of socket between groove centres
	a = 7.4;		//Tilt angle of grooves from vertical
	t = 3;		//Thickness of socket shell
	s = 1;		//Size of step in groove
	sp = 2/3;	//Position of step relative to socket height
	ow = 34;		//Width of cut-out in back of socket
	tc = [15,t+b,20];	//Size of latch hole
	th = 27;		//Height of latch hole centre
	translate([0,-r-t,0])
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
	/*translate([-w/2-r-t,-r-t,0])
		b_fill(r+t,a,h);
	mirror([1,0,0])
		translate([-w/2-r-t,-r-t,0])
			b_fill(r+t,a,h);*/
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

module kf_tab_cutout(){
    
    //KF tab cutout
    kft_w = 20;
    kft_h = 10;
    kft_f = 10; //finger radius   
    kfh_r = 3.2; //radius of hook channel
	kft_hd = 5+kfh_r; //Depth of hook channel from front
    kft_d = d-kft_hd+kfh_r+r; //Overall depth of tab cutout
	kfh_sr = 3; //Depth of spring recess

    translate([-kft_w/2,kft_d,0])
        mirror([0,1,0]) {
			demi_rounded_cube(kft_w,kft_d,kft_h,r);
			translate([kft_w/2,kft_d,kft_h])
				sphere(kft_f,$fn=32);
			translate([kft_w/2,kfh_r+r,-kfh_sr])
				cylinder(h-spl+kfh_sr,kfh_r,kfh_r,$fn=16);
	}

}

module body(){

	//KF latch cutout
	kfl_w = 53;
	kfl_h = 20;
	kfl_d = 12.5;
    
	
	//fixing hole 
	hd = 5; //diameter
	hs = 40; // hole spacing
	hy = 8;//9.85; // hole distance from front
	
	difference(){
		union()
            //Outer cube of block
			hull()
			{
				translate([-w/2,-d+r,r+b])
					sphere(r,$fn=16);
				translate([w/2,-d+r,r+b])
					sphere(r,$fn=16);
				translate([-w/2,0,r+b])
					rotate([90,0,0])
						cylinder(r,r,r,$fn=16);
				translate([w/2,0,r+b])
					rotate([90,0,0])
						cylinder(r,r,r,$fn=16);
				translate([w/2-r,-r,h-r])
					cube([r,r,r]);
				translate([-w/2,-r,h-r])
					cube([r,r,r]);
				translate([-w/2+r,-d+r,h-r])
					cylinder(r,r,r,$fn=16);
				translate([w/2-r,-d+r,h-r])
					cylinder(r,r,r,$fn=16);
				}
		//Minus hull of brompton socket
        hull()
			b_socket();
        //Minus hull of klickfix plug
		hull()
			translate([0,0,kl])
				rotate([0,0,180])
					kfix_plug();
		
        //Minus gap below klickfix 
		translate([-kfl_w/2,-kfl_d,kl-kfl_h])
			cube([kfl_w,kfl_d,kfl_h+b]);
                
        //Minus 2x fastening holes
		translate([hs/2,-hy,bsh])
			spool(hd,kl-kfl_h-bsh);
		translate([-hs/2,-hy,bsh])
			spool(hd,kl-kfl_h-bsh);
            
        //Minus latch tab hole
        translate([0,-d,spl])
			kf_tab_cutout();
	}
	
}

module brompton_klickfix(){
	
	//Pull hole
	pr = 10;//pull hole radius
	pfr = 5;//pull hole flare radius
	ph = kl+17.5;//pull hole height
	
	difference(){
		union(){
			body();		
			b_socket();
			translate([0,0,kl])
				rotate([0,0,180])
					kfix_plug();
		}
		//Minus pull hole
		translate([0,-d,ph])rotate([-90,0,0]) flare(d,pr,pfr);
	}
}

brompton_klickfix();