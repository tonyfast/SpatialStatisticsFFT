function P = FindPeaksSSFFT( T, varargin )
% Finds the peaks or valleys in the spatial correlation functions.
param = setparam( varargin, numel(T),size(T) );
% Design the filter
F = ones( param.neighborhood);
F( ceil(numel(F)./2) ) = 0;
if ~param.valley
    P = T > imdilate( T, F );
else
    P = T < imerode( T, F );
end



    function param = setparam( varargin, N, sz )
        if sz(2) == 1 & N == sz(1)
            r = 1;
        else
            r = numel( sz );
        end

        param = struct( 'neighborhood', 5*ones(1,r),...
            'valley', false);
        if numel( varargin ) > 0
            for ii = 1 : 2 :numel( varargin )
                param = setfield( param, varargin{ii}, varargin{ii+1});
            end
        end
    end
end   
