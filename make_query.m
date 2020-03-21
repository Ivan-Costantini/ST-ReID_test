clear all
%D = 'F:\Utenti\Ivan\Desktop\Stage\Programmi\Spatial-Temporal-Re-identification-master\raw-dataset\PRID2011\multi_shot\cam_a\';
directory = 'F:\Utenti\Ivan\Desktop\Stage\Datasets\cuhk03_release\cuhk03_release\dataset_labeled';

if ~exist('gallery', 'dir')
    mkdir('gallery')
end
if ~exist('query', 'dir')
    mkdir('query')
end
if ~exist('train_all', 'dir')
    mkdir('train_all')
end


folders = dir(directory);

r = randperm(numel(folders)-2);
r = sort(r(1:floor((numel(folders)-2)/2))+2);
numel(r)

t = 0;
multiplier = 1;
for i = 3:numel(folders)
    D = strcat(directory, '\', folders(i).name);
    S = dir(fullfile(D, '*.png')); % pattern to match filenames.

    person = folders(i).name;
    
    if(isempty(find(r == i)))
        folder = strcat('train_all\', person);
        if ~exist(folder, 'dir')
            mkdir(folder)
        end
        for k = 1:numel(S)
            I = imread(strcat(folders(i).folder, '\', folders(i).name, '\', S(k).name));
            imwrite(I, strcat(folder, '\', S(k).name));
        end
        
        folder = strcat('train\', person);
        if ~exist(folder, 'dir')
            mkdir(folder)
            
            mkdir('val\', person)
            I = imread(strcat(folders(i).folder, '\', folders(i).name, '\', S(1).name));
            imwrite(I, strcat('val\', person, '\', S(1).name));
        end
        for k = 2:numel(S)
            I = imread(strcat(folders(i).folder, '\', folders(i).name, '\', S(k).name));
            imwrite(I, strcat(folder, '\', S(k).name));
        end
        
        progress = t/numel(r)*100;
        t = t+1;
        if(uint8(progress) >= multiplier*10)
            fprintf('Progress Reached: %0.2f %%', progress);
            fprintf('\n');
            multiplier = multiplier+1;
        end
    else
        result = cell(1, numel(S));
        camera1 = 0;
        camera2 = 0;
        for k = 1:numel(S)
            F = fullfile(D,S(k).name);

            camera = split(F, '_c');
            camera = split(camera{2}, '_');
            camera = camera{1};

            if(strcmp(camera,'1'))
                camera1 = k;
            else
                camera2 = k;
            end

            folder = strcat('gallery\', person);
            if ~exist(folder, 'dir')
                mkdir(folder)
            end

            I = imread(F);
            imwrite(I, strcat(folder, '\', S(k).name));

        end

        folder = strcat('query\', person);
        if ~exist(folder, 'dir')
            mkdir(folder)
        end

        if(camera1 > 0)
            n1 = randi([1, camera1], 1,1);
            name1 = S(n1).name;
            I1 = imread(fullfile(D,name1));
            imwrite(I1, strcat(folder, '\', name1));
        end

        if(camera2 > 0)
            n2 = randi([camera1, camera2], 1,1);
            name2 = S(n2).name;
            I2 = imread(fullfile(D,name2));
            imwrite(I2, strcat(folder, '\', name2));
        end
    end
end

fprintf('Progress Reached: %0.2f %%', progress);
fprintf('\n');
fprintf('done! \n');