% check how the walker got out from local minima
%% basic param
clear
close all

spatial_epson = 1e-3;
%learning rate
eta = 0.004;%x5
% noise portion
eta2 = 0.002;%x5
n = 10000; %number of samples
num_rd = 5;
% load data
load('/import/headnode1/gche4213/Project3/test_toy/test_toy_fractal.mat')
rd = 77;
% load fractal landscape
L = load('/import/headnode1/gche4213/Project3/post_analysis/bigger_fractal_landscape.mat');
x = L.x;
y = L.y;
zz = L.zz;
land_ind(rd) = randperm(length(zz),1);
z = zz{land_ind(rd)};
landscape_F = griddedInterpolant((repmat(x',1,length(y))-1)*2-1,(repmat(y,length(x),1)-1)*2-1,z,'linear');% may changet to nonlinear interpolation
look_up_table = -1:spatial_epson:1;
[xq, yq] = ndgrid(look_up_table);
landscape = 10-landscape_F(xq, yq);


%% plot
figure
hold on
imagesc(look_up_table,look_up_table,landscape)
% step = 1;
% color_map = jet(round(length(X)/2+1));
% for ii=1:step:(length(X)/2+1)
%     plot(X(ii),Y(ii),'.','color',color_map(ii,:))
% end
plot(X{rd},Y{rd},'k-','marker','.')
plot(X{rd}(end),Y{rd}(end),'ro')
plot(X{rd}(1),Y{rd}(1),'rx')
xlabel('X')
ylabel('Y')


%% manully output the detail
% zoom in
axis([-inf inf -inf inf])

[x_lim,y_lim] = ginput(2);
axis([sort(x_lim(:));sort(y_lim(:))])


while input('pick another point?')
    [x_sample,y_sample] = ginput(1);
    plot(x_sample,y_sample,'ro')
    
    [~,ind_sample] = min(abs(Y{rd} - y_sample) + abs(X{rd} - x_sample));
    
    plot(X{rd}(ind_sample),Y{rd}(ind_sample),'rx')
    plot(X{rd}(ind_sample-1),Y{rd}(ind_sample-1),'r^')
    plot(X{rd}(ind_sample+1),Y{rd}(ind_sample+1),'rv')
    
    G_previous_x = -gradient_x{rd}(ind_sample-1)*eta;
    G_previous_y = -gradient_y{rd}(ind_sample-1)*eta;
    
    G_current_x = -gradient_x{rd}(ind_sample)*eta;
    G_current_y = -gradient_y{rd}(ind_sample)*eta;
    
    % G_next_x = gradient_x{rd}(ind_sample+1)*eta
    % G_next_y = gradient_y{rd}(ind_sample+1)*eta
    
    step_size_x_pre = X{rd}(ind_sample) - X{rd}(ind_sample-1);
    step_size_y_pre = X{rd}(ind_sample+1) - X{rd}(ind_sample);
    
    step_size_x_next = Y{rd}(ind_sample) - Y{rd}(ind_sample-1);
    step_size_y_next = Y{rd}(ind_sample+1) - Y{rd}(ind_sample);
    disp('&&&&&')
    G_proportion_x_pre = G_previous_x/step_size_x_pre
    G_proportion_y_pre = G_previous_y/step_size_y_pre
    
    G_proportion_x_next = G_current_x/step_size_x_next
    G_proportion_y_next = G_current_y/step_size_y_next
end

%% auto find the gradient contribution, need specify the segment where it jumps out (!!!not done!!!)
% close all
% for ii = 1:length(X{rd})-1
% x_ind = find(look_up_table > X{rd}(ii),1);
% y_ind = find(look_up_table > Y{rd}(ii),1);
% Traj(:,ii) = [X{rd}(ii), Y{rd}(ii), landscape(y_ind, x_ind), gradient_x{rd}, gradient_y{rd}];
% end
% 
% % get changes
% changes = diff(Traj(1:2,:),1,2);
% 
% % get the noise; x_new = x_old  - drift_x_tmp*eta + eta2*g;
% noise = (changes + Traj(4:5,1:end-1).*eta)./eta2;
% 
% % get proportion o contribution
% contribution = -Traj(4:5,1:end-1).*eta./changes;
% figure
% histogram(contribution(:))
% xlabel('Gradient contribution/step size')
% ylabel('Counts')
% title(num2str(mean(contribution(:))))
% % xlim([-1,1])
% % noise contribution
% contri_noise = noise.*eta2./changes;
% figure
% histogram(contri_noise(:))
% xlabel('noise contribution/step size')
% ylabel('Counts')
% title(num2str(mean(contri_noise(:))))
% % xlim([-1,1])
% 
% % find the down movement and get distribution
% down_pool = contribution(:,diff(Traj(3,:)) < 0);
% figure
% histogram(down_pool)
% xlabel('down Gradient contribution/step size')
% ylabel('Counts')
% title(num2str(mean(down_pool(:))))
% % xlim([-1,1])
% 
% 
% % find the up movement and get distribution
% up_pool = contribution(:,diff(Traj(3,:)) > 0);
% figure
% histogram(up_pool)
% xlabel('up Gradient contribution/step size')
% ylabel('Counts')
% title(num2str(mean(up_pool(:))))
% % xlim([-1,1])
% 
% 
%         
