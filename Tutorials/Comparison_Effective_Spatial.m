%% Spatial Statistics and Effective Statistics
% Spatial statistics are a super set of low order statistics.  



%%
% data = titanium_micrograph('Medium');
% 
% % Compute the spatial statistics
% [data.stats xx ] = SpatialStatsFFT( data.phase );
% 
% % Find volume fraction from the spatial statistics
% data.vfspatial = data.stats(xx.values{1}==0, xx.values{2}==0);

%% Benchmarking

labels = {'Square', 'Large Square', 'Thumbnail', 'Small', 'Small 320', ...
    'Medium', 'Medium 640', 'Medium 800', 'Large', 'Large 1600', 'Large 2048', 'Original'};

%% Boundary Condition Information
bndnm = {'np','pp2','pp1','per'};

description = {'Nonperiodic Statistics', 'Partial Periodic in Y', 'Partial Periodic in X', 'Periodic' };
bndstate = ( [ zeros(1,2); eye(2); ones(1,2) ] );

%%
for ii = [];1: numel(labels);
    disp( sprintf('Fetching data for label="%s"', labels{ii}) );
    clear data
    [ data{1} ] = deal(titanium_micrograph( labels{ii} ));
    disp( sprintf('Computing statistics for label="%s"', labels{ii}) );
    
    % Iterate over the periodicity hyperparameter
    for pp = 1 : size( bndstate,1 )
        [data{pp+1}.statsx data{pp+1}.statsy] = deal(bndstate(pp,1),bndstate(pp,2));
        data{pp+1}.name = description{pp};
        
        tic;
        [data{pp+1}.(bndnm{pp}) xx{pp} ] = SpatialStatsFFT( data{1}.phase,[],'display',false, 'periodic', logical([ data{pp+1}.statsx data{pp+1}.statsy]),'shift',true );
        t(pp) = toc;
        
        data{pp+1}.fraction = data{pp+1}.(bndnm{pp})( xx{pp}.values{1}==0, xx{pp}.values{2}==0);
        
        % Plot statistics
        pcolor( xx{pp}.values{2}, xx{pp}.values{1}, data{pp+1}.(bndnm{pp}) );
        hc = colorbar; set(get( hc, 'Ylabel' ), 'String','Probability'); shading flat;
        data{pp+1}.image{1} = sprintf('stats-%s-%i-%i.png', bndnm{pp}, ii, pp);
        saveas( gcf, fullfile('.','assets',data{pp+1}.image{1} ));
        close all;
        % Difference in stats
        if pp > 1
            for bb = 1 : 2
                isxx{bb} = ismember( xx{1}.values{bb}, xx{pp}.values{bb} );
            end
            pcolor( xx{pp}.values{2}(isxx{2}), xx{pp}.values{1}(isxx{1}),  data{2}.np(isxx{1},isxx{2}) - data{pp+1}.(bndnm{pp}) );
            data{pp+1}.image{2} = sprintf('diff-%s-%i-%i.png', bndnm{pp}, ii, pp);
            hc = colorbar; set(get( hc, 'Ylabel' ), 'String','Difference in Probability from NonPeriodic'); shading flat;
            saveas( gcf, fullfile('.','assets',data{pp+1}.image{2} ));
            close all;
        end
    end
%     matinpublish( data, 'title', sprintf('Stats %s Size', labels{ii}));
    bench(ii,:) = [ ii numel(data{1}.phase) t(:)' ];
end

bench = sortrows(bench,2);


%%
% Sort by number of elements

%% Plot the performance of the code
% THis is my description

co = [ .3*ones(1,3); eye(3)];
h(1) = plot( bench(:,2), bench(:,3), '-o','LineWidth',3,'Markersize',16,'Color',co(1,:));
text( bench(:,2), (bench(end,3)-bench(1,3))./log10(bench(end,2)./bench(1,2)).*log10(bench(:,2)./bench(1,2)) + bench(1,3) ,...
    labels','Fontsize',16,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
hold on;
for ii = 1 : 3
    h(ii+1) = plot( bench(:,2), bench(:,3+ii), '-o','LineWidth',3,'Markersize',16,'Color',co(ii+1,:));
end
hold off;
set( gca, 'Xtick',bench(:,2), 'XTickLabel',arrayfun( @(x)sprintf( '%2.1f', x), log10( bench(:,2)),'UniformOutput',false),...
    'Fontsize',14, 'Xscale','log' );
grid on;
ylabel('Time to Compute')
xlabel('10^{Number of Voxels}')
title('Benchmark of Spatial Statistics Computation');
legend( h, description,'Location','Northwest');
set( gcf,'Position',get(0,'Screensize'))  % maximize figure
snapnow;
%% Computational Hyperparameters
% Image size
% Cutoff Length