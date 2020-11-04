function out = local_wrapToPi(angle)
out = angle - 2*pi*floor( (angle+pi)/(2*pi) );
end