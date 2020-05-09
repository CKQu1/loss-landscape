% plot figures of Proj3
clear
close all
%% load data
d = dir('/import/headnode1/gche4213/Project3/*net*');
ii = 2;

datax_dir = dir(fullfile(d(ii).folder,d(ii).name,'*data_part*'));

for part = 1:length(datax_dir)-1
    try
        L = load(fullfile(datax_dir(1).folder,[d(ii).name(1:end-24),'_data_part_',num2str(part),'.mat']),'loss','test_loss','delta_train_loss','delta_test_loss',...
            'MSD','Mean_contourlength','tau','MSD_forcontour','MSL_contourlength','contour_length','MSL_distance',...
            'distance','Displacement_all','Contour_length_all','f_loss','P1_loss','f_test_loss','P1_test_loss');
        
        loss{part} = L.loss;
        test_loss{part} = L.test_loss;
        delta_train_loss{part} = L.delta_train_loss;
        delta_test_loss{part} = L.delta_test_loss;
        MSD{part} = L.MSD;
        Mean_contourlength{part} = L.Mean_contourlength;
        tau{part} = L.tau;
        MSD_forcontour{part} = L.MSD_forcontour;
        MSL_contourlength{part} = L.MSL_contourlength;
        contour_length{part} = L.contour_length;
        MSL_distance{part} = L.MSL_distance;
        distance{part} = L.distance;
        Displacement_all{part} = L.Displacement_all;
        Contour_length_all{part} = L.Contour_length_all;
        f_loss{part} = L.f_loss;
        P1_loss{part} = L.P1_loss;
        f_test_loss{part} = L.f_test_loss;
        P1_test_loss{part} = L.P1_test_loss;
    catch
        loss{part} = nan;
        test_loss{part} = nan;
        delta_train_loss{part} = nan;
        delta_test_loss{part} = nan;
        MSD{part} = nan;
        Mean_contourlength{part} = nan;
        tau{part} = nan;
        MSD_forcontour{part} = nan;
        MSL_contourlength{part} = nan;
        contour_length{part} = nan;
        MSL_distance{part} = nan;
        distance{part} = nan;
        Displacement_all{part} = nan;
        Contour_length_all{part} = nan;
        f_loss{part} = nan;
        P1_loss{part} = nan;
        f_test_loss{part} = nan;
        P1_test_loss{part} = nan;
    end
end
%% plot superdiffusion
figure_width = 16;
total_row = 3;
total_column = 2;
% uniform FontSize and linewidth
fontsize = 10;
linewidth = 1.5;
% [ verti_length, verti_dis, hori_dis ] = get_details_for_subaxis( total_row, total_column, hori_length, edge_multiplyer_h, inter_multiplyer_h, edge_multiplyer_v, inter_multiplyer_v )
EMH = 0.15;
EMV = 0.2;
[ figure_hight, SV, SH, MT, MB, ML, MR ] = get_details_for_subaxis( total_row, total_column, figure_width, EMH, 0.4, EMV, 0.4, 0.68, 0.8);

figure('NumberTitle','off','name', 'trapping', 'units', 'centimeters', ...
    'color','w', 'position', [0, 0, figure_width, figure_hight], ...
    'PaperSize', [figure_width, figure_hight]); % this is the trick!
%MSD
cc = subaxis(total_row,total_column,1,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
hold on
select_num = 24;
map = jet(select_num);
for k=1:select_num%length(tau)
    loglog(tau{k},MSD{k},'color',map(k,:),'linewidth',linewidth)
end
axis([1,1e3,1e-2,1e2])
% xlabel('\tau')
ylabel('{\Delta}r^2(\tau)')
text(-0.18,1.1,'a','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log','xtick',[1,10,100,1000])
% colorbar
originalSize = get(gca, 'Position');
caxis([1,1 + (select_num-1)*1e3])
colormap(cc,'jet')
c = colorbar('Position', [originalSize(1)  originalSize(2)-0.05  originalSize(3) 0.015],'location','south');
T = title(c,'t_w (step)','fontsize',fontsize);
set(T,'Units', 'Normalized', 'Position', [0.5,-3, 0]);
set(gca, 'Position', originalSize);

% a single MSD curve
insect = axes('position',[0.0971900826446281 0.878378456221198 0.15625 0.101636904761905]);
axis(insect);box on;
hold on
for k = [1,round(select_num/3),select_num]
    loglog(tau{k},MSD{k},'color',map(k,:),'linewidth',linewidth)
end
axis([1,1e3,1e-2,1e2])
% x = xlabel('\tau');
% set(x, 'Units', 'Normalized', 'Position', [0.5, -0.1, 0]);
% y = ylabel('{\Delta}r^2(\tau)');
% set(y, 'Units', 'Normalized', 'Position', [-0.22, 0.5, 0]);
set(gca,'xscale','log','yscale','log','xtick',[],'ytick',[]) 

% dynamical exponent
subaxis(total_row,total_column,1,2,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
hold on
for k=1:select_num%length(tau)
    FY = (log(MSD{k}(1:end-20)) - log(MSD{k}(21:end)))./(log(tau{k}(1:end-20)) - log(tau{k}(21:end)));
    plot(tau{k}(1:end-20),FY,'color',map(k,:),'linewidth',linewidth)
end
axis([1,1e3,0.5,2.5])
xlabel('\tau (step)')
ylabel('\beta(\tau)')
text(-0.18,1.1,'b','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','linear','xtick',[1,10,100,1000])
% one dynamical exponent
insect = axes('position',[0.097190082644628 0.545565668202765 0.15625 0.101636904761905]);
axis(insect);box on;
hold on
for k = [1,round(select_num/3),select_num]
    FY = (log(MSD{k}(1:end-20)) - log(MSD{k}(21:end)))./(log(tau{k}(1:end-20)) - log(tau{k}(21:end)));
    plot(tau{k}(1:end-20),FY,'color',map(k,:),'linewidth',linewidth)
end
axis([1,1e3,0.5,2.5])
% x = xlabel('\tau');
% set(x, 'Units', 'Normalized', 'Position', [0.5, -0.1, 0]);
% y = ylabel('\beta(\tau)');
% set(y, 'Units', 'Normalized', 'Position', [-0.22, 0.5, 0]);
set(gca,'xscale','log','yscale','linear','xtick',[],'ytick',[])

% displacement distribution
subaxis(total_row,total_column,1,3,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
dis_interval = 2.^(0:8);
for jj = 1:length(dis_interval)
    eval(['displacement_',num2str(dis_interval(jj)),' = [];']);
end
% for distribution
for epoch_seg = 1:length(tau)
    for jj = 1:length(dis_interval)
        %eval(['displacement_',num2str(dis_interval(jj)),' = diag(Displacement_all{',num2str(epoch_seg),'},',num2str(dis_interval(jj)),');']);
        try
            eval(['displacement_',num2str(dis_interval(jj)),' = [displacement_',num2str(dis_interval(jj)),';diag(Displacement_all{',num2str(epoch_seg),'},',num2str(dis_interval(jj)),')];']);
        catch
        end
    end
end

hold on
map = jet(length(dis_interval));
for jj = 1:length(dis_interval)
    eval(['all_disp = displacement_',num2str(dis_interval(jj)),';'])
    all_disp = all_disp.^0.5;
    log_space_min = log10(min(all_disp));
    if isinf(log_space_min)
        temp = unique(all_disp);
        log_space_min = log10(temp(2));
    end
    [N,edges] = histcounts(all_disp,logspace(log_space_min,log10(max(all_disp)),51),'Normalization','probability');
    plot(edges(1:end-1),N,'.-','color',map(jj,:))
end
for jj = 1:length(dis_interval)
    legend_string{jj} = ['\tau = ',num2str(dis_interval(jj))];
end
legend(legend_string,'Position',[0.564450907378345 0.827927262638418 0.160330576246435 0.153763436534071])
legend boxoff
xlabel('{\Delta}r')
ylabel('PDF')
text(-0.18,1.1,'c','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
% colorbar
% originalSize = get(gca, 'Position');
% caxis([dis_interval(1),dis_interval(end)])
% colormap('jet')
% c = colorbar('Position', [originalSize(1)  originalSize(2)-0.05  originalSize(3) 0.015],'location','south');
% T = title(c,'\tau (step)','fontsize',fontsize);
% set(T,'Units', 'Normalized', 'Position', [0.5,-3, 0]);
% set(gca, 'Position', originalSize);

set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log')

% autocorrelation of velocity
load('/import/headnode1/gche4213/Project3/velocity_acc.mat')
subaxis(total_row,total_column,2,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
net_index = 1;
interval_index = 1;
loglog(lag_all{net_index}{interval_index},correlation_all{net_index}{interval_index},'ko')
hold on
% plot(,'r:')
xlabel('Time lag (step)')
ylabel('Velocity autocorr.')
text(-0.18,1.1,'d','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log')

% long MSD
subaxis(total_row,total_column,2,2,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
d_long = dir('/import/headnode1/gche4213/Project3/other/resnet14_512/_*mat');
hold on
select_num = 5;
map = jet(select_num);
for k=1:select_num%length(tau)
    load(fullfile(d_long(k).folder,d_long(k).name),'MSD','tau')
    loglog(tau,MSD,'color',map(k,:),'linewidth',linewidth)
end
axis([1,1e4,1e-2,6e2])
xlabel('\tau')
ylabel('{\Delta}r^2(\tau)')
text(-0.18,1.1,'e','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log','xtick',[1,10,100,1000,1e4])
legend({'t_w=1 step','t_w=10001 steps','t_w=20001 steps','t_w=30001 steps','t_w=40001 steps'})
legend boxoff
set(gcf, 'PaperPositionMode', 'auto');

% output
% print( '-painters' ,'/import/headnode1/gche4213/Project3/outputfigures/superdiffusion2.jpg','-djpeg','-r300')
% print('-painters' ,'/import/headnode1/gche4213/Project3/outputfigures/superdiffusion2.svg','-dsvg','-r300')

