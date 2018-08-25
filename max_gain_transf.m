function [T,gain,ttype] = max_gain_transf(P1,P2,BW1,BW2)
%MAX_GAIN_TRANSF Finds the transformation that maximizes the Gain metric
%          The algorithm takes two sets of corresponding points
%          and the binary images as input and outputs the best transformation that
%          registered the binaries

% Input -  P1: an array with size N X 2 containing the first set of points.
%       -  P2: N X 2 vactor containing the corresponding points of the first set of points
%       -  BW1: binary image from where P1 were taken
%       -  BW2: binary image from where P2 were taken

% Output - T: the best transformation found
%        - gain: the best gain obtained
%        - ttype: the best transformation type

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
    ttypes = {'Similarity','Affine','Projective','Quad'};
	tr = cell(1,4);
	tr{1} = fit_transf(P2,P1,'similarity',0);
	tr{2} = fit_transf(P2,P1,'affine',0);
	tr{3} = fit_transf(P2,P1,'projective',0);
	tr{4} = fit_transf(P2,P1,'polynomial',2);
	
	g = zeros(1,4);
	for i=1:4
		g(i) = calc_gain(tr{i},BW1,BW2);
	end
	[~,best] = max(g);
    
    ttype = ttypes{best};
	T = tr{best};
	gain = g(best);
end

function gain = calc_gain(tform,BW1,BW2)
	imSize = imref2d(size(BW1));
	if ~isempty(tform)
		transBW = imwarp(BW2,tform,'linear','OutputView',imSize);
		before = sum(sum(and(BW1,BW2)));
		after = sum(sum(and(BW1,transBW)));
		gain = after/before;
	else
		gain = 0;
	end
end

function T = fit_transf(P2,P1,ttype,d)
	try
		if d==0
			T = fitgeotrans(P2,P1,ttype);
		else
			T = fitgeotrans(P2,P1,ttype,d);
		end
	catch
		T = [];
	end
end
