%=============================================================
% IN 0996 - Projeto 2
% Paper: 
% 
% Dataset : http://www.kasrl.org/jaffe.html
%
% TODO:
% - Usar transformada de gabor para gerar N imagens partindo 
% de uma
% - Implementar dinâmica da programação genética.
%     Usar apenas índices de operadores.
% - Testar SVM (1 iteração da evolução)
% 
%
%
% Author: Saulo P.
% Date created: 23/10/2017
%=============================================================

clear all;
close all;

im = imread('./data/KA.AN1.39.tiff');

gaborBank = gabor(2.^(4:-1:1), 0:-30:-150);

p2 = size(gaborBank, 2);
% p = sqrt(p2);
figure;
for i = 1:p2
   subplot(6,4,p2-(i-1));
   imshow(gaborBank(i).SpatialKernel,[]);
end


[gaborMag, ~] = imgaborfilt(im, gaborBank);

figure;
for i = 1:p2
   subplot(6,4,i);
   imshow(gaborMag(:,:,p2-(i-1)),[]);
   
   theta = gaborBank(p2-(i-1)).Orientation;
   lambda = gaborBank(p2-(i-1)).Wavelength;
   title(sprintf('Orientation=%d, Wavelength=%d',theta,lambda));
end


