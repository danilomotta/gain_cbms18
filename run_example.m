% If utilizing this code, please cite:
% "Fundus Image Transformation Revisited: Towards Determining More Accurate Registrations"
% D. Motta, W. Casaca, and A. Paiva
% CBMS 2018 – IEEE International Symposium on Computer-Based Medical Systems.
% 
% by Danilo Motta (ddanilomotta@gmail.com)
% ICMC - USP Brazil
% Created: Jan 10 2018
% Last Modified October 08 2018
%
I1 = imread('binary1.png');
I2 = imread('binary2.png');

load('keypoints.mat');

[T,gain,ttype] = max_gain_transf(points(:,1:2),points(:,3:4),I1,I2);

imSize = imref2d(size(I1));
if ~isempty(T)
    bestTI2 = imwarp(I2,T,'linear','OutputView',imSize);
    best_reg = imfuse(I1,bestTI2);
else
    print('Sorry, no transformation was found.')
end

display(['The best transformation found was: ' ttype '.'])

figure;
imshow(best_reg);
title(['Best T: ' ttype]);