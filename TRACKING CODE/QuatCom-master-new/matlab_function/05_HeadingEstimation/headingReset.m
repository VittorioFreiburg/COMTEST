function phi = headingReset(q1,q2,phi_in)

    if(nargin<3)
        phi_in = 0;
    end

    a = q1(1) * q2(1) + q1(2) * q2(2) + q1(3) * q2(3) + q1(4) * q2(4);
    b = q1(4) * q2(1) + q1(3) * q2(2) - q1(2) * q2(3) - q1(1) * q2(4);
    phi = 2*atan2(b,a);
    phi = phi + phi_in;
    if(phi > pi)
        phi = phi - 2*pi;
    end
end