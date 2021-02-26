function [delta,delta_filt,r_w] = getDelta_1D(meta,data1,data2,joint,varargin)

%% Params
gnSteps         = 2;
window_time     = 10; % s
data_rate       = 5; % Hz
estimation_rate = 1; %Hz
tauDelta        = 2;
tauBias         = 2;
minWeight       = 0.45;
alignment       = 'backward';
constraint      = 'proj';

if(nargin>4)
    est_settings    = varargin{1};
    window_time     = est_settings.D1.window_time;
    estimation_rate = est_settings.D1.estimation_rate;
    data_rate       = est_settings.D1.data_rate;
    tauDelta        = est_settings.D1.tauDelta;
    tauBias         = est_settings.D1.tauBias;
    minWeight       = est_settings.D1.minWeight;
    alignment       = est_settings.D1.alignment;
    constraint      = est_settings.D1.constraint;
end

sampling_time = 1.0/double(meta.rate);
sample_rate = 1/sampling_time;

window_steps = window_time * sample_rate;
estimation_steps = 1/estimation_rate * sample_rate;
data_steps = 1/data_rate * sample_rate;

%% Coordinate System
j = joint(1,:);
j_long = [1 0 0];

%% Preparation
steps       = length(meta.time);
last_delta_w = 0;

estimations = length(2:estimation_steps:(steps-window_steps));

switch alignment
    case 'backward'
        starts = window_steps+1:estimation_steps:(steps-1);
    case 'center'
        starts = window_steps/2+1:estimation_steps:(steps-window_steps/2);
    case 'forward'
        starts = 2:estimation_steps:(steps-window_steps);
end
regular_estimation_start = starts(1);
starts = [1:data_steps:(starts(1)-data_steps),starts];
estimations = length(starts);

for k = 1:estimations
    
    %% Basic estimation
    index = starts(k);
    % calculate the start and end index of the chosen alignment
    if index < regular_estimation_start
        startup_estimation = true;
        startIndex = 1;
        endIndex = index;
    else
        startup_estimation = false;
        switch alignment
            case 'center'
                startIndex = index - window_steps/2;
                endIndex = index +window_steps/2;
            case 'forward'
                startIndex = index;
                endIndex = index + window_steps;
            case 'backward'
                startIndex = index-window_steps;
                endIndex = index;
        end
    end
    
    [delta_w,cost]  = delta_est_window(data1.quat(startIndex:data_steps:endIndex,:),...
        data2.quat(startIndex:data_steps:endIndex,:),...
        j,...
        j_long,...
        gnSteps,...
        last_delta_w,...
        constraint);
    
    if(startup_estimation)        
        [delta_w_180,cost_180]  = delta_est_window(data1.quat(startIndex:data_steps:endIndex,:),...
            data2.quat(startIndex:data_steps:endIndex,:),...
            j,...
            j_long,...
            gnSteps,...
            last_delta_w+pi,...
            constraint);
        
        if(cost_180 < cost)
            delta_w = delta_w_180;
        end        
    end
    
    last_delta_w = delta_w;
    
    r_w(k) = getWindowWeight(data1.quat(startIndex:data_steps:endIndex,:),data2.quat(startIndex:data_steps:endIndex,:),j);
    
    if(startup_estimation)
        r_w_mod(k) = 1;
        tauDelta_mod = 0.2;
        tauBias_mod = 1;
    else
        r_w_mod(k) = r_w(k);
        tauBias_mod = 1;
        tauDelta_mod = 1;
    end
    
    delta(k) = delta_w;
    
    if k == 100
        disp(asdfsad);
    end
end

% Cut the arrays to the right length
delta_filt      = headingFilter(unwrap(delta),r_w_mod,estimation_rate,tauDelta_mod,tauBias_mod,minWeight);
delta           = interp1(meta.time(starts),unwrap(delta),meta.time,'linear');
delta_filt      = interp1(meta.time(starts),delta_filt,meta.time,'linear');
r_w             = interp1(meta.time(starts),r_w,meta.time,'linear');
end


%% delta_est_window
function [delta,cost] = delta_est_window(q1,q2,j,j_long,gnSteps,startVal,constraint)
delta = startVal;

for i = 1:gnSteps
    [deltaParams,cost]  = gnStep(j,j_long,q1,q2,delta,constraint);
    delta               = delta + deltaParams;
end
delta = limitHeading(delta);
end


%% gnStep
function [deltaParams,totalError] = gnStep(j,j_long,q1,q2,delta,constraint)
[errors,jacobi] = getErrorAndJac_1D(q1,q2,j,j_long,delta,constraint);
deltaParams = -(mldivide((jacobi'*jacobi),jacobi'*errors));
totalError = norm(errors);
end


%% getWindowWeight
function out = getWindowWeight(q1,q2,j)
v1 = quaternionRotate(q1,j);
v2 = quaternionRotate(q2,j);
weight = sqrt(v1(:,1).^2 + v1(:,2).^2) .* sqrt(v2(:,1).^2 + v2(:,2).^2);
out = rms(weight);
end