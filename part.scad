// Parameters (in mm)
bottom_diameter = 44;
top_diameter = 41;
height = 15.3;
central_hole_diameter = 6.1;     // For M6 screw
side_hole_diameter = 5.3;        // For side screws
num_side_holes = 3;

$fn = 200;

// Nut cavity dimensions (M6 nut)
nut_flat_width = 10;
nut_height = 5 * 1.5;            // 7.5mm deep

// Side screw head recess
screw_head_diameter = 10;
screw_head_depth = 6.5;

// Derived values
bottom_radius = bottom_diameter / 2;
top_radius = top_diameter / 2;
average_outer_radius = (bottom_radius + top_radius) / 2;

central_hole_radius = central_hole_diameter / 2;
side_hole_radius = side_hole_diameter / 2;
screw_head_radius = screw_head_diameter / 2;

// Compute radius for side hole placement
side_hole_ring_radius = (central_hole_radius + average_outer_radius) / 2;

// Helper: hexagon shape for nut cavity
module hex_cavity(radius, height) {
    rotate([0, 0, 0])
        linear_extrude(height)
            polygon(points = [
                for (i = [0:5]) [
                    radius * cos(i * 60),
                    radius * sin(i * 60)
                ]
            ]);
}

difference() {
    // Main frustum
    cylinder(h=height, r1=bottom_radius, r2=top_radius, $fn=$fn);

    // Central screw hole
    translate([0, 0, -1])
        cylinder(h=height + 2, r=central_hole_radius, $fn=$fn);

    // Nut cavity on bottom (wide base)
    translate([0, 0, -0.01])
        hex_cavity(nut_flat_width / 2 / cos(30), nut_height);

    // Side screw holes and head recesses — now from top (narrow end)
    for (i = [0 : 360/num_side_holes : 359]) {
        angle = i;
        x = side_hole_ring_radius * cos(angle);
        y = side_hole_ring_radius * sin(angle);

        // Through-hole from top
        translate([x, y, -1])
            cylinder(h=height + 2, r=side_hole_radius, $fn=100);

        // Head recess at top
        translate([x, y, height - screw_head_depth + 0.01])  // start near top
            cylinder(h=screw_head_depth, r=screw_head_radius, $fn=100);
    }
}