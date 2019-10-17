% calculate the statistical property of SGD walk
function SGD_analysis_step_level(varargin)
% read in data
d = dir('*net*');
calculate = 1;

% Loop number for PBS array job
loop_num = 0;

for ii = 1:length(d)
    %GN_dir = dir(fullfile(d(ii).folder,d(ii).name,'*gradient_noise*mat'));
    sub_loss_w_dir = dir(fullfile(d(ii).folder,d(ii).name,'model*sub_loss_w.mat'));
    % For PBS array job
    loop_num = loop_num + 1;
    if nargin ~= 0
        PBS_ARRAYID = varargin{1};
        if loop_num ~=  PBS_ARRAYID
            continue;
        end
    end
    
    %     if isempty(GN_dir)
    %         warning([d(ii).name, ' is not completed!'])
    %         continue
    %     end
    if calculate
        part_num = 1;
        index = 1;
        for file = 1:length(sub_loss_w_dir)
            R = load(fullfile(d(ii).folder,d(ii).name,sprintf('model_%d_sub_loss_w.mat',file)));
            % organise the weights
            all_weights_tmp = cellfun(@(x) reshape(x,1,[]) ,R.sub_weights,'UniformOutput',false);
            all_sub_weights{index} = cell2mat(all_weights_tmp);
            all_sub_loss{index} = R.sub_loss;
            all_test_sub_loss{index} = R.test_sub_loss;
            % if the variable is too large, split it.
            attrib = whos('all_sub_weights');
            if attrib.bytes/1024^3 > 30
                calculate_MSD_trajectory(all_sub_weights, all_sub_loss, all_test_sub_loss, d(ii), sub_loss_w_dir, part_num)
                part_num = part_num + 1;
                clear all_sub_weights all_sub_loss all_test_sub_loss
                index = 1; % start again
            end
        end
        if exist('all_sub_weights','var')
            calculate_MSD_trajectory(all_sub_weights, all_sub_loss, all_test_sub_loss, d(ii), sub_loss_w_dir, part_num)
        end
    end
    datax_dir = dir('*data_part*');
    for part = 1:length(datax_dir)
        load(fullfile(sub_loss_w_dir.folder,[d(ii).name,'_data_part_',num2str(part),'.mat']),'loss','test_loss','delta_train_loss','delta_test_loss',...
            'MSD','Mean_contourlength','tau','MSD_forcontour','MSL_contourlength','contour_length','MSL_distance',...
            'distance','Displacement_all','Contour_length_all','f_loss','P1_loss','f_test_loss','P1_test_loss','tiny_step_num','epoch_selected_len','num_seg')
        % starting moment of square displacement
        t_start = [2.^(0:8),400];
        figure_width = 16;
        total_row = 2;
        total_column = 2;
        
        % [ verti_length, verti_dis, hori_dis ] = get_details_for_subaxis( total_row, total_column, hori_length, edge_multiplyer_h, inter_multiplyer_h, edge_multiplyer_v, inter_multiplyer_v )
        EMH = 0.2;
        EMV = 0.4;
        
        for epoch_seg = 1:length(tau)
            % displacement distribution
            dis_interval = 2.^(0:8);
            for jj = 1:length(dis_interval)
                eval(['displacement_',num2str(dis_interval(jj)),' = diag(Displacement_all{',num2str(epoch_seg),'},',num2str(dis_interval(jj)),');']);
            end
            
            [ figure_hight, SV, SH, MT, MB, ML, MR ] = get_details_for_subaxis( total_row, total_column, figure_width, EMH, 0.4, EMV, 0.4, 0.68, 0.5,5,4);
            % uniform FontSize and linewidth
            figure('NumberTitle','off','name', ['displacement_',num2str(epoch_seg)], 'units', 'centimeters', ...
                'color','w', 'position', [0, 0, figure_width, figure_hight], ...
                'PaperSize', [figure_width, figure_hight]); % this is the trick!
            
            subaxis(total_row,total_column,1,1,'SpacingHoriz',SH,...
                'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
            title('disp. distri.')
            hold on
            legend_txt = [];
            map = brewermap(length(dis_interval),'YlorRd');
            for jj = 1:length(dis_interval)
                eval(['[N,edges] = histcounts(displacement_',num2str(dis_interval(jj)),');']);
                plot(edges(1:end-1),N,'color',map(jj,:))
                legend_txt{end+1} = ['\tau=',num2str(dis_interval(jj))];
            end
            set(gca,'xscale','log','yscale','log')
            xlabel('Displacement')
            ylabel('Counts')
            legend(legend_txt)
            set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
            
            subaxis(total_row,total_column,2,1,'SpacingHoriz',SH,...
                'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
            title('D^2 distribution')
            
            hold on
            legend_txt = [];
            for jj = 1:length(dis_interval)
                eval(['[N,edges] = histcounts(displacement_',num2str(dis_interval(jj)),'.^2);']);
                plot(edges(1:end-1),N,'color',map(jj,:))
                legend_txt{end+1} = ['\tau=',num2str(dis_interval(jj))];
            end
            set(gca,'xscale','log','yscale','log')
            xlabel('Displacement^2')
            ylabel('Counts')
            legend(legend_txt)
            set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
            
            
            subaxis(total_row,total_column,1,2,'SpacingHoriz',SH,...
                'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
            hold on
            legend_txt = [];
            map = brewermap(length(t_start),'YlorRd');
            for jj = 1:length(t_start)
                plot(Displacement_all{epoch_seg}(t_start(jj),(1 + t_start(jj)):end),'color',map(jj,:))
                legend_txt{end+1} = ['t_w=',num2str(t_start(jj))];
            end
            set(gca,'xscale','log','yscale','log')
            xlabel('\tau')
            ylabel('$\Delta(t_w,t_w+\tau)$','interpreter','latex')
            legend(legend_txt)
            
            subaxis(total_row,total_column,2,2,'SpacingHoriz',SH,...
                'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
            hold on
            legend_txt = [];
            for jj = 1:length(t_start)
                plot(Contour_length_all{epoch_seg}(t_start(jj),:),Displacement_all{epoch_seg}(t_start(jj),:),'color',map(jj,:))
                legend_txt{end+1} = ['t_w=',num2str(t_start(jj))];
            end
            set(gca,'xscale','log','yscale','log')
            xlabel('Contour length')
            ylabel('$\Delta(t_w,t_w+\tau)$','interpreter','latex')
            legend(legend_txt)
            
            saveas(gcf,fullfile(sub_loss_w_dir.folder,['displacement_plot_',num2str(epoch_seg),'_',num2str(part),'.fig']))
        end
        
        % plot
        figure_width = 24;
        total_row = 3;
        total_column = 3;
        
        % [ verti_length, verti_dis, hori_dis ] = get_details_for_subaxis( total_row, total_column, hori_length, edge_multiplyer_h, inter_multiplyer_h, edge_multiplyer_v, inter_multiplyer_v )
        EMH = 0.2;
        EMV = 0.4;
        [ figure_hight, SV, SH, MT, MB, ML, MR ] = get_details_for_subaxis( total_row, total_column, figure_width, EMH, 0.4, EMV, 0.4, 0.68, 0.5,5,4);
        % uniform FontSize and linewidth
        figure('NumberTitle','off','name', 'trapping', 'units', 'centimeters', ...
            'color','w', 'position', [0, 0, figure_width, figure_hight], ...
            'PaperSize', [figure_width, figure_hight]); % this is the trick!
        
        subaxis(total_row,total_column,1,1,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        title('MSD')
        hold on
        map = brewermap(length(tau),'YlorRd');
        for k=1:length(tau)
            loglog(tau{k},MSD{k},'color',map(k,:))
            legend_string{k} = ['epoch:',num2str(1 + (k-1)*epoch_selected_len)];
        end
        legend(legend_string)
        xlabel('\tau')
        ylabel('{\Delta}r^2(\tau)')
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        
        subaxis(total_row,total_column,2,1,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        title('Loss changes')
        %     yyaxis left
        plot(1:length(delta_train_loss),abs(delta_train_loss))
        xlabel('Time (step)')
        ylabel('{\Delta}Train Loss')
        %legend({'train loss','test loss'})
        %     yyaxis right
        %     plot(1:length(delta_test_loss),abs(delta_test_loss))
        %     ylabel('{\Delta}Test Loss')
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        subaxis(total_row,total_column,3,1,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        title('{\Delta}Loss distribution')
        [N,edges] = histcounts(delta_train_loss);
        plot(edges(1:end-1),N,'ko-')
        hold on
        [N,edges] = histcounts(delta_test_loss);
        plot(edges(1:end-1),N,'ro-')
        %     set(gca,'xscale','log','yscale','log')
        xlabel('{\Delta}Loss')
        ylabel('Counts')
        legend({'train loss','test loss'})
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        subaxis(total_row,total_column,1,2,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        plot(loss)
        xlabel('Step')
        ylabel('Loss')
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        subaxis(total_row,total_column,2,2,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        loglog(f_loss,P1_loss)
        xlabel('Frequency (step^{-1})')
        ylabel('Loss spectrum')
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        subaxis(total_row,total_column,3,2,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        hold on
        map = brewermap(length(contour_length),'YlorRd');
        for k=1:length(tau)
            loglog(contour_length{k},MSD_forcontour{k},'color',map)
            legend_string{k} = ['epoch:',num2str(1 + (k-1)*epoch_selected_len)];
        end
        legend(legend_string)
        xlabel('Contour length')
        ylabel('{\Delta}r^2(\tau)')
        %     hold on
        %     P = polyfit(log(contour_length(contour_length<894)),log(MSD_forcontour(contour_length<894)),1);
        %     x_fit = logspace(log(min(contour_length)),log(894),20);
        %     y_fit = P(1)*x_fit + P(2);
        %     plot(x_fit,y_fit,'r:')
        %     title(['Slop:',num2str(P(1))])
        %     axis([min(contour_length),max(contour_length),min(MSD_forcontour),max(MSD_forcontour)])
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        subaxis(total_row,total_column,1,3,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        hold on
        map = brewermap(length(tau),'YlorRd');
        for k=1:length(tau)
            loglog(tau{k},Mean_contourlength{k},'color',map)
            legend_string{k} = ['epoch:',num2str(1 + (k-1)*epoch_selected_len)];
        end
        legend(legend_string)
        xlabel('\tau')
        ylabel('Contour length')
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        
        subaxis(total_row,total_column,2,3,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        hold on
        map = brewermap(length(tau),'YlorRd');
        for k=1:length(tau)
            % coarse grain for visualization
            [distance_coarse,MSL_coarse] = coarse_grain(distance{k},MSL_distance{k},50);
            plot(distance_coarse,MSL_coarse,'.-','color',map)
            legend_string{k} = ['epoch:',num2str(1 + (k-1)*epoch_selected_len)];
        end
        legend(legend_string)
        xlabel('Distance')
        ylabel('Mean squared loss')
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        subaxis(total_row,total_column,3,3,'SpacingHoriz',SH,...
            'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
        hold on
        map = brewermap(length(tau),'YlorRd');
        for k=1:length(tau)
            % coarse grain for visualization
            [distance_coarse,MSL_coarse] = coarse_grain(contour_length{k},MSL_contourlength{k},50);
            plot(distance_coarse,MSL_coarse,'.-','color',map)
            legend_string{k} = ['epoch:',num2str(1 + (k-1)*epoch_selected_len)];
        end
        legend(legend_string)
        xlabel('Contour length')
        ylabel('Mean squared loss')
        set(gca,'linewidth',1,'fontsize',12,'tickdir','out')
        
        
        saveas(gcf,fullfile(sub_loss_w_dir.folder,[d(ii).name,'_plot_',num2str(part),'.fig']))
        %saveas(gcf,fullfile(sub_loss_w_dir.folder,[d(ii).name,'_plot.svg']))
    end
    
end
end



function calculate_MSD_trajectory(all_sub_weights, all_sub_loss, all_test_sub_loss, d, GN_dir, part_num)
fprintf('Calculating part: %d',part_num)
% contour length related and MSD
tiny_step_num = size(all_sub_loss{1},2);
% find a proper length of epoch and combine sub_weights to calculate MSD
epoch_selected_len = min(length(all_sub_loss),round(1e4/tiny_step_num));
num_seg = max(1,floor(length(all_sub_weights)/epoch_selected_len));
MSD_feed = cell(num_seg,1);
t = 1:(tiny_step_num*epoch_selected_len);
for k = 1:num_seg
    MSD_feed{k} = [cell2mat(cat(1,all_sub_weights(((k-1)*epoch_selected_len + 1):(k*epoch_selected_len)))),t',reshape(cell2mat(cat(1,all_sub_loss(((k-1)*epoch_selected_len + 1):(k*epoch_selected_len)))),[],1)];
end

% pca trajectory
plot_trajectory_in_one_epoch(cell2mat(cat(1,all_sub_weights)),fullfile(d.folder,d.name),part_num)

% calculate MSD
feed_paral = distributed(MSD_feed);
save(fullfile(GN_dir.folder,[d.name,'_data_part_',num2str(part_num),'.mat']),'MSD_feed','-v7.3')
clear MSD_feed
[MSD,Mean_contourlength,tau,MSD_forcontour,MSL_contourlength,contour_length,MSL_distance,distance,Displacement_all,Contour_length_all] = cellfun(@get_contour_lenth_MSD_loss,feed_paral,'UniformOutput',false);
clear feed_paral
MSD = gather(MSD);
Mean_contourlength = gather(Mean_contourlength);
tau = gather(tau);
MSD_forcontour = gather(MSD_forcontour);
MSL_contourlength = gather(MSL_contourlength);
contour_length = gather(contour_length);
MSL_distance = gather(MSL_distance);
distance = gather(distance);
Displacement_all = gather(Displacement_all);
Contour_length_all = gather(Contour_length_all);
disp('MSD and contour: done!')

% loss dynamics
loss = cell2mat(all_sub_loss);
loss = reshape(loss',[],1);
test_loss = cell2mat(all_test_sub_loss);
test_loss = reshape(test_loss',[],1);
% get the step difference of training loss
delta_train_loss = diff(loss);
% get the step difference of test loss
delta_test_loss = diff(test_loss);
% FFT
[f_loss,P1_loss,~] = get_fft_new(loss,1,'original');
[f_test_loss,P1_test_loss,~] = get_fft_new(test_loss,1,'original');

%save
save(fullfile(sub_loss_w_dir.folder,[d.name,'_data_part_',num2str(part_num),'.mat']),'loss','test_loss','delta_train_loss','delta_test_loss',...
    'MSD','Mean_contourlength','tau','MSD_forcontour','MSL_contourlength','contour_length','MSL_distance',...
    'distance','Displacement_all','Contour_length_all','f_loss','P1_loss','f_test_loss','P1_test_loss','tiny_step_num','epoch_selected_len','num_seg','-append')
end

function [distance_coarse,MSL_coarse] = coarse_grain(distance,MSL,coarse_num)
% coarse grain for visualization
Dis_coarse = linspace(min(distance),max(distance),coarse_num+1);
for interval = 1:coarse_num
    MSL_coarse(interval) = mean(MSL((distance >= Dis_coarse(interval)) & (distance < Dis_coarse(interval+1))));
end
distance_coarse = movmean(Dis_coarse,2);
distance_coarse = distance_coarse(2:end);
end