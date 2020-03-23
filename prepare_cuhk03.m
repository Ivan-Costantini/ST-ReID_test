clear all

load('raw-dataset\CUHK03\cuhk-03.mat');
fprintf('Finished loading dataset \n');

% choose labeled or detected
% current = detected;
% dataset_name = 'detected';
current = labeled;
dataset_name = 'labeled';

prepare_folder = 'dataset\cuhk03_prepare';
save_folder = strcat('dataset\cuhk03_', dataset_name, '_rename');

if ~exist(strcat(prepare_folder), 'dir')
    mkdir(strcat(prepare_folder))
end


total = 0;
for c = 1:size(current,1)
    total = total+size(current{c},1);
end

numberofselected = 0;
notselected = 0;

offset = 0;
multiplier = 1;
for c = 1:size(current,1)
    for i = 1:size(current{c},1)
        personImages = current{c}(i,:);
        
        % generate filename
        person = '';
        for k = 1:(3-floor(log10(offset+i)))
            person = strcat(person, '0');
        end
        person = strcat(person, num2str(offset+i));

        folder = strcat('dataset\cuhk03_prepare\', person);
        if ~exist(folder, 'dir')
            mkdir(folder)
        end

        for j = 1:numel(personImages)
            camera = '1';
            if(j > 5)
                camera = '2';
            end

            frame = num2str(mod(j-1,5));

            im = personImages{j};
            if(not(size(im,1)==0))
                filename = strcat(folder, '\', person, '_c', camera, '_f000', frame, '_00.png');

                imwrite(im, filename)
                numberofselected = numberofselected+1;
            else
                notselected = notselected+1;
            end
        end

        progress = (i+offset)/total*100;

        if(uint8(progress) > multiplier*10)
            fprintf('Progress Reached: %0.2f %%', progress);
            fprintf('\n');
            multiplier = multiplier+1;
        end
    end
    offset = offset+size(current{c},1);
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
