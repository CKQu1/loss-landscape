% detect barrier cross
d = dir('train_loss*.mat');
for ii = 1:length(d)
    load(d(ii).name)
    real_value = loss_interp(1:10:length(loss_interp));
    M_real = movmax(real_value,[0,1],'endpoints','discard');    
    M = movmax(loss_interp,[0,10],'endpoints','discard');%max in 11 values
    M_inter = M(1:10:length(M));
    cross_flag(:,ii) = M_inter > M_real;
end