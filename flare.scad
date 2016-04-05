
module flare(length,radius,flareRadius){
	translate ([0,0,flareRadius]) rotate_extrude() translate([radius+flareRadius,0,0]) difference(){
		translate([-flareRadius,-flareRadius,0]) square(flareRadius,flareRadius);
		circle(flareRadius);
		}
	cylinder (length,radius,radius);
}
