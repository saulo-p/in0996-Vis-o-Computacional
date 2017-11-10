%% =======================================================================
% [IN0996] Visão Computacional - Projeto 2
% * A Novel Algorithm for View and Illumination Invariant Image Matching.
%
% References:
%
% TODO:
% * Segment image based on template
% * Rewrite support functions (comments and better practices)
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% ========================================================================
clear all;
close all;
%% Input data

ref = rgb2gray(imread('./data/book_ref.png'));
test = rgb2gray(imread('./data/roll+.jpg'));

ref_sz = size(ref);

%% DDM (Detection, Description and Matching) Framework

% Features Detection and Description (using SURF)
[ref_feats, ref_pts] = extractFeatures(ref, detectSURFFeatures(ref));
[tst_feats, tst_pts] = extractFeatures(test, detectSURFFeatures(test));

% Features Matching
idxMatch = matchFeatures(ref_feats, tst_feats, 'Unique', true);
ref_mt = ref_pts(idxMatch(:,1));
tst_mt = tst_pts(idxMatch(:,2));

figure;
showMatchedFeatures(ref, test, ref_mt, tst_mt, 'montage');

%% Outlier Removal and Pose transformation estimation

% Keypoints (features) in homogeneous coordinates
ref_xh = [ref_mt.Location'; ones(1, ref_mt.Count)];
tst_xh = [tst_mt.Location'; ones(1, tst_mt.Count)];

% Outlier removal (using RANSAC)
[~, ~, idx_inl] = RANSAC(ref_xh, tst_xh);
ref_xh = ref_xh(:, idx_inl);
tst_xh = tst_xh(:, idx_inl);

% Estimate image pose transformation
Hp = f_dlt_norm(ref_xh, tst_xh);
Hp = Hp./Hp(3,3);
% enhance estimation using Gauss Newton
Hp_ = gauss_newton(Hp, ref_xh, tst_xh, 100);

%% Segmentation from template

ref_corners = [1            1           1;
               ref_sz(2)    1           1;
               1            ref_sz(1)   1;
               ref_sz(2)    ref_sz(1)   1]';

tst_corners = Hp_*ref_corners;
tst_corners = tst_corners./tst_corners(3,:);

figure;
subplot(1,2,1);
imshow(ref);
hold on;
scatter(ref_corners(1,:), ref_corners(2,:), '*');
subplot(1,2,2);
imshow(test);
hold on;
scatter(tst_corners(1,:), tst_corners(2,:), '*');

% Create mask and wrap on function