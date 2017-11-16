function varargout = imhistmatch_mod(A, ref)
%Copy of the MATLAB original function "imhistmatch" with slight
%modification to cope with ROI image.

% Compute histogram of the reference image
hgram = imhist(ref);

% Adjust A using reference histogram
hgramToUse = 1;
for p = 1:size(A,4)
    % Use A to store output, to save memory
    A(:,:,p) = histeq(A(:,:,p), hgram(hgramToUse,:));
end

% Always set varargout{1} so 'ans' always gets
% populated even if user doesn't ask for output
varargout{1} = A;
if (nargout == 2)
    varargout{2} = hgram;
end


end
