function [delta,delta_filt,r_w,stillness] = getDelta_1D(meta,data1,data2,joint,varargin)

%% Params
gnSteps         = 2;
window_time     = 10; % s
data_rate       = 5; % Hz
estimation_rate = 1; %Hz
tauDelta        = 2;
tauBias         = 2;
minWeight       = 0.45;
alignment       = 'backward';
constraint      = 'euler_1d';
enable_stillness = false;

if(nargin>4)
    est_settings        = varargin{1};
    window_time         = est_settings.D1.window_time;
    estimation_rate     = est_settings.D1.estimation_rate;
    data_rate           = est_settings.D1.data_rate;
    tauDelta            = est_settings.D1.tauDelta;
    tauBias             = est_settings.D1.tauBias;
    minWeight           = est_settings.D1.minWeight;
    alignment           = est_settings.D1.alignment;
    constraint          = est_settings.D1.constraint;
    enable_stillness    = est_settings.D1.enable_stillness;
end

sampling_time = 1.0/double(meta.rate);
sample_rate = 1/sampling_time;

window_steps = window_time * sample_rate;
estimation_steps = 1/estimation_rate * sample_rate;
data_steps = 1/data_rate * sample_rate;

% stillness settings
stillness_time = 3;
still_threshold = deg2rad(4);
NStill = stillness_time * sample_rate;

%% Coordinate System
if(size(joint,1) > size(joint,2))
    joint = joint';
end
j = joint(1,:);
j_long = [1 0 0];

%% Preparation
steps       = length(data1.time);
last_delta_w = 0;

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


stillness = zeros(1,estimations);

r_w = zeros(1,estimations);
r_w_mod = zeros(1,estimations);
tauDelta_mod = zeros(1,estimations);
tauBias_mod = zeros(1,estimations);
delta = zeros(1,estimations);


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
    % check if the sensors are at rest
    
    if(enable_stillness && startup_estimation == false && index>NStill && mean(vecnorm2(data1.gyr(index-NStill:index,:))) < still_threshold && mean(vecnorm2(data2.gyr(index-NStill:index,:))) < still_threshold)
        state = 'stillness';
        if(strcmp(state,last_state) == false) % state changed
            delta_still = last_delta_w;
            qb2b1_ref = quaternionMultiply(quaternionMultiply(quaternionInvert(data1.quat(index,:)),getQuat(delta_still,[0 0 1])),data2.quat(index,:));
        end
        
        q_e2_e1 = quaternionMultiply(quaternionMultiply(data1.quat(index,:),qb2b1_ref),quaternionInvert(data2.quat(index,:)));
        q_rel = relativeQuaternion(getQuat(delta_still,[0 0 1]),q_e2_e1);
        
        delta_inc = 2*atan2(dot(q_rel(2:4),[0,0,1]),q_rel(1));
        delta_w = delta_still+ delta_inc;
        
        last_state = 'stillness';
        stillness(k) = 1;
    else
        state= 'active';
        last_state = 'active';
        stillness(k) = 0;
    end
%     disp('stillness:');
%     disp(size(stillness));
%     disp(class(stillness));
%     
    
    if(strcmp(state,'active'))
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
    end
    
    
    last_delta_w = delta_w;
    r_w(k) = getWindowWeight(data1.quat(startIndex:data_steps:endIndex,:),data2.quat(startIndex:data_steps:endIndex,:),j);
    
%     disp('r_w:');
%     disp(size(r_w));
%     disp(class(r_w));
    
    
    
    if(startup_estimation)
        r_w_mod(k) = 1;
        tauDelta_mod(k) = 0.8;
        tauBias_mod(k) = 1;
    else
        r_w_mod(k) = r_w(k);
        tauBias_mod(k) = tauBias;
        tauDelta_mod(k) = tauDelta;
    end
    if(strcmp(state,'stillness'))
        r_w_mod(k) = 1;
    end
    delta(k) = delta_w;
%     disp('r_w_mod:');
%     disp(size(r_w_mod));
%     disp(class(r_w_mod));
%     disp('tauDelta_mod:');
%     disp(size(tauDelta_mod));
%     disp(class(tauDelta_mod));
%     disp('tauBias_mod:');
%     disp(size(tauBias_mod));
%     disp(class(tauBias_mod));
%     disp('delta:');
%     disp(size(delta));
%     disp(class(delta));
    
    
end
% Cut the arrays to the right length
if(strcmp(alignment,'backward'))
    delta_filt      = headingFilter_extrap(unwrap(delta),r_w_mod,estimation_rate,tauDelta_mod,tauBias_mod,minWeight,window_time);
else
    delta_filt      = headingFilter(unwrap(delta),r_w_mod,estimation_rate,tauDelta_mod,tauBias_mod,minWeight);
end

delta           = interp1(data1.time(starts),unwrap(delta),data1.time,'linear');
delta_filt      = interp1(data1.time(starts),delta_filt,data1.time,'linear');
r_w             = interp1(data1.time(starts),r_w,data1.time,'linear');
stillness       = interp1(data1.time(starts),stillness,data1.time,'linear');
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