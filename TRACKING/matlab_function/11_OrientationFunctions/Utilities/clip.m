function out = clip(in,min,max)
out = in;
out(out>max) = max;
out(out<min) = min;
end