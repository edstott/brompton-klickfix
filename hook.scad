

w = 25; //Width
bh = 6;	//Base height
th = 5; //Tooth height
sr = 3.25; //Shaft radius
sl = 4.5; //Socket length
ttd = 0.5; //Tooth depth at top
ta = 35; //Tooth steepness
tbr = 2; //Tooth base radius
so = 1.5; //Shaft offset
sd = bh-1; //Shaft insertion depth
bd = so+sr+1.5; //Base depth

module tooth_profile(){
//Y Centre of the front curve is (th+bh/2)*tan(ta)-bh/(2*cos(ta))+ttd
//Slope intersection with curve X Centre - correction for tangent with curve + tooth depth
    //Tooth and part of front curve forward of tooth edge
    hull(){
        polygon([[-bh/2,0],[th,0],[th,ttd]]);
        translate([-bh/2,0])
            difference(){
                translate([0,(th+bh/2)*tan(ta)-bh/(2*cos(ta))+ttd]) circle(bh/2,$fn=36);
                translate([-bh/2,-bh]) square([bh,bh]);
            }
        }
    
    //Base including entire front curve
    hull(){
        translate([-bh/2,(th+bh/2)*tan(ta)-bh/(2*cos(ta))+ttd]) circle(bh/2,$fn=36);
        translate([-bh,-bd]) square([bh,0.1]);
        translate([-0.1,-0.1]) square([0.1,0.1]);
    }
    
    //Fill at base of tooth
    translate([tbr,-tbr]) rotate([0,0,90]) difference(){
        square([tbr,tbr]);
        circle(tbr,$fn=18);
    }
}

module hook() {
	
	echo("Hook tooth to shaft centre: ",so);

	difference(){
		translate([w/2,so,bh]) rotate([0,-90,0]) linear_extrude(w) tooth_profile();
		cylinder(sl,sr,sr,$fn=16);
	}

    

}

hook();
