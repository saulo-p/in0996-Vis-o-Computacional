%% =======================================================================
% [IN0996] Visão Computacional - Projeto 2
% * A Novel Algorithm for View and Illumination Invariant Image Matching.
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% ========================================================================
clear all;
close all;
%% Input data

ref = rgb2gray(imread('./data/1_ref.png'));
test = rgb2gray(imread('./data/1_roll.jpg'));

ref_sz = size(ref);
tst_sz = size(test);

% Execution parametes
illum_trans = true;
MAX_ITR = 10;

%% Algorithm 1 (as shown on paper)

% I_it is initialized with test image.
I_it = im2double(test);

% Reference image Features Detection and Description (using SURF)
[ref_feats, ref_pts] = extractFeatures(ref, detectSURFFeatures(ref));

num_inls = [];
for it = 1:MAX_ITR
    disp(['===> Iteração ' num2str(it)]);
    % Current image features.
    [I_feats, I_pts] = extractFeatures(I_it, detectSURFFeatures(I_it));
    
    % Features Matching (reference x current image)
    idxMatch = matchFeatures(ref_feats, I_feats, 'Unique', true);
    
    ref_mt = ref_pts(idxMatch(:,1));
    I_mt = I_pts(idxMatch(:,2));
    % Keypoints (features) in homogeneous coordinates (for future
    % operations)
    ref_xh = [ref_mt.Location'; ones(1, ref_mt.Count)];
    I_xh = [I_mt.Location'; ones(1, I_mt.Count)];
    
    %% TEST: Show current matches (with outliers)
    figure;
    showMatchedFeatures(ref, I_it, ref_mt, I_mt, 'montage');
    title(['Feature matches from template (left) and test image (right):' ...
           num2str(length(idxMatch)) ...
           ' matches.  Iteration # = ' num2str(it)]);
        
    % Remove outlier matches and estimate pose Hp using RANSAC
    [Hp, n_inl, idx_inl] = RANSAC(ref_xh, I_xh);
    num_inls = [num_inls n_inl];
    
    % Keep only the estimated inlier features
    ref_xh = ref_xh(:, idx_inl);
    I_xh = I_xh(:, idx_inl);
    
    %% TEST: Show inlier matches
    figure;
    str_title = ['Inlier matches: ' num2str(n_inl) ' inliers'];
    subplot(1,2,1); imshow(ref); hold on; scatter(ref_xh(1,:), ref_xh(2,:), 'r');
    title(str_title);
    subplot(1,2,2); imshow(I_it); hold on; scatter(I_xh(1,:), I_xh(2,:), 'g+');
    title(str_title);
    
    [mask, valid] = TemplateSegmentation(ref, I_it, Hp);
%     figure; imshow(mask.*I_it);
    
    if(~valid)
        % TODO (laço apenas contemplar parte estocástica)
        disp('Current pose estimate is not good enough');
        close all;
        continue;
    end
    
    % Apply pose transformation
    Hp_ = inv(Hp);
    Hp_ = Hp_./Hp_(3,3);
    I_roi = imwarp(mask.*I_it, projective2d(Hp_'));
    I_it = imwarp(I_it, projective2d(Hp_'));
        
    % Histogram processing
    if (illum_trans)
        I_roi_t = IlluminationTranslation(I_roi, ref);
        I_it = (I_roi_t > 0).*I_roi_t + (I_roi_t == 0).*I_it;
        figure;
        imshow(I_it);
        title('Illumination translation'); 
    end
    % Termination condition check
    R = Hp_(1:2,1:2)/sqrt(det(Hp_(1:2,1:2)));
%     disp(norm(inv(R) - R'));
    if ( norm(inv(R) - R') < 5e-3 || ...
         num_inls(end) < num_inls(max([1 (length(num_inls)-1)])) )
        disp(['Termination condition achieved' ...%newline ...
              ' Ortogonalidade: ' num2str(norm(inv(R) - R')) ...%newline ...
              ' Max inliers: ' num2str(max(num_inls))] );
        break;
    end
    
end

