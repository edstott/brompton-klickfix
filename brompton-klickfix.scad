
b = 0.1;
b_grv_r = 13.7/2;
b_grv_ln = 70;
b_grv_tol = 1.2;
b_grv_sp = 67.5+2*b_grv_tol-2*b_grv_r;
b_grv_ang = 7.4;
b_grv_thick = 3;
b_grv_step = 1;
b_grv_bk_open = 34;
b_tang_cube = [15,b_grv_thick+b,20];
b_tang_h = 27;

module rd_tpz(h,w,a,r) {
    w_t=w-2*h*tan(a);
    union() {
        difference() {
            union() {
                translate([-w/2,0,0])
                    rotate([0,a,0])
                        translate([0,0,-r*tan(a)])
                            cylinder(h/cos(a)+r*tan(a)+r*sin(a),r,r);               
                translate([w/2,0,0])
                    rotate([0,-a,0])
                        translate([0,0,-r*tan(a)])
                            cylinder(h/cos(a)+r*tan(a)+r*sin(a),r,r);
            }
            {
                translate([0,0,-r*sin(a)-b/2])
                    cube([w+2*r/cos(a)+b,r*2+b,2*r*sin(a)+b],true);
                translate([0,0,h+r*sin(a)+b/2])
                    cube([w_t+2*r/cos(a)+b,r*2+b,2*r*sin(a)+b],true);
            }
       }

    translate([0,r,0])
        rotate([90,0,0])
            linear_extrude(height=2*r,convexity=10)
                polygon([[-w/2,0],[-w_t/2,h],[w_t/2,h],[w/2,0]]);
    }
}


module b_fill (r,a,h) {
    he = h/cos(a)+r*(tan(a)+sin(a));
    difference(){
        rotate([0,a,0]){
            difference(){
                translate([-r,0,-r*tan(a)])
                   cube([2*r,r,he]);
                translate([-r,0,-r*tan(a)-b/2])
                    cylinder(he+b,r,r);
                translate([r,0,-r*tan(a)-b/2])
                    cylinder(he+b,r-b,r);
            }
        }
        translate([0,0,-r*sin(a)-b/2])
            cube([2*r/cos(a)+b,r*2+b,2*r*sin(a)+b],true);
        translate([h*tan(a),0,h+r*sin(a)+b/2])
            cube([2*r/cos(a)+b,r*2+b,2*r*sin(a)+b],true);
    }
}


difference() {
    rd_tpz(b_grv_ln,b_grv_sp,b_grv_ang,b_grv_r+b_grv_thick);
    translate([0,0,-b])
        rd_tpz(b_grv_ln*2/3+b*2,b_grv_sp+b*sin(b_grv_ang),b_grv_ang,b_grv_r);
    translate([0,0,b_grv_ln*2/3])
        rd_tpz(b_grv_ln*1/3+b,b_grv_sp-2*b_grv_ln*2/3*tan(b_grv_ang)-2*b_grv_step ,b_grv_ang,b_grv_r);
    translate([0,-b_grv_r+b/2,0])
        rotate([90,0,0])
            linear_extrude(height=b_grv_thick+b,convexity=10)
                polygon([[-b_grv_sp/2,-b],[-b_grv_bk_open/2,(b_grv_sp-b_grv_bk_open)/2],[-b_grv_bk_open/2,b_grv_ln+b],[b_grv_bk_open/2,b_grv_ln+b],[b_grv_bk_open/2,(b_grv_sp-b_grv_bk_open)/2],[b_grv_sp/2,-b]]);
    translate([0,b_grv_r+b_grv_thick/2,b_tang_h])
        cube(b_tang_cube,center=true);
}

translate([-b_grv_sp/2-b_grv_r-b_grv_thick,0,0])
    b_fill(b_grv_r+b_grv_thick,b_grv_ang,b_grv_ln);
mirror([1,0,0])
    translate([-b_grv_sp/2-b_grv_r-b_grv_thick,0,0])
        b_fill(b_grv_r+b_grv_thick,b_grv_ang,b_grv_ln);
