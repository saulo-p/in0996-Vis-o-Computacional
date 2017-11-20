clear all;
close all;

exp_params.refs = {'1_ref' '1_ref' '1_ref' '1_ref' '1_ref' '1_ref' ...
                   '2_temp' '2_temp' '2_temp' '2_temp' '2_temp' '2_temp'};

exp_params.tsts = {'1_pitch' '1_pitch' '1_roll' '1_roll' '1_all' '1_all' ...
                   '2_pitch++' '2_pitch++' '2_roll++' '2_roll++' 'books' 'books'};

exp_params.illum = [false true false true false true ...
                    false true false true false true];


for i = 2:2
    current = [exp_params.refs{i} ' ' ...
               exp_params.tsts{i} ' ' ... 
               num2str(exp_params.illum(i))];
           
    Mmatches = [];
    Minls = [];
    for j = 1:10
        [matches, inls] = InvariantMatching(exp_params.refs{i}, ...
                                            exp_params.tsts{i}, ...
                                            exp_params.illum(i));
        Mmatches{j} = matches;
        Minls{j} = inls;
    end
    
    % save data
    save(['./report/' num2str(i)], 'current', 'Mmatches', 'Minls');
end


%% Statistics
maxes_m = [];
maxes_i = [];
for i = 1:length(Mmatches)
    maxes_m = [maxes_m max(Mmatches{i})];
    maxes_i = [maxes_i max(Minls{i})];
end

disp(mean(maxes_m))
disp(std(maxes_m))
disp(mean(maxes_i))
disp(std(maxes_i))