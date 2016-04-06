
use <edlib.scad>
use <brompton_socket.scad>
use <klickfix_plug.scad>

//Bodge amount for overlapping parts in difference operations
b = 0.1;

//Klickfix lift
kl = 120;	//120 for Ortlieb Ultimate6 M Classic


//Main body dimensions
w = 83;		//83 to equal width of Klickflix plug
d = 19.7;	//19.7 to equal depth of Brompton socket
h = kl+35;	//Klickfix lift plus 35 to equal height of Klickfix plug

//Split height / level of latch tab cutout
spl = kl-40;

//Brompton socket height
bsh = 70;	//70 for socket found on Brompton O-bag
	
//Stiffeners
stiff = false;
sd = 5;	//Diameter of stiffening/joining bolts

//Corner radius
r = 1.6;

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

module kf_tab_cutout(){
    
    //KF tab cutout
    kft_w = 20;
    kft_h = 11;
    kft_f = 10; //finger radius   
    kfh_r = 3.2; //radius of hook channel
	kft_hd = 3+kfh_r; //Depth of hook channel from front
    kft_d = d-kft_hd+kfh_r+r; //Overall depth of tab cutout
	kfh_sr = 10; //Depth of spring recess

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
	
	//text
	th = 12; //text height
	tl = 10; //text offset from bottom
	tx = (w+34)/4; //text horizontal offset from centre
	
	font = "Verdana";
	
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
			b_socket(bsh);
        //Minus hull of klickfix plug
		hull()
			translate([0,0,kl])
				rotate([0,0,180])
					kfix_plug();
		
        //Minus gap below klickfix 
		translate([-kfl_w/2,-kfl_d,kl-kfl_h])
			cube([kfl_w,kfl_d,kfl_h+b]);
                
        //Minus 2x fastening holes
		if (stiff){
			translate([hs/2,-hy,bsh])
				spool(hd,kl-kfl_h-bsh,nt=6);
			translate([-hs/2,-hy,bsh])
				spool(hd,kl-kfl_h-bsh,nt=6);
		}
            
        //Minus latch tab hole
        translate([0,-d,spl])
			kf_tab_cutout();
	}
	
	
	translate([-tx,-d,tl]) rotate([-90,-90,180])linear_extrude(1) text("BROMPTON",th,font,valign="center");
	translate([tx,-d,h-tl]) rotate([-90,90,180])linear_extrude(1) text("KLICKFIX",th,font,valign="center");
	
}

module brompton_klickfix(){
	
	//Pull hole
	pr = 10;//pull hole radius
	pfr = 5;//pull hole flare radius
	ph = kl+17.5;//pull hole height
	
	difference(){
		union(){
			body();		
			b_socket(bsh);
			translate([0,0,kl])
				rotate([0,0,180])
					kfix_plug();
		}
		//Minus pull hole
		translate([0,-d,ph])rotate([-90,0,0]) flare(d,pr,pfr);
	}
}

brompton_klickfix();