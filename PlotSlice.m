function h = PlotSlice( Stats, xx, slice )
% Plot a slice of the spatial statistics with proper axes.  This function
% requires the output comes from SpatialStatisticsFFT for it to work optimally.
% If the spatial statistics and raw and unshifted then this functional
% will shift them for the most visually effective communication of the
% spatial statistics.
%
% Stats - the first output from SpatialStatisticsFFT
% xx - the second output containing carrying indicial notation to the
% vectors in the statistscs output from SpatialStatisticsFFT.
%
% slice - defines the slice to look at.  The slice is defined by an integer
% value for the slide of interest in the dimension of interest.
%   slice = [nan nan 0]; Plots the spatial statistics in x and y for the
%   z slice where the vector is z=0;
%   slice = [ nan -10 nan]; plots the statistics in x and z for -10 vector
%   in the y direction;
%

% Non-singleton dimension
order = find( isnan( slice ) );
layer = find( ~isnan( slice ) );
layer_index = slice( layer );


%% Parse Slice
% Convert volumetric data to a slice and account for the change in axes.
varexec = 'squeeze(Stats(';
for ii = 1 : 3
    if ismember( ii,order )
        varexec = horzcat( varexec,':');
    else
        varexec = horzcat( varexec,num2str( find( xx.values{ii}==layer_index)));
    end
    if ii < 3
        varexec = horzcat( varexec,',');
    else
        varexec = horzcat( varexec,'));');
    end
end

Stats = eval( varexec);

%% Shift the image if its not
% It is best to execute the statistics with the shift
% [Stats xx] = SpatialStatsFFT( A1,A2, 'shift',true);

shifted = true;
for ii = 1 : 3
    if numel( xx.values ) <= ii
        shifted = issorted(xx.values{ii} );
    end
    if ~shifted
        break;
    end
end

if ~shifted
    Stats = fftshift( Stats );
    for jj = 1 : 3
        if numel( xx.values ) <= ii
            xx.values{jj}= fftshift(xx.values{jj});
        end
    end
end

%% Do the plotting
% A lot of this plotting is regurgitated from the SpatialStatsFFT code.

h = pcolor( xx.values{ order(2)},xx.values{ order(1)},Stats );
xlabel( sprintf('Vector in %i direction',order(2)),'Fontsize',16);
ylabel( sprintf('Vector in %i direction',order(1)),'Fontsize',16);
axis equal;
axis tight;
shading flat;

figure(gcf)

title( sprintf('Statistics Slice %i vector in the %i direction', layer_index, layer),'Fontsize',16)
hc =colorbar;
set( get( hc,'Ylabel'), 'String', 'Probability','Fontsize',14,'Rotation',270,'VerticalAlignment','bottom')

% export the figure handle