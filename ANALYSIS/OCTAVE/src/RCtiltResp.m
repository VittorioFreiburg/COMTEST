function r=RCtiltResp(BS,FS)
% [resp] = RCtiltResp(BS,FS)
% uses BF as step response output
% the final value is always positive.
r=FS-BS;
r=r*sign(r(end));

end