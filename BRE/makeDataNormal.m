function [dataX]=makeDataNormal(X)
ndata=size(X,2);
ntime=zeros(ndata,1);
nsample=size(X{1,1},2);


for i=1:ndata
    ntime(i,1)=size(X{1,i},1);
end
maxntime=150;

dataX=zeros(ndata,maxntime*nsample);
for i=1:ndata
    for j=1:maxntime
        % [i,j,ntime(i,1),(j-1)*nsample+1,j*nsample]
        if(j<=ntime(i,1))
           
            dataX(i,(j-1)*nsample+1:j*nsample)=X{1,i}(j,:);
        else
            dataX(i,(j-1)*nsample+1:j*nsample)=X{1,i}(ntime(i,1),:);
        end
    end 
end


    
