function [delta,delta_filt,r_w] = getDelta_2D(meta,data1,data2,constraint,constraintType,alignment,varargin)


%% Params
gnSteps = 5;
window_time = 20; % s
data_rate = 5; % Hz
estimation_rate = 1; %Hz

tauDelta = 10;
tauBias = 10;
minWeight = 0.45;

if(nargin>6)
    window_time = varargin{1};
end
if (nargin>7)
    estimation_rate = varargin{2};
end
if (nargin>8)
    data_rate = varargin{3};
end
if (nargin>9)
    tauDelta = varargin{4};
end
if (nargin>10)
    tauBias = varargin{5};
end
if (nargin>11)
    minWeight = varargin{6};
end


sampling_time = 1.0/double(meta.rate);
sample_rate = 1/sampling_time;

window_steps = window_time * sample_rate;
estimation_steps = 1/estimation_rate * sample_rate;
data_steps = 1/data_rate * sample_rate;

j1 = meta.joints{1}(1,:);
j2 = meta.joints{1}(2,:);


%% Preparation
steps = length(data1.t);
estimations = length(2:estimation_steps:(steps-window_steps));
delta = zeros(estimations,1);
r_w = zeros(estimations,1);
last_delta_w = 0;
params_w = [0 0];

switch alignment
    case 'backward'
        starts = window_steps+1:estimation_steps:(steps-1);
    case 'center'
        starts = window_steps/2+1:estimation_steps:(steps-window_steps/2);
    case 'forward'
        starts = 2:estimation_steps:(steps-window_steps);
end


%% Estimation
for k = 1:estimations    
   
    % index calculation
    index = starts(k);    % calculate the start and end index of the chosen alignment
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
    
    
    % estimation
    delta_w  = delta_est_window(data1.quat(startIndex:data_steps:endIndex,:),...
        data2.quat(startIndex:data_steps:endIndex,:),...
        data1.gyr(startIndex:data_steps:endIndex,:),...
        data2.gyr(startIndex:data_steps:endIndex,:),...
        j1,...
        j2,...
        gnSteps,...
        last_delta_w,...
        constraint);
    
    delta(k) = delta_w(1);
    last_delta_w = delta_w(1);
    
    % window rating
    sampleWeights = getConstraintWeight('2D_static',...
        {j1,j2},...
        data1.quat(startIndex:endIndex,:),...
        data2.quat(startIndex:endIndex,:));
    r_w(k) = rms(sampleWeights);
end

% filtering
delta_filt  = headingFilter(delta,r_w,estimation_rate,tauDelta,tauBias,minWeight);

% interpolation
delta       = interp1(meta.time(starts),delta,meta.time,'linear');
delta_filt  = interp1(meta.time(starts),delta_filt,meta.time,'linear');
r_w         = interp1(meta.time(starts),r_w,meta.time,'linear');

% fill the NaN entries with zeros
delta(isnan(delta)) = 0;
delta_filt(isnan(delta_filt)) = 0;
end


%% delta_est_window
function delta = delta_est_window(q1,q2,gyr1,gyr2,j1,j2,gnSteps,startVal,constraint)

delta = startVal;
for i = 1:gnSteps
    [deltaParams,~] = gnStep(q1,q2,gyr1,gyr2,j1,j2,delta,constraint);
    delta = delta + deltaParams;
end
delta = limitHeading(delta);
end


%% gnStep
function [deltaParams,totalError] = gnStep(q1,q2,gyr1,gyr2,j1,j2,delta,constraint)
[errors,jacobi] = getErrorAndJac_2D(q1,q2,gyr1,gyr2,j1,j2,delta,constraint);
deltaParams = -(mldivide((jacobi'*jacobi),jacobi'*errors));
totalError = norm(errors);
end