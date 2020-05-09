clear
close all
figure_width = 16;
total_row = 2;
total_column = 2;
% uniform FontSize and linewidth
fontsize = 10;
linewidth = 1.5;
% [ verti_length, verti_dis, hori_dis ] = get_details_for_subaxis( total_row, total_column, hori_length, edge_multiplyer_h, inter_multiplyer_h, edge_multiplyer_v, inter_multiplyer_v )
EMH = 0.1;
EMV = 0.4;
MLR = 0.65;
MBR = 0.9;
[ figure_hight, SV, SH, MT, MB, ML, MR ] = get_details_for_subaxis(total_row, total_column, figure_width, EMH, 0.5, EMV, 0.3, MLR, MBR );

figure('NumberTitle','off','name', 'trapping', 'units', 'centimeters', ...
    'color','w', 'position', [0, 0, figure_width, figure_hight], ...
    'PaperSize', [figure_width, figure_hight]); % this is the trick!    
% toy model trajectory and landscape
cc = subaxis(total_row,total_column,1,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
load('/import/headnode1/gche4213/Project3/test_toy/test_toy_fractal.mat','X','Y','land_ind')
spatial_epson = 1e-3;
L = load('/import/headnode1/gche4213/Project3/post_analysis/bigger_fractal_landscape.mat');
x = L.x;
y = L.y;
zz = L.zz;
rd = 2;%277;
z = zz{land_ind(rd)};
bb=find(Y{rd}>-0.3385,1);
bb = bb + 200;
landscape_F = griddedInterpolant((repmat(x',1,length(y))-1)*2-1,(repmat(y,length(x),1)-1)*2-1,z,'linear');% may changet to nonlinear interpolation
look_up_table = -1:spatial_epson:1;
[xq, yq] = ndgrid(look_up_table);
landscape = 10-landscape_F(xq, yq);

hold on
contour(look_up_table,look_up_table,landscape)
Traj = plot(X{rd}(bb:end),Y{rd}(bb:end),'k-');
start = plot(X{rd}(bb),Y{rd}(bb),'rx');
end_point = plot(X{rd}(end),Y{rd}(end),'ro');
legend([Traj,start,end_point],{'Traj.','Start','End'})
xlabel('X')
ylabel('Y')
% colorbar
originalSize = get(gca, 'Position');
% caxis([])
colormap(cc,'default')
c = colorbar('Position', [originalSize(1)  originalSize(2)-0.058  originalSize(3) 0.015],'location','south');
T = title(c,'Altitude','fontsize',fontsize);
set(T,'Units', 'Normalized', 'Position', [0.5,-2.6, 0]);
set(gca, 'Position', originalSize);
text(-0.18,1.1,'a','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out')

% space for schematic of averaing effect
subaxis(total_row,total_column,1,2,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
text(-0.18,1.1,'b','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')

% % MSD of toy model calculating from the whole path
% subaxis(total_row,total_column,1,3,'SpacingHoriz',SH,...
%     'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
% % subaxis(total_row,total_column,2,3,'SpacingHoriz',SH,...
% %     'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
% % h = axes('Position',[0.611164462809917 0.231930526462786 0.366032210834553 0.0793650793650791],...
% %     'Tag','subaxis');
% % set(h,'box','on');
% %h=axes('position',[x1 1-y2 x2-x1 y2-y1]);
% % set(h,'units',get(gcf,'defaultaxesunits'));
t = (1:1000+1)';
% [MSD_total,tau_total] = get_MSD([X{rd}(bb:end),Y{rd}(bb:end),t(bb:end)]);
% loglog(tau_total,MSD_total,'k','linewidth',linewidth)
% ylabel('{\Delta}r^2(\tau)')
% xlabel('\tau (step)')
% text(-0.18,1.1,'c','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
% set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log')%,'ytick',[1e-2,1])

% MSD in the initial phase
subaxis(total_row,total_column,2,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
% h=axes('position',[0.611164462809917 0.154139784946237 0.366032210834553 0.0793650793650792]);
% set(h,'box','on');
%h=axes('position',[x1 1-y2 x2-x1 y2-y1]);
% set(h,'units',get(gcf,'defaultaxesunits'));
% set(h,'tag','subaxis');
% aa=find(X{rd}<-0.3284,1);
aa=find(Y{rd}>0.2,1);

[MSD_initial,tau_initial] = get_MSD([X{rd}(bb:aa),Y{rd}(bb:aa),t(bb:aa)]);
loglog(tau_initial,MSD_initial,'k','linewidth',linewidth)
ylabel('{\Delta}r^2(\tau)')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log')%,'ytick',[1e-2,1])
text(-0.18,1.1,'c','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')

% MSD in the final phase
subaxis(total_row,total_column,2,2,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
% h=axes('position',[0.611164462809917 0.0767204301075268 0.366032210834553 0.0793650793650793]);
% set(h,'box','on');
% set(h,'units',get(gcf,'defaultaxesunits'));
% set(h,'tag','subaxis');
[MSD_end,tau_end] = get_MSD([X{rd}(aa:end),Y{rd}(aa:end),t(aa:end)]);
loglog(tau_end,MSD_end,'k','linewidth',linewidth)
xlabel('\tau (step)')
ylabel('{\Delta}r^2(\tau)')
% xlim([1 600])
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log')%,'ytick',[1e-2,1e-1])
text(-0.18,1.1,'d','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')

set(gcf, 'PaperPositionMode', 'auto');

% output
% print('-painters' ,'/import/headnode1/gche4213/Project3/outputfigures/toy_model.svg','-dsvg','-r300')
