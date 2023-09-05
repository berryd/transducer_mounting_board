$fn=20;

width=5;
height=6;
thickness=1;
radius=3/8;
deadrise=24.5;
groove=11/64;
groove_inset=0.185;
screw_inset=1;
screw_countersink_depth=7/16;
screw_countersink_width=0.5;
srew_main_bore=15/64;

mm=25.4;

width_mm=width*mm;
height_mm=height*mm;
thickness_mm=thickness*mm;
radius_mm=radius*mm;

groove_mm=groove*mm;
groove_inset_mm=groove_inset*mm;

screw_inset_mm=screw_inset*mm;
screw_countersink_depth_mm=screw_countersink_depth*mm;
screw_countersink_width_mm=screw_countersink_width*mm;
srew_main_bore_mm=srew_main_bore*mm;

module plate() {
  hull() {
    linear_extrude(height=1) {
      circle(radius_mm);
      translate([0,height_mm-radius_mm*2,0]) circle(radius_mm);
      translate([width_mm-radius_mm*2,height_mm-radius_mm*2,0]) circle(radius_mm);
      translate([width_mm-radius_mm*2,tan(deadrise)*width_mm-radius_mm,0]) circle(radius_mm);  
    }

    translate([0,0,thickness_mm-radius_mm]) {
      sphere(radius_mm);
      translate([0,height_mm-radius_mm*2,0]) sphere(radius_mm);
      translate([width_mm-radius_mm*2,height_mm-radius_mm*2,0]) sphere(radius_mm);
      translate([width_mm-radius_mm*2,tan(deadrise)*width_mm-radius_mm,0]) sphere(radius_mm);  
    }
  }
}

module grooves() {
  module one() {  
    translate([groove_inset_mm,tan(90-deadrise)*groove_inset_mm,-1]) cylinder(groove_mm+1,groove_mm/2,groove_mm/2);
  }
  module two() {
    translate([groove_inset_mm,height_mm-radius_mm*2-groove_inset_mm,-1]) cylinder(groove_mm+1, groove_mm/2, groove_mm/2);
  }
  module three() {
    translate([width_mm-radius_mm*2-groove_inset_mm,height_mm-radius_mm*2-groove_inset_mm,-1]) cylinder(groove_mm+1, groove_mm/2, groove_mm/2);
  }
  module four() {
  translate([width_mm-radius_mm*2-groove_inset_mm,tan(deadrise)*width_mm-radius_mm+groove_inset_mm,-1]) cylinder(groove_mm+1, groove_mm/2, groove_mm/2);
  }
    
    
  hull() {
    one();
    two();
  }
  
  hull() {
    two();
    three();
  }
  
  hull() {
    three();
    four();    
  }  

  hull() {
    four(); 
    one();
  } 
}


module screws() {
  translate([screw_inset_mm-radius_mm,height_mm/2,-1]) 
    cylinder(thickness_mm+2, srew_main_bore_mm/2, srew_main_bore_mm/2);
  translate([screw_inset_mm-radius_mm,height_mm/2,thickness_mm-screw_countersink_depth_mm]) 
    cylinder(thickness_mm+1, screw_countersink_width_mm/2, screw_countersink_width_mm/2);


  translate([width_mm-radius_mm-screw_inset_mm,height_mm/2,-1]) 
    cylinder(thickness_mm+2, srew_main_bore_mm/2, srew_main_bore_mm/2);
  translate([width_mm-radius_mm-screw_inset_mm,height_mm/2,thickness_mm-screw_countersink_depth_mm]) 
    cylinder(thickness_mm+1, screw_countersink_width_mm/2, screw_countersink_width_mm/2);        
}

difference() {
  plate();
  grooves();
  screws();    
}