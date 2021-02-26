function [delta_out, bias] = headingFilter_extrap(delta, rating, estimation_rate,tau_bias,tau_delta,minRating,window_time)

% tau_bias = 8; % tuning parameter: time constant for bias filter %15
% tau_delta = 15; % tuning parameter: time constant for heading filter %30
%minRating = 0.4; % tuning parameter: extrapolating if rating < minRating
delta = unwrap(delta);
N = length(delta);
Ts = 1/estimation_rate;
out = zeros(N, 1);
delta_out = zeros(N, 1);
bias = zeros(N, 1);

window_size = window_time*estimation_rate;

k_bias = 1-exp(-Ts*log(2)./tau_bias);
k_delta = 1-exp(-Ts*log(2)./tau_delta);

% if(length(tau_delta)==1)
%     k_delta_new = repmat(k_delta,length(rating),1);    
% end
% if(length(tau_bias)==1)
%     k_bias_new = repmat(k_bias,length(rating),1);    
% end


k_delta_new = repmat(k_delta,length(rating),1);    
k_bias_new = repmat(k_bias,length(rating),1);    



rating(rating<minRating) = 0;
out(1) = delta(1);

for i=2:N
%     bias(i) = bias(i-1) + rating(i) * max(k_bias(i), 1/i) * (wrapToPi(delta(i) - delta(i-1)) - bias(i-1));
    if(length(tau_bias)==1)
        bias(i) = bias(i-1) + rating(i) * max(k_delta_new(i), 1/i) * (local_wrapToPi(delta(i) - delta(i-1)) - bias(i-1));
    else
        bias(i) = bias(i-1) + rating(i) * max(k_bias(i), 1/i) * (local_wrapToPi(delta(i) - delta(i-1)) - bias(i-1));
    end
    if(length(tau_delta)==1)
        out(i) = out(i-1) + bias(i) + rating(i) * max(k_bias_new(i), 1/i) * (local_wrapToPi(delta(i) - out(i-1)) - bias(i));
    else
        out(i) = out(i-1) + bias(i) + rating(i) * max(k_delta(i), 1/i) * (local_wrapToPi(delta(i) - out(i-1)) - bias(i));
    end
    delta_out(i) = out(i) + window_size/2 * bias(i); 
end



end