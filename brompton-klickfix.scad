
use <edlib.scad>
use <brompton_socket.scad>
use <klickfix_plug.scad>

//Bodge amount for overlapping parts in difference operations
//b = 0.1;


//Main body dimensions
w = 83;		//83 to equal width of Klickflix plug
d = 19.7;	//19.7 to equal depth of Brompton socket
h = 155;	//155 for Ortlieb Ultimate6 M Classic

//Klickfix lift
kl = h-35;	//Klickfix plug is 35mm high

//Split height / level of latch tab cutout
spl = kl-42;

//Brompton socket height
bsh = 70;	//70 for socket found on Brompton O-bag
	
//Stiffeners
stiff = false;
sd = 5;	//Diameter of stiffening/joining bolts

//Corner radius
r = 1.6;

//Apply text
txt = true;


module kf_tab_cutout(){
    
    //KF tab cutout
    kft_w = 20;
    kft_h = 11;
    kft_f = 10; //finger radius   
    kfh_r = 3.2; //radius of hook channel
	kft_hd = 2+kfh_r; //Depth of hook channel from front
    kft_d = d-kft_hd+kfh_r+1.5; //Overall depth of tab cutout
	kfh_sr = 10; //Depth of spring recess

    translate([-kft_w/2,kft_d,0])
        mirror([0,1,0]) {
			//demi_rounded_cube(kft_w,kft_d,kft_h,r);
			cube([kft_w,kft_d,kft_h]);
			translate([kft_w/2,kft_d,kft_h])
				sphere(kft_f,$fn=32);
			translate([kft_w/2,kfh_r+r,-kfh_sr])
				cylinder(h-spl+kfh_sr,kfh_r,kfh_r,$fn=16);
	}

}

module body(){

	//KF latch cutout
	kfl_w = 53;
	kfl_h = 22;
	kfl_d = 12.5;
    
	
	//fixing hole 
	hd = 5; //diameter
	hs = 40; // hole spacing
	hy = 8;//9.85; // hole distance from front
	
	//text
	th = 12; //text height
	tlb = 12; //text offset from bottom
	tlt = 6; //text offset from bottom
	tx = (w+34)/4; //text horizontal offset from centre
	
	font = "Verdana";
	
	
	difference(){
		//Main block
		translate([-w/2,0,0]) rotate([90,0,0]) demi_rounded_cube(w,h,d,r);
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
			cube([kfl_w,kfl_d,kfl_h]);
                
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
	
	//Add labels to stop people trying to use it upside down
	if (txt) {
		translate([-tx,-d,tlb]) rotate([-90,-90,180])linear_extrude(1) text("BROMPTON",th,font,valign="center");
		translate([tx,-d,h-tlt]) rotate([-90,90,180])linear_extrude(1) text("KLICKFIX",th,font,valign="center");
		//Label the height of this build
		translate([-tx,-d,h-tlt]) rotate([90,0,0])linear_extrude(1) text(str(h),th/2,font,valign="top",halign="center");
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