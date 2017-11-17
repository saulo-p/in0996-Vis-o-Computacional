function B = IlluminationTranslation(A, ref)
%Image B is created by adjusting image A so that its histogram is
%approximately equal to the histogram of ref.
dref = im2double(ref);
th = 0.8;
th_bin = 0.15;

% Crop ROI from image A (expected to have a black mask)
[C, xs, ys] = CropRectROI(A, size(ref));

% LPF:
% h = fspecial('gaussian',7,1.5);
% C = imfilter(C,h);
% dref = imfilter(dref,h);

% figure;
% imshow(abs(C - dref) < th_bin);
% disp(sum(sum(abs(C - dref) < th_bin))/(size(ref,1)*size(ref,2)));

if( ssim(C, dref) > th )
% if( sum(sum(abs(C - dref) < th_bin))/(size(ref,1)*size(ref,2)) > th )
    % Adjust histogram to match the reference image (ref)
    C = imhistmatch(C, ref);

    A(ys, xs) = C;
    figure;
    imshow(A);
end

B = A;

end

