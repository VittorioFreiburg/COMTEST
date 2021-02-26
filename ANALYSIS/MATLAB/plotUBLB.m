function [figNr]=plotUBLB(subject,sText,legende,figNr,errBar)
xRot = [0.04, 2.7];
xTrans = [0.04, 4.5];
yMag = [0.1, 4];
yPha = [-400, 200];
nAx = 3;
mark = subject.plotInfo.combi;

for eye = 1:2
    
    if isfield(subject.eyes{eye},'mean') || isfield(subject.eyes{eye},'subjMean')


        if eye ==1
            eText='EO';
        elseif eye ==2
            eText='EC';
        end


        for fn1z = 1:4

            eval(['fn1=fieldnames(',sText,'.UBLBdiff);']);
            fn1Text = cell2mat(fn1(fn1z));
            eval(['data = ',sText,'.UBLBdiff.',fn1Text,';']);

            figure (figNr+eye-1)

            subplot (3,4,fn1z)
            plot(real(data.tf),imag(data.tf),mark)
            hold on
            axis([-nAx,nAx,-nAx,nAx])
            xlabel ('real Axis (TF)')
            ylabel('imaginary Axis (TF)')
            title ([eText,'  ',fn1Text])

            if fn1z == 1
                legend(legende)
            end


            subplot (3,4,fn1z+4)
            loglog(data.f,data.mag,mark)
            hold on
            axis([xRot,yMag])
            xlabel ('f[Hz]')
            ylabel('UB-LB Diff Gain')

            subplot (3,4,fn1z+8)
            semilogx(data.f,data.pha,mark)
            hold on
            axis([xRot,yPha])
            xlabel ('f[Hz]')
            ylabel('UB-LB Diff Phase')



            %% LBxUB

            eval(['fn1=fieldnames(',sText,'.LBxUB);']);
            fn1Text = cell2mat(fn1(fn1z));
            eval(['data = ',sText,'.LBxUB.',fn1Text,';']);

            figure (figNr+2+eye-1)

            subplot (3,4,fn1z)
            plot(real(data.tf),imag(data.tf),mark)
            hold on
            axis([-nAx,nAx,-nAx,nAx])
            xlabel ('real Axis (TF)')
            ylabel('imaginary Axis (TF)')
            title ([eText,'  ',fn1Text])

            if fn1z == 1
                legend(legende)
            end

            subplot (3,4,fn1z+4)
            loglog(data.f,data.mag,mark)
            hold on
            axis([xRot,yMag])
            xlabel ('f[Hz]')
            ylabel('LBxUB Gain')

            subplot (3,4,fn1z+8)
            semilogx(data.f,data.pha,mark)
            hold on
            axis([xRot,yPha])
            xlabel ('f[Hz]')
            ylabel('LBxUB Phase')

        end
    end    
 
end

figNr=figNr+4;
