% plot figures of Proj3
clear
close all
%% load data
d = dir('/import/headnode1/gche4213/Project3/*net*');
ii = 2;
datax_dir = dir(fullfile(d(ii).folder,d(ii).name,'*data_part*'));
Lecun = load(fullfile(datax_dir(1).folder,'MSD_lecun.mat'));
loss_all = [];
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
%% plot
figure_width = 20;
total_row = 1;
total_column = 4;
% uniform FontSize and linewidth
fontsize = 10;
linewidth = 1;
ylabel_shift = -0.25;
xlabel_shift = -0.18;
% [ verti_length, verti_dis, hori_dis ] = get_details_for_subaxis( total_row, total_column, hori_length, edge_multiplyer_h, inter_multiplyer_h, edge_multiplyer_v, inter_multiplyer_v )
EMH = 0.1;
EMV = 0.5;
MLR = 1;
MBR = 1;
[ figure_hight, SV, SH, MT, MB, ML, MR ] = get_details_for_subaxis(total_row, total_column, figure_width, EMH, 0.4, EMV, 0.3, MLR, MBR );

figure('NumberTitle','off','name', 'trapping', 'units', 'centimeters', ...
    'color','w', 'position', [0, 0, figure_width, figure_hight], ...
    'PaperSize', [figure_width, figure_hight]); % this is the trick!
%MSL vs distance
subaxis(total_row,total_column,1,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
select_num = 24;
map = jet(select_num);
hold on
for k=1:select_num%length(tau)
    % coarse grain for visualization
    [distance_coarse,MSL_coarse] = coarse_grain(distance{k},MSL_distance{k},50);
    plot(distance_coarse,MSL_coarse,'.-','color',map(k,:))
end
xlim([0.1,10])
x = xlabel('{\Delta}r');
set(x, 'Units', 'Normalized', 'Position', [0.5,xlabel_shift, 0]);
y = ylabel('Mean squared loss');
set(y, 'Units', 'Normalized', 'Position', [ylabel_shift, 0.5, 0]);
text(-0.2,1.15,'a','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log','xtick',[0.1,1,10])
% colorbar
originalSize = get(gca, 'Position');
caxis([1,1 + (select_num-1)*1e3])
colormap('jet')
c = colorbar('Position', [originalSize(1)+originalSize(3)+0.005, originalSize(2), 0.007, originalSize(4)-0.02],'location','east');
T = title(c,'t_w (step)','fontsize',fontsize);
% set(T,'Units', 'Normalized', 'Position', [0.5,0.1, 0]);
set(gca, 'Position', originalSize);

%MSL vs contour length
subaxis(total_row,total_column,3,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
select_num = 24;
map = jet(select_num);
hold on
for k=1:select_num%length(tau)
    % coarse grain for visualization
    [distance_coarse,MSL_coarse] = coarse_grain(contour_length{k},MSL_contourlength{k},50);
    plot(distance_coarse,MSL_coarse,'.-','color',map(k,:))
end
x = xlabel('Contour length');
set(x, 'Units', 'Normalized', 'Position', [0.5,xlabel_shift, 0]);
% y = ylabel('Mean squared loss');
% set(y, 'Units', 'Normalized', 'Position', [ylabel_shift, 0.5, 0]);
text(-0.2,1.15,'b','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log')

% leave space for schematic diagram of contour length
subaxis(total_row,total_column,2,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
text(-0.2,1.15,'c','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')


% contour length vs MSD
cc = subaxis(total_row,total_column,4,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
hold on
select_num = 24;
map = jet(select_num);
for k=2:select_num%length(tau)
    loglog(contour_length{k},smoothdata(MSD_forcontour{k},'movmean',[40,400]),'color',map(k,:),'linewidth',linewidth)
end
x = xlabel('Contour length');
set(x, 'Units', 'Normalized', 'Position', [0.5,xlabel_shift, 0]);
y = ylabel('{\Delta}r^2');
set(y, 'Units', 'Normalized', 'Position', [ylabel_shift, 0.5, 0]);
axis([0.08 200 8e-3 100])
text(-0.2,1.15,'d','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log','xtick',[0.1,1,10,100])

% % colorbar
% originalSize = get(gca, 'Position');
% caxis([1,1 + (select_num-1)*1e3])
% colormap(cc,'jet')
% c = colorbar('Position', [originalSize(1) + originalSize(3) + 0.02  originalSize(2)  0.015 originalSize(4)],'location','east');
% T = title(c,'t_w (step)','fontsize',fontsize);
% % set(T,'Units', 'Normalized', 'Position', [0,0.5, 5]);
% set(gca, 'Position', originalSize);

% a single contour length vs MSD curve
insect = axes('position',[0.817460317460317 0.558596971434323 0.0806878306878308 0.333155605885265]);
axis(insect)
k = 2;
plot(contour_length{k},MSD_forcontour{k},'color',map(k,:),'linestyle','none','marker','.')
hold on
plot(contour_length{k},smoothdata(MSD_forcontour{k},'movmean',[40,400]),'r:','linewidth',linewidth)
axis([0.08 200 8e-3 100])
legend({'Raw','Smo.'},'location','northwest')
legend boxoff
% x = xlabel('Contour length');
% set(x, 'Units', 'Normalized', 'Position', [0.5, -0.1, 0]);
% y = ylabel('{\Delta}r^2');
% set(y, 'Units', 'Normalized', 'Position', [-0.22, 0.5, 0]);
set(gca,'xscale','log','yscale','log','xtick',[],'ytick',[])



set(gcf, 'PaperPositionMode', 'auto');

% output
print('-painters' ,'/import/headnode1/gche4213/Project3/outputfigures/fractal_landscape_path2.svg','-dsvg','-r300')
function [distance_coarse,MSL_coarse] = coarse_grain(distance,MSL,coarse_num)
% coarse grain for visualization
Dis_coarse = linspace(min(distance),max(distance),coarse_num+1);
for interval = 1:coarse_num
    MSL_coarse(interval) = mean(MSL((distance >= Dis_coarse(interval)) & (distance < Dis_coarse(interval+1))));
end
distance_coarse = movmean(Dis_coarse,2);
distance_coarse = distance_coarse(2:end);
end