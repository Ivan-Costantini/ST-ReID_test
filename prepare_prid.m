clear all
%D = 'F:\Utenti\Ivan\Desktop\Stage\Programmi\Spatial-Temporal-Re-identification-master\raw-dataset\PRID2011\multi_shot\cam_a\';
directory = 'F:\Utenti\Ivan\Desktop\Stage\Programmi\Spatial-Temporal-Re-identification-master\raw-dataset\PRID2011\multi_shot\cam_2';
folders = dir(directory);

if ~exist('dataset', 'dir')
    mkdir('dataset')
end

for i = 3:numel(folders)
    D = strcat(directory, '\', folders(i).name);
    S = dir(fullfile(D, '0*.png')); % pattern to match filenames.

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

        folder = strcat('dataset\', person);

        if ~exist(folder, 'dir')
           mkdir(folder)
        end

        imwrite(I, strcat(folder, '\', person, '_c', camera, '_f', frame, '_00.png')) 
        % create folder

        %imshow(I)
        %S(k).data = I; % optional, save data.
    end
end