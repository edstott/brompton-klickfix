use <brompton-klickfix.scad>
use <hook.scad>
use <tab.scad>

color("yellow") brompton_klickfix();
translate([0,-4.5-2-3.2,155-57+5]) color("red") hook();
translate([0,-13.5-2-3.2,155-77+5]) color("red") tab();
translate([0,-2-3.2,155-77+5+3]) color("red") cylinder(20-3+4.5,3,3,$fn=16);