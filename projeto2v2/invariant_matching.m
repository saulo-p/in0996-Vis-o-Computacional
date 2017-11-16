%% =======================================================================
% [IN0996] Visão Computacional - Projeto 2
% * A Novel Algorithm for View and Illumination Invariant Image Matching.
%
% References:
%
% TODO:
% * Check RANSAC stability.
%   * and parameterize the function.
% * Rewrite support functions (comments and better coding practices)
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% ========================================================================
clear all;
close all;
%% Input data

ref = rgb2gray(imread('./data/book_ref.png'));
test = rgb2gray(imread('./data/roll.jpg'));

ref_sz = size(ref);
tst_sz = size(test);

%% Algorithm 1 (as shown on paper)

% Loop initializations:
I_it = im2double(test);
% Reference image Features Detection and Description (using SURF)
[ref_feats, ref_pts] = extractFeatures(ref, detectSURFFeatures(ref));
num_matches = [];
% Reference image histogram
% h_ref = imhist(ref);

for it = 1:3
    % Current image features
    [I_feats, I_pts] = extractFeatures(I_it, detectSURFFeatures(I_it));
    
    % Features Matching (reference x current image)
    idxMatch = matchFeatures(ref_feats, I_feats, 'Unique', true);
    num_matches = [num_matches length(idxMatch)];
    ref_mt = ref_pts(idxMatch(:,1));
    I_mt = I_pts(idxMatch(:,2));
    
    %% TEST: Show current matches (with outliers)
    figure;
    showMatchedFeatures(ref, I_it, ref_mt, I_mt, 'montage');
    title(['Feature matches from template (left) and test image (right):' ...
           num2str(length(idxMatch)) ...
           ' matches.  Iteration # = ' num2str(it)]);
    
    % Keypoints (features) in homogeneous coordinates
    ref_xh = [ref_mt.Location'; ones(1, ref_mt.Count)];
    I_xh = [I_mt.Location'; ones(1, I_mt.Count)];
        
    % Remove outlier matches and estimate pose Hp using RANSAC
    [Hp, n_inl, idx_inl] = RANSAC(ref_xh, I_xh);
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
        disp('Current pose is not considered valid');
        continue;
    end
    
    % Apply pose transformation
    Hp_ = inv(Hp);
    Hp_ = Hp_./Hp_(3,3);
    I_roi = imwarp(mask.*I_it, projective2d(Hp_'));
    I_it = imwarp(I_it, projective2d(Hp_'));
   
    % Histogram processing
%     h_roi = imhist(I_roi);
%     h_roi(1) = 0;
%     IlluminationTranslation(h_ref, h_roi);
    I_roi_t = IlluminationTranslation(I_roi, ref);

end

