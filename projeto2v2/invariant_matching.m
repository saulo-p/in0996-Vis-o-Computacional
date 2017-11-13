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

%% Algorithm

% Loop initializations:
I_it = im2double(test);
% Reference image Features Detection and Description (using SURF)
[ref_feats, ref_pts] = extractFeatures(ref, detectSURFFeatures(ref));
num_matches = [];

for it = 1:2
    % Current image features
    [I_feats, I_pts] = extractFeatures(I_it, detectSURFFeatures(I_it));
    
    % Features Matching (reference x current image)
    idxMatch = matchFeatures(ref_feats, I_feats, 'Unique', true);
    num_matches = [num_matches length(idxMatch)];
    ref_mt = ref_pts(idxMatch(:,1));
    I_mt = I_pts(idxMatch(:,2));
    
    % TEST: Show current matches (with outliers)
    figure;
    showMatchedFeatures(ref, I_it, ref_mt, I_mt, 'montage');
    title(['Feature matches from template (left) and test image (right):' ...,
           length(idxMatch), ...
           ' matches']);
    
    % Keypoints (features) in homogeneous coordinates
    ref_xh = [ref_mt.Location'; ones(1, ref_mt.Count)];
    I_xh = [I_mt.Location'; ones(1, I_mt.Count)];
        
    % Remove outlier matches and estimate pose Hp using RANSAC
    [Hp, n_inl, idx_inl] = RANSAC(ref_xh, I_xh);
    disp(n_inl)
    ref_xh = ref_xh(:, idx_inl);
    I_xh = I_xh(:, idx_inl);
    
    % 'Enhance' pose estimation using Gauss Newton
%     Hp = gauss_newton(Hp, ref_xh, I_xh, 100);
    
    TemplateSegmentation(ref, I_it, Hp);
    
    % TODO (histogram processing steps)
%     mask...
    % Apply pose transformation
    Hp_ = inv(Hp);
    Hp_ = Hp_./Hp_(3,3);
    I_it = imwarp(I_it, projective2d(Hp_'));
    
    figure;
    imshow(I_it);
end

%% DDM (Detection, Description and Matching) Framework
% 
% % Features Detection and Description (using SURF)
% [ref_feats, ref_pts] = extractFeatures(ref, detectSURFFeatures(ref));
% [tst_feats, tst_pts] = extractFeatures(test, detectSURFFeatures(test));
% 
% % Features Matching
% idxMatch = matchFeatures(ref_feats, tst_feats, 'Unique', true);
% ref_mt = ref_pts(idxMatch(:,1));
% tst_mt = tst_pts(idxMatch(:,2));
% 
% figure;
% showMatchedFeatures(ref, test, ref_mt, tst_mt, 'montage');
% hold on;
% title('Feature matches from template (left) and test image (right)');
% 
%% Outlier Removal and Pose transformation estimation
% 
% % Keypoints (features) in homogeneous coordinates
% ref_xh = [ref_mt.Location'; ones(1, ref_mt.Count)];
% tst_xh = [tst_mt.Location'; ones(1, tst_mt.Count)];
% 
% % Remove outlier matches and estimate pose Hp using RANSAC
% [Hp, ~, idx_inl] = RANSAC(ref_xh, tst_xh);
% ref_xh = ref_xh(:, idx_inl);
% tst_xh = tst_xh(:, idx_inl);
% 
% % TODO: TEST: Outlier removal
% % scatter(ref_xh(2,:), ref_xh(1,:), 'b*');
% % scatter(tst_xh(2,:) + tst_sz(2), tst_xh(1,:) + tst_sz(1), 'b*');
% 
% % % Correct possible reflection in the homography
% % if det(Hp(1:2, 1:2)) < 0
% %     Hp = [-1 0 0;0 1 0;0 0 1]*Hp;
% % end
% 
% % Enhance pose estimation using Gauss Newton
% Hp = gauss_newton(Hp, ref_xh, tst_xh, 100);
% 
%% Segmentation from template
% 
% mask = TemplateSegmentation(ref, test, Hp);
% 
% % Image results
% figure;
% subplot(1,2,1);
% imshow(mask);
% subplot(1,2,2);
% imshow(test.*mask);
% 