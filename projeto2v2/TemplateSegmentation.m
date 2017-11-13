function mask = TemplateSegmentation(temp_img, test_img, Hp)
%Segment the template object from the test image.

ref_size = size(temp_img);

ref_corners = [1            1           1;
               ref_size(2)  1           1;
               ref_size(2)  ref_size(1) 1;
               1            ref_size(1) 1]';

tst_corners = Hp*ref_corners;
tst_corners = tst_corners./tst_corners(3,:);

% Image results
figure;
subplot(1,2,1);
imshow(temp_img);
hold on;
scatter(ref_corners(1,:), ref_corners(2,:), '*');
subplot(1,2,2);
imshow(test_img);
hold on;
scatter(tst_corners(1,:), tst_corners(2,:), '*');

% Create template mask over test image
mask = roipoly(test_img, tst_corners(1,:), tst_corners(2,:));

end

