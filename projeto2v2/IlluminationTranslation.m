function B = IlluminationTranslation(A, ref)
%Image B is created by adjusting image A so that its histogram is
%approximately equal to the histogram of ref.

% Crop ROI from image A (expected to have a black mask)
[C, xs, ys] = CropRectROI(A);

% Adjust histogram to match the reference image (ref)
C = imhistmatch(C, ref);

A(ys, xs) = C;
figure;
imshow(A);

end

