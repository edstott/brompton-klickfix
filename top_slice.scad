use <brompton-klickfix.scad>

intersection(){
	translate([0,0,-100])
		brompton_klickfix();
	translate([-500,-500,0])
		cube([1000,1000,1000]);
}