function u_indx = fuzzy_inference(fuzzy)
% fuzzy inference to generate fuzzy set and corresponding output u set
% input(fuzzy) : normalized fuzzy value mu(e), mu(de)
% output(u_indx) : fuzzy set output
% Fuzzy layer configuration : NB(1), NS(2), ZO(3), PS(4), PB(5)
% 2017.12.07 Hyosung Hong

fuzzy_rule =  [1 1 1 2 1; 
                1 1 2 5 4; 
                1 1 3 5 5; 
                4 1 4 5 5; 
                5 4 5 5 5];
fuzzy_indx = [];

for i=1:5
    if fuzzy(i,1) > 0
        for j=1:5
            if fuzzy(j,2) > 0
                if fuzzy_rule(i,j) > 0     % only use the defined fuzzy rules
                    fuzzy_indx = [fuzzy_indx; [i,j]];    % example: fuzzy_indx = [NS NS; ZO NB; ZO NS] to determine u_indx
                end
            end
        end
    end
end

if isempty(fuzzy_indx) == 1
    u_indx = [];
else
    u_indx = zeros(size(fuzzy_indx));
    
    for i=1:size(u_indx,1)
        u_indx(i,:) = [fuzzy_rule(fuzzy_indx(i,1), fuzzy_indx(i,2)), min(fuzzy(fuzzy_indx(i,1), 1), fuzzy(fuzzy_indx(i,2), 2))];
        % example: u_indx = [NS, 0.2;  ZO, 0.2;  ZO, 0.7];
    end
end

end
