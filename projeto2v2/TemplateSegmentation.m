function [M, valid_scale] = TemplateSegmentation(temp_img, test_img, Hp)
%Segment the template object (temp_img) on the test image (test_img) 
% according to the pose transformation Hp.
%Also checks if the pose appers to be valid according to its effect on the 
% template corners.

ref_size = size(temp_img);
tst_size = size(test_img);

ref_corners = [1            1           1;
               ref_size(2)  1           1;
               ref_size(2)  ref_size(1) 1;
               1            ref_size(1) 1]';

tst_corners =  [1            1;
                tst_size(2)  tst_size(1)]';         
      

temp_corners = Hp*ref_corners;
temp_corners = temp_corners./temp_corners(3,:);

% TEST: Image results
figure;
subplot(1,2,1); imshow(temp_img); hold on; scatter(ref_corners(1,:), ref_corners(2,:), '*');
title('Corners of reference image');
subplot(1,2,2); imshow(test_img); hold on; scatter(temp_corners(1,:), temp_corners(2,:), '*');
title('Estimated corners of test image');

%% Output

% Pose check 1: Corners fit on image size
UL = repmat(tst_corners(:,1), 1, 4); %Upper left
BR = repmat(tst_corners(:,2), 1, 4); %Bottom right
%valid_scale is true if transformed corners lie within the test_img.
valid_scale = (temp_corners(1:2,:) - UL > 0) & ...
              (BR - temp_corners(1:2,:) > 0);
valid_scale = all(all(valid_scale));
          
% Pose check 2: Area is equal to at least 10% of image area
valid_scale = valid_scale && ...
             (max(temp_corners(1,:)) - min(temp_corners(1,:)) > 0.1*ref_size(1) && ...
              max(temp_corners(2,:)) - min(temp_corners(2,:)) > 0.1*ref_size(2));


% Create template mask over test image
M = roipoly(test_img, temp_corners(1,:), temp_corners(2,:));

end

