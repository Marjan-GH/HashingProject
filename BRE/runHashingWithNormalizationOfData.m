clear all
%load('C:\Users\Marjan\Dropbox\Time Series Data\processed-by-dave\wafer-downsampled.mat');
load('C:\Users\Marjan\Dropbox\Time Series Data\processed-by-dave\wafer.mat');
[dX]=makeDataNormal(X);
X=dX;
hashing_comparison_script