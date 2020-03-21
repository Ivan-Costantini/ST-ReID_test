clear all

load('cuhk-03.mat');
fprintf('Finished loading dataset \n');
dataset_name = 'dataset_labeled';
if ~exist(dataset_name, 'dir')
    mkdir(dataset_name)
end

total = 0;
for c = 1:size(labeled,1)
    total = total+size(labeled{c},1);
end

numberofselected = 0;
notselected = 0;

offset = 0;
multiplier = 1;
for c = 1:size(labeled,1)
    for i = 1:size(labeled{c},1)
        personImages = labeled{c}(i,:);

        person = '';
        for k = 1:(3-floor(log10(offset+i)))
            person = strcat(person, '0');
        end
        person = strcat(person, num2str(offset+i));

        folder = strcat(dataset_name, '\', person);
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

                %imwrite(im, filename)
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
    offset = offset+size(labeled{c},1);
end
fprintf('Progress Reached: %0.2f %%', progress);
fprintf('\n');
fprintf('Processing Done \n');