function u_tilde = defuzzification(u_indx)
% defuzzification to generate output u_tilde(normalized value) from fuzzy inference output u_indx
% input(u_indx) : fuzzy set output
% output(fuzzy) : normalized u_tilde
% Fuzzy layer configuration : NB(1), NS(2), ZO(3), PS(4), PB(5)
% 2017.12.07 Hyosung Hong

u_range = linspace(-1, 1, 100);
if isempty(u_indx) ~= 1     % if u_indx contains some data
    u_candidate = zeros(size(u_indx,1), size(u_range,2));
    
    for i=1:size(u_indx, 1)
        switch u_indx(i,1)
            case 1
                for j=1:size(u_range,2)
                    if u_range(j) < -2/3
                        u_candidate(i,j) = min(1, u_indx(i,2));
                    elseif u_range(j) > -2/3 && u_range(j) < -1/3
                        u_candidate(i,j) = min(-3*u_range(j) - 1, u_indx(i,2));
                    end
                end
                
            case 2
                for j=1:size(u_range,2)
                    if u_range(j) >= -2/3 && u_range(j) < -1/3
                        u_candidate(i,j) = min( 3*u_range(j) + 2, u_indx(i,2));
                    elseif u_range(j) > -1/3 && u_range(j) < 0
                        u_candidate(i,j) = min(-3*u_range(j)    , u_indx(i,2));
                    end
                end
                 
            case 3
                for j=1:size(u_range,2)
                    if u_range(j) >= -1/3 && u_range(j) < 0
                        u_candidate(i,j) = min( 3*u_range(j) + 1, u_indx(i,2));
                    elseif u_range(j) > 0 && u_range(j) < 1/3
                        u_candidate(i,j) = min(-3*u_range(j) + 1, u_indx(i,2));
                    end
                end
               
            case 4
                for j=1:size(u_range,2)
                    if u_range(j) >= 0 && u_range(j) < 1/3
                        u_candidate(i,j) = min( 3*u_range(j)    , u_indx(i,2));
                    elseif u_range(j) > 1/3 && u_range(j) < 2/3
                        u_candidate(i,j) = min(-3*u_range(j) + 2, u_indx(i,2));
                    end
                end
                
            case 5
                for j=1:size(u_range,2)
                    if u_range(j) >= 1/3 && u_range(j) < 2/3
                        u_candidate(i,j) = min( 3*u_range(j) - 1, u_indx(i,2));
                    elseif u_range(j) > 2/3
                        u_candidate(i,j) = min(1, u_indx(i,2));
                    end
                end
                
            otherwise
                u_candidate(i,:) = 0;
        end
    end
else
    u_candidate = zeros(1,size(u_range,2));
end

u_union = max(u_candidate, [], 1);

u_tilde = sum(u_range*u_union')/sum(u_union);

end