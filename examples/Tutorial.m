%% Spatial Statistics Tutorial for Materials Science Problems
% Spatial statistics are an emerging statistical quantification technique
% for materials science information.  

%% Microstructure Encoding
% Material information is typically preprocessed, or encoded, as a signal.
% as digital signal.  Signal encoding includes feature extraction and
% parametrization of materials information.
%
% Sample files are provided in the repository in ./examples/Data.
% To start, "LowQuality.png" is imported into the workspace.
% LowQuality.png is a compressed image of alpha/beta Titanium provided by
% Hamish Frasier at OSU.  Units and other critical metadata elements have
% been excluded from this example.

information = cast(imread('LowQuality.png'),'double');
% subplot(121);
pcolor(information)
% Pretty up the image
shading flat; axis equal; hc = colorbar; colormap gray; set(get( hc, 'Ylabel'),'String','Pixel Intensity') 
title( 'Sample Information')
%/Pretty up the image
snapnow
% subplot(122)
[yy,xx] = hist( information(:), linspace(0,255,25));
plot(xx,yy./sum(yy),'LineWidth',3); xlim( [ 0 255])
axis square; grid on;
title( 'Pixel Intensity Histogram' )

%%
% In the above image, lower pixel values (black values ) indicate beta
% Titanium phase and high pixel values ( white values ) indicate the alpha
% phase.  This image has been compressed from a larger size which leaves
% artifacts on partial alpha/beta pixels.  In the next step we will encode
% the image to isolate the alpha and beta phases.
encoded = round( information./255 );  %normalize by the max pixel intensity and round
pcolor(encoded)
% Pretty up the image
shading flat; axis equal; hc = colorbar; colormap gray; set(get( hc, 'Ylabel'),'String','Pixel Intensity') 
title( 'Encoded Information')
%/Pretty up the image
snapnow
% subplot(122)
[yy,xx] = hist( encoded(:), linspace(0,1,25));
plot(xx,yy./sum(yy),'LineWidth',3); xlim( [ 0 1])
axis square; grid on;
title( 'Encoding Intensity Histogram' )

%%
% Now the pixel values are either zero or one for beta and alpha
% respectively.

%%
% Another example of an encoding for the dataset would be edge detection.
edges = 1-double(edge( encoded ));
pcolor( edges );
shading flat; axis equal; hc = colorbar; colormap gray;  
title( 'Grain Boundary Encoding')

%%
% Black pixel values indicate edges in the image.

%%
% _Other typical encodings would be to perform more advanced feature
% extraction or to parametrize the datasets.  This section will expanded in
% the future._
%% Mathematics
% From a collection of signals, the spatial statistics resolve
% probabilities of spatial arranges.  Choosing
%
% $$f^{hh'}_t = \frac{\mbox{events when h and h' are at the head and tail of vector t}}{\mbox{number of times vector t is sampled}}$$
%
%%
% Auto-correlation occurs when 
% $$ h=h' $$
%
% Cross-correlation occurs when 
% $$ h=h' $$
%%
%% Signal Encoding/Feature Detection
%% Algorithms examples