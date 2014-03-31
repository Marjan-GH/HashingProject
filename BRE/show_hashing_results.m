%simple script to display hashing results

hammd = 4;
%x = [10 15 20 25 30 35 40 45 50];
x = [10 15 20 25 30];

ms = 5;
lw = 3;
for i = 1:length(scores)
    figure(i); clf;
    plot(x,scores{i}(hammd,:),'r--','LineWidth',lw,'MarkerSize',ms);
    hold
    plot(x,scores_lsh{i}(hammd,:),'g-o','LineWidth',lw,'MarkerSize',ms);
    h_xl = xlabel('Number of bits');
    h_yl = ylabel(sprintf('Prop. of good neighbors with Hamm. distance <= %d', hammd-1));
    h_leg = legend('BRE','LSH');
    set(h_xl,'FontSize',14);
    set(h_yl,'FontSize',14);
    set(h_leg,'FontSize',14);
end
