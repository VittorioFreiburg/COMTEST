function subject = Make_Struct
a=1;
r=1;
subject.subjInfo = struct('subjIni',{''},'ini',{''},'iniGr',{''},'gender',{''},'age',{''},'size',{''},'weight',{''},'path',{''});
% subject.plotInfo = struct('name',{''},'combi',{''},'color',{''},'marker',{''},'line',{''});
for a = 1:2
    for r = 1:9
        for wdh = 1:2
            subject.eyes{a}.reiz{r,wdh} = struct('reizInfo',{''},'data',{''});
        end
    end
end

% dft = struct('yo',{''},'f',{''},'ps',{''},'dftInfo',{''});
% paras = struct('values',{''},'colLabels',{''},'info',{''});
% magPhaCoh = struct('yo',{''},'f',{''},'mag',{''},'pha',{''},'coh',{''},'gf',{''},'lag',{''});
% 
% subject.eyes{a}.reiz{r}.sponSway = struct('dft',dft,'paras',paras);
% subject.eyes{a}.reiz{r}.prtsTF = struct('rot',magPhaCoh,'trans',magPhaCoh);
% 
% subject.eyes{a}.subjMean.sponSway = struct('paras',paras);
% subject.eyes{a}.subjMean.prts = struct('rot05',magPhaCoh,'rot_1',magPhaCoh,'trans08',magPhaCoh,'trans15',magPhaCoh);
