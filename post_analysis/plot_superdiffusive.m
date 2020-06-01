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
figure_width = 20;
total_row = 2;
total_column = 3;
% uniform FontSize and linewidth
fontsize = 10;
linewidth = 0.7;
ylable_shift = -0.2;
xlable_shift = -0.15;
TickLength = 0.03;
% [ verti_length, verti_dis, hori_dis ] = get_details_for_subaxis( total_row, total_column, hori_length, edge_multiplyer_h, inter_multiplyer_h, edge_multiplyer_v, inter_multiplyer_v )
EMH = 0.1;
EMV = 0.4;
MLR = 0.65;
MBR = 0.8;

[ figure_hight, SV, SH, MT,MB,ML,MR ] = get_details_for_subaxis(total_row, total_column, figure_width, EMH, 0.5, EMV, 0.6,MLR,MBR);
figure('NumberTitle','off','name', 'Reproduction', 'units', 'centimeters', ...
    'color','w', 'position', [0, 0, figure_width, figure_hight], ...
    'PaperSize', [figure_width, figure_hight]); % this is the trick!

%MSD
cc = subaxis(total_row,total_column,1,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
hold on
select_num = 24;
map = jet(select_num);
for k = [1,round(select_num/5),round(select_num*2/5),round(select_num*3/5),round(select_num*4/5),select_num]
    loglog(tau{k},MSD{k},'color',map(k,:),'linewidth',linewidth)
end
axis([1,1e3,1e-2,1e2])
xlabel('\tau (step)')
y = ylabel('{\Delta}r^2(\tau)');
set(y, 'Units', 'Normalized', 'Position', [ylable_shift, 0.5, 0]);
text(-0.18,1.15,'a','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','xscale','log','yscale','log','xtick',[1,10,100,1000],'TickLength',[TickLength 0.035])
% colorbar
originalSize = get(gca, 'Position');
caxis([1,1 + (select_num-1)*1e3])
colormap(cc,'jet')
c = colorbar('Position', [originalSize(1) + originalSize(3) + 0.01  originalSize(2) 0.01 originalSize(4) ],'location','east');
T = title(c,'Time (step)','fontsize',fontsize);
set(gca, 'Position', originalSize);

% all MSD curves
insect = axes('position',[0.0744429480241422 0.778745644599303 0.105451231870038 0.149985821741288]);
axis(insect);box on;
hold on
for k=1:select_num%length(tau)
    loglog(tau{k},MSD{k},'color',map(k,:),'linewidth',0.5*linewidth)
end
axis([1,1e3,1e-2,1e2])
set(gca,'xscale','log','yscale','log','xtick',[],'ytick',[]) 

% L vs t
load('/import/headnode1/gche4213/Project3/trans_ex_avalan.mat')
subaxis(total_row,total_column,2,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
hold on
for k = [1,round(select_num/5),round(select_num*2/5),round(select_num*3/5),round(select_num*4/5),select_num]
    plot(loss_all{ii}(((k-1)*1000+1):k*1000),'color',map(k,:),'linewidth',linewidth)
end
x = xlabel('Time (step)');
y = ylabel('L');
set(y, 'Units', 'Normalized', 'Position', [ylable_shift, 0.5, 0]);
set(x, 'Units', 'Normalized', 'Position', [0.5, xlable_shift, 0]);
text(-0.18,1.15,'b','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','TickLength',[TickLength 0.035])


% \Delta L vs t
subaxis(total_row,total_column,3,1,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
delta_loss_temp = diff(loss_all{ii});
plot(1:200:numel(delta_loss_temp),abs(delta_loss_temp(1:200:end)),'linewidth',linewidth,'color','k')
xlim([0,24000])
x = xlabel('Time (step)');
y = ylabel('|{\Delta}L|');
set(y, 'Units', 'Normalized', 'Position', [ylable_shift, 0.5, 0]);
set(x, 'Units', 'Normalized', 'Position', [0.5, xlable_shift, 0]);
text(-0.18,1.15,'c','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','TickLength',[TickLength 0.035])


% gradient
load('/import/headnode1/gche4213/Project3/plot_data/gradient_dist.mat')
subaxis(total_row,total_column,1,2,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
hold on
kk = 1;
histogram(grad{kk},651,'normalization','pdf','facecolor',[1,1,1]);
plot(linspace(-0.05,0.05,5000),pdf(F{kk},linspace(-0.05,0.05,5000)),'r-');
xlim([-0.006,0.006])
y = ylabel('PDF');
x = xlabel('Gradient');
set(y, 'Units', 'Normalized', 'Position', [ylable_shift, 0.5, 0]);
set(x, 'Units', 'Normalized', 'Position', [0.5, xlable_shift, 0]);
text(-0.18,1.15,'d','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','TickLength',[TickLength 0.035])

% log-log scale
insect = axes('position',[0.227513227513228 0.346689895470383 0.0751379331470445 0.0994282937363812]);
axis(insect);box on;
plot(linspace(0,0.2,1000),pdf(F{kk},linspace(0,0.2,1000)),'r-');
% axis([1,1e3,1e-2,1e2])
set(get(gca,'Ylabel'),'rotation',-45)
set(gca,'xscale','log','yscale','log','tickdir','out','TickLength',[TickLength 0.035]) 


% batch size
% all data are from /Project3/MSD_exponent_DNN.xlsx
keySet = {'14_128_0','14_512_0','14_1024_0','14_128_1','14_512_1','14_1024_1',...
    '20_128_0','20_512_0','20_1024_0','20_128_1','20_512_1','20_1024_1',...
    '56_128_0','56_512_0','56_1024_0','56_128_1','56_512_1','56_1024_1',...
    '110_128_0','110_256_0','110_512_0','110_128_1','110_256_1','110_512_1'};    
valueSet_exp1 = [1.358974359,1.221590909,1.387755102,1.315384615,1.404958678,1.214689266,...
1.230769231,1.297709924,1.31372549,1.227436823,1.36,1.36,...
1.111111111,1.1,1.033333333,1.157894737,1.172413793,1.259259259,...
1.012048193,1.172413793,1.35,1.215753425,1.181818182,1.416666667
];
valueSet_exp2 = [0.7,0.69,0.69,0.726666667,0.7,0.782608696,0.649717514,0.683333333,0.693333333,0.733333333,...
    0.703333333,0.6,0.766666667,0.716666667,0.7,0.684210526,0.75,0.733333333,0.7,0.745762712,0.733333333,0.8,...
    0.88372093,0.67357513];
valueSet_tau = [80,50,65,180,100,70,140,60,100,150,100,45,200,125,133,70,70,70,300,400,300,220,110,100];
M_exp1 = containers.Map(keySet,valueSet_exp1);
M_exp2 = containers.Map(keySet,valueSet_exp2);
M_tau = containers.Map(keySet,valueSet_tau);

subaxis(total_row,total_column,2,2,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);

hold on
% depth 14
% with short cut
a = plot([128,512,1024],[M_exp1('14_128_1'),M_exp1('14_512_1'),M_exp1('14_1024_1')],'marker','o','linestyle','-','color','k','linewidth',linewidth);
% depth 20
% with short cut
b = plot([128,512,1024],[M_exp1('20_128_1'),M_exp1('20_512_1'),M_exp1('20_1024_1')],'marker','.','linestyle','-','color','k','linewidth',linewidth);
% depth 56
% with short cut
c = plot([128,512,1024],[M_exp1('56_128_1'),M_exp1('56_512_1'),M_exp1('56_1024_1')],'marker','x','linestyle','-','color','k','linewidth',linewidth);

ylim([1,1.6])
legend([a,b,c],{'ResNet-14','ResNet-20','ResNet-56','ResNet-110'})
legend boxoff

y = ylabel('MSD exponent 1');
set(y, 'Units', 'Normalized', 'Position', [ylable_shift, 0.5, 0]);
x = xlabel('Minibatch size');
set(x, 'Units', 'Normalized', 'Position', [0.5, xlable_shift, 0]);
text(-0.18,1.15,'e','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','TickLength',[TickLength 0.035])


% learning rate
% all data are from /Project3/MSD_exponent_DNN.xlsx
keySet = {'0.001','0.01','0.05','0.1','0.5'};    
valueSet_exp1 = [2,1.833333333,1.7,1.387755102,1.4];
valueSet_exp2 = [2,1.7,0.676666667,0.69,0.726666667];
M_exp1 = containers.Map(keySet,valueSet_exp1);
M_exp2 = containers.Map(keySet,valueSet_exp2);

subaxis(total_row,total_column,3,2,'SpacingHoriz',SH,...
    'SpacingVert',SV,'MR',MR,'ML',ML,'MT',MT,'MB',MB);
plot([0.001,0.01,0.05,0.1,0.5],[M_exp1('0.001'),M_exp1('0.01'),M_exp1('0.05'),M_exp1('0.1'),M_exp1('0.5')],'marker','o','linestyle','-','color','k','linewidth',linewidth)
y = ylabel('MSD exponent 1');
set(y, 'Units', 'Normalized', 'Position', [ylable_shift, 0.5, 0]); 
x = xlabel('Learning rate');
set(x, 'Units', 'Normalized', 'Position', [0.5, xlable_shift, 0]);
text(-0.18,1.15,'f','fontsize',fontsize,'Units', 'Normalized', 'FontWeight','bold','VerticalAlignment', 'Top')
set(gca,'linewidth',linewidth,'fontsize',fontsize,'tickdir','out','TickLength',[TickLength 0.035])


set(gcf, 'PaperPositionMode', 'auto');

% output
print('-painters' ,'/import/headnode1/gche4213/Project3/outputfigures/superdiffusion.svg','-dsvg','-r300')

function dur = calculate_avalance_dur(L)
L = abs(L);
SD = std(L);
bool_vec = L > SD;
CC = bwconncomp(bool_vec);
dur = cellfun(@length,CC.PixelIdxList);
end


function h=plplot_selfdefine(x, xmin, alpha)
% PLPLOT visualizes a power-law distributional model with empirical data.
%    Source: http://www.santafe.edu/~aaronc/powerlaws/
% 
%    PLPLOT(x, xmin, alpha) plots (on log axes) the data contained in x 
%    and a power-law distribution of the form p(x) ~ x^-alpha for 
%    x >= xmin. For additional customization, PLPLOT returns a pair of 
%    handles, one to the empirical and one to the fitted data series. By 
%    default, the empirical data is plotted as 'bo' and the fitted form is
%    plotted as 'k--'. PLPLOT automatically detects whether x is composed 
%    of real or integer values, and applies the appropriate plotting 
%    method. For discrete data, if min(x) > 50, PLFIT uses the continuous 
%    approximation, which is a reliable in this regime.
%
%    Example:
%       xmin  = 5;
%       alpha = 2.5;
%       x = xmin.*(1-rand(10000,1)).^(-1/(alpha-1));
%       h = plplot(x,xmin,alpha);
%
%    For more information, try 'type plplot'
%
%    See also PLFIT, PLVAR, PLPVA

% Version 1.0   (2008 February)
% Copyright (C) 2008-2011 Aaron Clauset (Santa Fe Institute)
% Distributed under GPL 2.0
% http://www.gnu.org/copyleft/gpl.html
% PLFIT comes with ABSOLUTELY NO WARRANTY
% 
% No notes
% 

% reshape input vector
x = reshape(x,numel(x),1);
% initialize storage for output handles
h = zeros(2,1);

% select method (discrete or continuous) for plotting
if     isempty(setdiff(x,floor(x))), f_dattype = 'INTS';
elseif isreal(x),    f_dattype = 'REAL';
else                 f_dattype = 'UNKN';
end;
if strcmp(f_dattype,'INTS') && min(x) > 50,
    f_dattype = 'REAL';
end;

% estimate xmin and alpha, accordingly
switch f_dattype,
    
    case 'REAL',
        n = length(x);
        c = [sort(x) (n:-1:1)'./n];
        q = sort(x(x>=xmin));
        cf = [q (q./xmin).^(1-alpha)];
        cf(:,2) = cf(:,2) .* c(find(c(:,1)>=xmin,1,'first'),2);

%         figure;
        h(1) = loglog(c(:,1),c(:,2),'bo','MarkerSize',2,'MarkerFaceColor',[1 1 1]); hold on;
        h(2) = loglog(cf(:,1),cf(:,2),'k-'); hold off;
        xr  = [10.^floor(log10(min(x))) 10.^ceil(log10(max(x)))];
        xrt = (round(log10(xr(1))):2:round(log10(xr(2))));
        if length(xrt)<4, xrt = (round(log10(xr(1))):1:round(log10(xr(2)))); end;
        yr  = [10.^floor(log10(1/n)) 1];
        yrt = (round(log10(yr(1))):2:round(log10(yr(2))));
        if length(yrt)<4, yrt = (round(log10(yr(1))):1:round(log10(yr(2)))); end;
        set(gca,'XLim',xr);
        set(gca,'YLim',yr);
        

    case 'INTS',
        n = length(x);        
        q = unique(x);
        c = hist(x,q)'./n;
        c = [[q; q(end)+1] 1-[0; cumsum(c)]]; c(c(:,2)<10^-10,:) = [];
        cf = ((xmin:q(end))'.^-alpha)./(zeta(alpha) - sum((1:xmin-1).^-alpha));
        cf = [(xmin:q(end)+1)' 1-[0; cumsum(cf)]];
        cf(:,2) = cf(:,2) .* c(c(:,1)==xmin,2);

%         figure;
        h(1) = loglog(c(:,1),c(:,2),'ko','MarkerSize',3,'MarkerFaceColor',[1 1 1]); hold on;
        %h(2) = loglog(cf(:,1),cf(:,2),'r--','MarkerSize',1); hold off;
        xr  = [10.^floor(log10(min(x))) 10.^ceil(log10(max(x)))];
        xrt = (round(log10(xr(1))):2:round(log10(xr(2))));
        if length(xrt)<4, xrt = (round(log10(xr(1))):1:round(log10(xr(2)))); end;
        yr  = [10.^floor(log10(1/n)) 1];
        yrt = (round(log10(yr(1))):2:round(log10(yr(2))));
        if length(yrt)<4, yrt = (round(log10(yr(1))):1:round(log10(yr(2)))); end;
        set(gca,'XLim',xr);
        set(gca,'YLim',yr);        

    otherwise,
        fprintf('(PLPLOT) Error: x must contain only reals or only integers.\n');
        h = [];
        return;
end
end