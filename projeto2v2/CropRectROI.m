function [B, x_range, y_range] = CropRectROI(A, rec_size)
%Receives image with black frame and returns the content without the black.

sum_h = sum(A, 2);
sum_v = sum(A, 1);

f_h = find(sum_h);
f_v = find(sum_v);

x_range = f_v(2):f_v(2) + rec_size(2) - 1;
y_range = f_h(2):f_h(2) + rec_size(1) - 1;

B = A(y_range, x_range);

end

