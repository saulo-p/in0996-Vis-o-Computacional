%=============================================================
% Genetic Programming Algorithm
%
% References 
% - Computational Algorithms for Fingerprint Recognition
% - Introduction to Evolutionary Computing
%
% * Operators:
% - https://en.wikipedia.org/wiki/Image_moment
% -
%
% TODO:
% - Create utility functions Tree2String and String2Tree
% https://www.mathworks.com/help/matlab/ref/treeplot.html
%
% Author: Saulo P.
% Date created: 23/10/2017
%=============================================================

% Evolution Parameters:
kMaxNodes = 200;
kPopSize = 100;
kMaxGen = 50;
kMaxFeatSize = 35;
kRecombRate = 0.6;
kMutRate = 0.05;



op_list = 1:40;

% 0: 1 image  - 1 scalar
% 1: 1 image  - 1 image
% 2: 2 images - 1 image
% 3: 1 image  - 1 vector
op_arity = [] 

% 1. Random initial population individual computer programs


