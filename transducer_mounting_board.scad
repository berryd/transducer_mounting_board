$fn=20;

width=5;
height=6;
thickness=1;
radius=3/8;
deadrise=24.5;
groove=11/64;
groove_inset=3/16;
//screw_inset=1;
screw_inset=1+1/8;
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


module screws_middle() {
  module bore() {
    cylinder(thickness_mm+2, srew_main_bore_mm/2, srew_main_bore_mm/2);
  }
  module counter() {
    cylinder(thickness_mm+1, screw_countersink_width_mm/2, screw_countersink_width_mm/2);
  } 

  translate([screw_inset_mm-radius_mm,height_mm/2,-1]) bore();
  translate([screw_inset_mm-radius_mm,height_mm/2,thickness_mm-screw_countersink_depth_mm]) counter();

  translate([width_mm-radius_mm-screw_inset_mm,height_mm/2,-1]) bore();
  translate([width_mm-radius_mm-screw_inset_mm,height_mm/2,thickness_mm-screw_countersink_depth_mm]) counter();       
}

module screws_corners() {
  module bore() {
    cylinder(thickness_mm+2, srew_main_bore_mm/2, srew_main_bore_mm/2);
  }
  module counter() {
    cylinder(thickness_mm+1, screw_countersink_width_mm/2, screw_countersink_width_mm/2);
  } 
    
  corner_x=cos((90-deadrise)/2+deadrise)*screw_inset_mm;
  corner_y=sin((90-deadrise)/2+deadrise)*screw_inset_mm;
  
  translate([corner_x,corner_y,-1]) bore();
  translate([corner_x,corner_y,thickness_mm-screw_countersink_depth_mm]) counter();

  ocorner_x=sin(45)*screw_inset_mm;
  ocorner_y=cos(45)*screw_inset_mm;
  
  translate([width_mm-radius_mm*2-ocorner_x,height_mm-radius_mm*2-ocorner_y,-1]) bore();
  translate([width_mm-radius_mm*2-ocorner_x,height_mm-radius_mm*2-ocorner_y,thickness_mm-screw_countersink_depth_mm]) counter();       
}

difference() {
  plate();
  grooves();
//  screws_middle();
  screws_corners(); 
}