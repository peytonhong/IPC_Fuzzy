function fuzzy = fuzzification(e, de)
% Get the normalized fuzzy output value from error, error_dot
% input(sigma) : e(error), de(delta error)
% output(fuzzy) : mu(e), mu(de) : normalized fuzzy value
% Fuzzy layer configuration : NB, NS, ZO, PS, PB
% 2017.12.07 Hyosung Hong

fuzzy = zeros(5,2); % Column: [NB, NS, ZO, PS, PB]' , Row: [mu(e), mu(de)]

for i=1:2
    if i==1
        sigma = e;
    else
        sigma = de;
    end
    
    if sigma < -2/3
        fuzzy(1,i) = 1;
    elseif sigma >= -2/3 && sigma < -1/3
        fuzzy(1,i) = -3*sigma - 1;
        fuzzy(2,i) = 3*sigma + 2;
    elseif sigma >= -1/3 && sigma < 0
        fuzzy(2,i) = -3*sigma;
        fuzzy(3,i) = 3*sigma + 1;
    elseif sigma >= 0 && sigma < 1/3
        fuzzy(3,i) = -3*sigma + 1;
        fuzzy(4,i) = 3*sigma;
    elseif sigma >= 1/3 && sigma < 2/3
        fuzzy(4,i) = -3*sigma + 2;
        fuzzy(5,i) = 3*sigma - 1;
    else
        fuzzy(5,i) = 1;
    end
end

end