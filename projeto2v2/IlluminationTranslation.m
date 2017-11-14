function [ output_args ] = IlluminationTranslation( h1, h2 )
%TODO

figure;
subplot(2,2,1)
plot(h1);
title('h1');
subplot(2,2,2)
plot(h2);
title('h2');

% Compute cumulatives
F1 = cumsum(h1);
F2 = cumsum(h2);

subplot(2,2,3)
plot(F1);
title('F1');
subplot(2,2,4)
plot(F2);
title('F2');


end

