%% Multi-phase statistics
% The autocorrelation and crosscorrelation for binary phase images are
% simple.  The complete spatial statistics are a block matrix of different
% spatial correlation functions.

data{1} = load('three-phase'); 
data{1} = setfield( data{1}, 'phase',data{1}.A); 
data{1} = rmfield( data{1}, 'A');
% Number of phases 
data{1}.numphase = numel( unique( data{1}.phase ));
data{1}.uniquephase = unique( data{1}.phase );

pcolor( data{1}.phase); shading flat; hc = colorbar; set( get( hc, 'Ylabel'),'String','phase');
saveas( gcf, './assets/three-phase.png'); title('Location of three phases in a synthetic structure');

data{1}.image{1} = 'three-phase.png';
data{1}.name = 'Synthetic three-phase structure';


%% The complete spatial statistics for a 3-D structure
% Loop of the local states $$h=1..H$$ for both the head and the tail of the
% vector.

clearvars F;
rcut = 50;
data{2}.name = 'Correlations of Phase';
ct= 0 ;
% Iterate over each phase at the tail of the vector 
for h1 = 1 : data{1}.numphase
    % Iterate over each phase at the head of the vector 
    for h2 = 1 : data{1}.numphase
        ct = ct + 1;
        [ F(:,:,h1,h2) xx] = SpatialStatsFFT( data{1}.phase == data{1}.uniquephase(h1), ...
            data{1}.phase == data{1}.uniquephase(h2), 'cutoff',rcut,'shift',true );
        
        % Visualization of the statistics, not pertinent to code.
        if h1 == h2 typecorr ='auto'; else typecorr='cross'; end
        title({ sprintf('%s-correlation of phase for vectors with',typecorr); ...
            sprintf('h1=%i at the tail & h2 = %i at the head', h1, h2)},'Fontsize',16 );
        axis tight;
        saveas( gcf,fullfile('.','assets',sprintf('cross-h1-%i-h2-%i.png',h1,h2) ) );
        data{2}.image{ct} = sprintf('cross-h1-%i-h2-%i.png',h1,h2);
        data{2}.cutoff = rcut;
    end
end
matinpublish( data, 'title','Three Phase Data Correlations')

%%
% A visualization of each of the statistics can be found here on the
% <Three-Phase-Data-Correlations.html dataset>
% page.

%% Spatial Statistics Symmetries for Discrete Local States
% In the Steve Niezgoda's paper the identities of the Full matrix are
% discussed.

%%
% The Autocorrelation is symmetric with itself
% 
for hh = 1 : data{1}.numphase
    subplot(2,2,1);
    pcolor( F(:,:,hh,hh)); axis equal; axis tight
    title('Original Stats')
    subplot(2,2,2);
    pcolor( F(:,:,hh,hh)'); axis equal; axis tight
    title('Transpose Stats')
    subplot(2,2,[3 4]);
    pcolor( abs(F(:,:,hh,hh)-F(:,:,hh,hh)')); axis equal; axis tight
    title('Original-Minus')
    hc = colorbar; set( get( hc, 'Ylabel'),'String','Absolute Difference');
    snapnow;
end

%%
% The cross-correlation is symmetric with its complimentary vector

%%
% This is example is shown with phase index 1 at the tail of the vector.


h1 = 1; % Phase 1

for hh = 2 : data{1}.numphase
    subplot(2,2,1);
    pcolor( F(:,:,h1,hh)); axis equal; axis tight
    title({'Original Stats',...
        sprintf('tail = phase %i & head = phase %i', h1,hh)})
    subplot(2,2,2);
    pcolor( F(:,:,hh,h1)'); axis equal; axis tight
    title({'Transpose Stats',...
        sprintf('tail = phase %i & head = phase %i', hh, h1)})
    subplot(2,2,[3 4]);
    pcolor( abs(F(:,:,h1,hh)-F(:,:,hh,h1))); axis equal; axis tight
    title('Original-Minus')
    hc = colorbar; set( get( hc, 'Ylabel'),'String','Absolute Difference');
    snapnow;
end