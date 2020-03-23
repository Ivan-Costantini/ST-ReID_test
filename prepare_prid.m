clear all
%D = 'F:\Utenti\Ivan\Desktop\Stage\Programmi\Spatial-Temporal-Re-identification-master\raw-dataset\PRID2011\multi_shot\cam_a\';
directory = 'raw-dataset\PRID2011\multi_shot';
cameraFolders = {'cam_1' 'cam_2'};

save_folder = 'dataset\prid2011_rename_v2';
prepare_folder = 'dataset\prid2011_prepare';
if ~exist(prepare_folder, 'dir')
    mkdir(prepare_folder)
end

fprintf('Starting Pre-Processing \n');

total = 0;
for j = 1:numel(cameraFolders)
    total = total + numel(dir(strcat(directory, '\', cameraFolders{j})));
end

progress = 0;
multiplier = 1;
offset = 0;
for j = 1:numel(cameraFolders)
    folders = dir(strcat(directory, '\', cameraFolders{j}));
    for i = 3:numel(folders)
        D = strcat(directory, '\', cameraFolders{j}, '\', folders(i).name);
        S = dir(fullfile(D, '*.png')); % pattern to match filenames.

        result = cell(1, numel(S));
        for k = 1:numel(S)
            F = fullfile(D,S(k).name);


            person = split(F, 'person_');
            person = split(person{2}, '\');
            person = person{1};

            name = split(S(k).name, '.');
            frame = name{1};

            camera = split(F, 'cam_');
            camera = split(camera{2}, '\');
            camera = camera{1};

            I = imread(F);

            folder = strcat(prepare_folder, '\', person);

            if ~exist(folder, 'dir')
               mkdir(folder)
            end

            imwrite(I, strcat(folder, '\', person, '_c', camera, '_f', frame, '_00.png')) 
        end
        progress = (i+offset)/total*100;

        if(uint8(progress) > multiplier*10)
            fprintf('Progress Reached: %0.2f %%', progress);
            fprintf('\n');
            multiplier = multiplier+1;
        end
    end
    offset = offset+numel(folders);
end

fprintf('Progress Reached: %0.2f %%', progress);
fprintf('\n');
fprintf('Pre-Processing Done \n');

make_query(prepare_folder, save_folder);

fprintf('Beginning removal of Pre-Processed files \n');

status = rmdir(prepare_folder, 's');
if(status == 1)
    fprintf('Removal completed Successfully \n');
else
    fprintf('Removal could not be completed Successfully \n');
end
fprintf('Done! \n');