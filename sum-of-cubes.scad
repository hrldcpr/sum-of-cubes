
//
// util
//

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


//
// tetrahedra
//

module tlayer(a, b, c, n) {
    // triangle
    for(u = [0:n-1]) {
        ab = interp(a, b, u/(n-1));
        ac = interp(a, c, u/(n-1));
        for(v = [0:u]) {
            txt(interp(ab, ac, v/(n-1)), n);
        }
    }
}

module tetrahedron(n, outline=false) {
    a = [1, 1, 1];
    b = [1, -1, -1];
    c = [-1, 1, -1];
    d = [-1, -1, 1];
    vs = [a, b, c, d];
    rotate([45, -asin(1/sqrt(3)), 0])
    scale(20) {
        // outline
        if(outline) for(i = [0:len(vs)-2]) {
            for(j = [i+1:len(vs)-1]) {
                line(vs[i], vs[j]);
            }
        }
        
        // top layer
        txt(a, 1);

//        for(end = [top, -top]) {
//            
//            // other layers
//            if (n>2) for(i = [2:n-1]) {
//                northi = interp(end, north, (i-1)/(n-1));
//                easti = interp(end, east, (i-1)/(n-1));
//                westi = interp(end, -east, (i-1)/(n-1));
//                tlayer(northi, easti, westi, i);
//            }
//        }
    }
}

module multitetrahedron(n, outline=false) {
    tetrahedron(n, outline=outline);
    // TODO wherefore these rotations?
    rotate([112, 28, 101]) tetrahedron(n, outline=outline);
    rotate([112, 28, 221]) tetrahedron(n, outline=outline);
    rotate([112, 28, 341]) tetrahedron(n, outline=outline);
}


//
// octahedra
//

module olayer(north, east, west, n) {
    // nxn square
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
        olayer(north, east, -east, n);
        
        for(end = [top, -top]) {
            // end layer
            txt(end, 1);
            
            // other layers
            if (n>2) for(i = [2:n-1]) {
                northi = interp(end, north, (i-1)/(n-1));
                easti = interp(end, east, (i-1)/(n-1));
                westi = interp(end, -east, (i-1)/(n-1));
                olayer(northi, easti, westi, i);
            }
        }
    }
}

module multioctahedron(n, outline=false) {
    octahedron(n, outline=outline);
    rotate([90, 0, 0]) octahedron(n);
    rotate([0, 90, 0]) octahedron(n);
}


//
// output
//

//multioctahedron(3);
multitetrahedron(3, outline=true);