use <brompton-klickfix.scad>

intersection(){
	brompton_klickfix();
	translate([-500,-500,0])
		cube([1000,1000,100]);
}