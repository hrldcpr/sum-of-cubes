module txt(p, s, size=0.03) {
    translate(p) rotate([90, 0, 0]) scale(size)
        linear_extrude(1) text(str(s));
}

module line(start, end, thickness=0.01) {
    hull() {
        translate(start) sphere(thickness);
        translate(end) sphere(thickness);
    }
}

function interp(a, b, x) = a*(1-x) + b*x;

//vs = [[1, 1, 1], [1, -1, -1], [-1, 1, -1], [-1, -1, 1]]; // tetrahedron
module layer(north, east, west, n) {
    du = (east - north) / (n - 1);
    dv = (west - north) / (n - 1);
    for(u = [0:n-1]) {
        for(v = [0:n-1]) {
            txt(north + u*du + v*dv, n);
        }
    }
}

module octahedron(n, outline=false) {
    top = [0, 0, 1];
    north = [0, 1, 0];
    east = [1, 0, 0];
    middle = [east, north, -east, -north];
    scale(20) {
        // outline
        if(outline) for(i = [0:len(middle)-1]) {
            line(top, middle[i]);
            line(middle[i], middle[(i+1) % len(middle)]);
            line(middle[i], -top);
        }

        // middle layer
        layer(north, east, -east, n);
        
        for(end = [top, -top]) {
            // end layer
            txt(end, 1);
            
            // other layers
            if (n>2) for(i = [2:n-1]) {
                northi = interp(end, north, (i-1)/(n-1));
                easti = interp(end, east, (i-1)/(n-1));
                westi = interp(end, -east, (i-1)/(n-1));
                layer(northi, easti, westi, i);
            }
        }
    }
}

n = 3;
octahedron(n, outline=false);
rotate([90, 0, 0]) octahedron(n);
rotate([0, 90, 0]) octahedron(n);