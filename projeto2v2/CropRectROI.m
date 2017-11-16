function [B, x_range, y_range] = CropRectROI(A)
%Receives image with black frame and returns the content without the black.

sum_h = sum(A, 2);
sum_v = sum(A, 1);

f_h = find(sum_h);
f_v = find(sum_v);

x_range = f_v(2):f_v(end-1);
y_range = f_h(2):f_h(end-1);

B = A(y_range, x_range);

end

