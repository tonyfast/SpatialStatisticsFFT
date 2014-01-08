function [ Tpc Spc ] = PairCorrelationFFT( A1, A2, varargin );
% This function uses the SpatialStatsFFT to compute the pair correlation function by integrating over the angles in the vector resolved statistics space.
% There is a faster way to do this using Alex Gray's methods.
% 
% Tpc - Is the average probability for the pair correlation
% Spc - Is the standard deviation of the probability for the pair correlation

switch nargin
    case 1
        [T,xx] = SpatialStatsFFT( A1, [],'display', false );
    case 2
        [T,xx] = SpatialStatsFFT( A1, A2,'display', false );
    otherwise
        str = '[T,xx] = SpatialStatsFFT( A1, A2, ';
        for ii = 1 : numel( varargin)
            str = horzcat( str, sprintf('varargin{%i},',ii));
        end
        str = horzcat(str(1:(end-1)),',''display'',false);');
        eval(str);
end

XX = zeros(size(T));
switch ndims( T )
    case 1
        XX(:) = round( xx.values{1} );
    case 2
        XX(:) = round(sqrt(bsxfun( @plus, [xx.values{1}.^2]', xx.values{2}.^2)));
    case 3
        XX(:) = round(sqrt(bsxfun( @plus, bsxfun( @plus, [xx.values{1}.^2]', xx.values{2}.^2),permute(xx.values{3},[ 1 3 2]))));
end

Tpc = accumarray( XX(:)+1, T(:),[], @mean);
if nargout==2
    Spc = accumarray( XX(:)+1, T(:),[], @std);
end

