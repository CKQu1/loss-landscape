clear
d = dir('resnet*');

pool{1} = [16,32,50];%110
pool{2} = [8,16,25];%14
pool{3} = [80,160, 250];%20_noshort
pool{4} = [80,160,250];%20
pool{5} = [80,160,250];%56

model_name{1} = '110';
model_name{2} = '14';
model_name{3} = '20_noshort';
model_name{4} = '20';
model_name{5} = '56';

file_name{1} = [160,320,500];
file_name{2} = [160,320,500];
file_name{3} = [160,320,500];
file_name{4} = [160,320,500];
file_name{5} = [160,320,500];


fileID = fopen('exp.txt','wt');

for ii = 1:length(d)
    for jj = 1:3
        x = h5read(fullfile(d(ii).folder,d(ii).name,sprintf('PCA_tiny_epoch%d/directions.h5_proj_cos.h5',pool{ii}(jj))),'/proj_xcoord');
        
        y = h5read(fullfile(d(ii).folder,d(ii).name,sprintf('PCA_tiny_epoch%d/directions.h5_proj_cos.h5',pool{ii}(jj))),'/proj_ycoord');
        
        x_range = abs(max(x) - min(x));
        y_range = abs(max(x) - min(x));
        
        command = ['python plot_surface.py --cuda --model resnet',model_name{ii},sprintf(' --x=%d:%d:51 --y=%d:%d:51 ',round(min(x) - 0.2*x_range), round(max(x) + 0.2*x_range), round(min(y) - 0.2*y_range), round(max(y) + 0.2*y_range)),...
            '--model_file ./trained_nets/',d(ii).name,'/model_',num2str(file_name{ii}(jj)),'.t7 --dir_file ./trained_nets/',d(ii).name,sprintf('/PCA_tiny_epoch%d',pool{ii}(jj)),'  --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot --log'];
        fwrite(fileID,command);
        fprintf(fileID,'\n');
    end
end

fclose(fileID);