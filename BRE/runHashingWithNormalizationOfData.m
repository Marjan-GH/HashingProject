clear all
%load('C:\Users\Marjan\Dropbox\Time Series Data\processed-by-dave\wafer-downsampled.mat');
load('C:\Users\Marjan\Dropbox\Time Series Data\Marjan-reformat-cuturi\auslanshort2.mat');
[dX]=makeDataNormal(X);
X=dX;
hashing_comparison_script