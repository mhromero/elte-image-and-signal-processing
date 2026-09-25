list = dir('lena_noise/images\\*.png');
L = 0;
for i = 1:length(list)
    L = L + im2double(imread(['lena_noise/images\\', list(i).name]));
end
L = L / length(list);
figure, imshow(L)
