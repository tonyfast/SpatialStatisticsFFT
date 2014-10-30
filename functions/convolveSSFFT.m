function fA = convolveSSFFT(period,A1,A2)
% convolve pads the data signals then performs the convolution of signals
% A1 and A2 using fast fourier transform algorithms.
% This is the degree to which the image is padded because we are only
% extracting half of the vector
period_mult= .6; %describe this value

% in reality you only need to pad to rmax
realvals = isreal(A1)*ones(1,2);  % supresses imaginary parts if the values in the statistics
nsz = ceil([ones(size(period)) + (1-period)*period_mult].*size( A1));


fA = FourierPadSSFFT( A1, size( A1 ), nsz );

if exist('A2','var') && numel( A2 ) > 0
    if all( nsz == ceil([ones(size(period)) + (1-period)*period_mult].*size( A2)) );    % THIS CONDITION HERE IS PROBLABLY A PROBLEM
        realvals(2) = isreal(A2);
        fA(:) = fA .* conj( FourierPadSSFFT( A2, size(A1), nsz ));
    else
        error('The sizes are incaptable.')
    end
else % Weiner-Kinchin Method to Autocorrelations
    fA(:) = abs( fA ).^2;
end

fA(:) = ifftn( fA );

if all(realvals) fA(:) = real(fA); end;

end