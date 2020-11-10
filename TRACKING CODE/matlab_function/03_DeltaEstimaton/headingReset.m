function phi = headingReset(q1,q2)

    a = q1(1) * q2(1) + q1(2) * q2(2) + q1(3) * q2(3) + q1(4) * q2(4);
    b = q1(4) * q2(1) + q1(3) * q2(2) - q1(2) * q2(3) - q1(1) * q2(4);
    phi = pi - 2*atan2(a,b);
    
    if(phi > pi)
        phi = phi - 2*pi;
    end
end