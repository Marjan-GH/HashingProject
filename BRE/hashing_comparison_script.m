%demo script for running BRE

%clear all;

run_lsh = 1;
run_bre = 1;

plotResults = 0;

colors = 'cbmrg';

%construct hash functions using 1000 sampled "training" points
trN = 1000;
%3000 queries for testing
testN = 2000;
%run the algorithms with varying numbers of bits
%numbits = [10 15 20 25 30 35 40 45 50];
numbits = [5 10 15 20 25 30 35 40 45 50];

%X = load('C:\Users\Marjan\Dropbox\Time Series Data\processed-by-dave\wafer-downsampled.mat');
%X=load('labelme.mtx');
testN = min(testN,size(X,1)-trN);

%center, then normalize data
X = X - ones(size(X,1),1)*mean(X);
for i = 1:size(X,1)
    X(i,:) = X(i,:) / norm(X(i,:));
end

%Randomize the index to have random selection 
rp = randperm(size(X,1));
trIdx = rp(1:trN);
testIdx = rp(trN+1:trN+testN);
Xtr = X(trIdx,:);
Xtst = X(testIdx,:);

D_tst = distMat(Xtst,Xtr);
D_tr = distMat(Xtr);
Dball = sort(D_tr,2);
Dball = mean(Dball(:,50));
WTT = D_tst < Dball;
i = 0;
for nb = numbits
    i = i + 1;
    
    %do PCA on the data first
    
    npca = min(nb, size(Xtr,2));
    opts.disp = 0;
    [pc, l] = eigs(cov(Xtr),npca,'LM',opts);
    Xtr2 = Xtr*pc;
    Xtst2 = Xtst*pc;
    X2 = X*pc;
    %Xtr2 and Xtst2 are the train and test data after pca.
    
    if run_bre==1
        %reconstructive hashing
        Ktrain = Xtr2*Xtr2';
        Ktest = (Xtst2)*Xtr2';

        %set parameters for bre:
        params.disp = 0;      
        params.n = size(Ktrain,1);
        params.numbits = nb;
        %what is params.k, Ktrain, Is it relates to distance?
        params.K = Ktrain;
        %what is this (params.hash_size)
        params.hash_size = 50;
        hash_inds = zeros(params.hash_size,params.numbits);
        for b = 1:params.numbits
            rp = randperm(params.n);
            hash_inds(:,b) = rp(1:params.hash_size)';
        end
        params.hash_inds = hash_inds;
        W0 = .001*randn(params.hash_size,params.numbits);

        %run bre
        disp(sprintf('Running BRE with %d bits.',nb));
        [W,H] = BRE(W0,params);

        %form hash keys over queries
        clear H_query
        for b = 1:params.numbits
            H_query(:,b) = Ktest(:,hash_inds(:,b))*W(:,b);
        end
        H_query = (H_query)>0;
        
        %get Hamming distance between queries and database
        B1 = compactbit(H);
        B2 = compactbit(H_query);
        Dhamm = hammingDist(B2,B1);
        if plotResults == 1
            [score(:,i) recall(:,i)] = evaluation(WTT,Dhamm,1,'o-','color',colors(:,i));
        else
            [score(:,i) recall(:,i)] = evaluation(WTT,Dhamm);
        end
    end
    if run_lsh==1
        %LSH
        disp(sprintf('Running LSH with %d bits.',nb));
        %form random projections
        W = randn(size(X2,2),nb);
        %construct hash functions
        H_lsh = (Xtr2*W)>0;
        H_query_lsh = (Xtst2*W)>0;
        B1 = compactbit(H_lsh);
        B2 = compactbit(H_query_lsh);
        Dhamm = hammingDist(B2,B1);
        if plotResults == 1
            [score_lsh(:,i) recall_lsh(:,i)] = evaluation(WTT,Dhamm,3,'o-','color',colors(:,i));
        else
            [score_lsh(:,i) recall_lsh(:,i)] = evaluation(WTT,Dhamm);
        end
    end
end
if run_bre == 1
    scores{1} = score;
    recalls{1} = recall;
end
if run_lsh == 1
    scores_lsh{1} = score_lsh;
    recalls_lsh{1} = recall_lsh;
end
show_hashing_results
