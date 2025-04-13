clc
clear 
close all
num = 0;  
Image_dir = '.\test\';
listing = cat(1, dir(fullfile(Image_dir, '*.jpg')));
% The final output will be saved in this directory:
result_dir = fullfile(Image_dir, 'results');
% Preparations for saving results.
if ~exist(result_dir, 'dir'), mkdir(result_dir); end

for i_img = 1:length(listing)


    Input = imread(fullfile(Image_dir,listing(i_img).name));
    [~, img_name, ~] = fileparts(listing(i_img).name);
    img_name = strrep(img_name, '_input', '');     
 % Set target mean and standard deviation (statistics based on natural images)
    mu_target_L = 47.30;
    mu_target_a = 1.14;
    mu_target_b = 7.10;
    sigma_target_L = 23.60;
    sigma_target_a = 8.90;
    sigma_target_b = 13.85;
    % Set parameters
    alpha = 0.1;      % Mean adjusted learning rate
    beta = 0.1;       % Standard deviation adjusted learning rate
    lambda1 = 1;      % Mean loss weight
    lambda2 = 1;      % Standard deviation loss weight
    epsilon = 1e-6;   % Stop condition threshold
    max_iter = 1000000;   % Maximum iterations
    distorted_image = Input;
    %Global color correction
    corrected_image = color_correction_loss(distorted_image, mu_target_L, mu_target_a, mu_target_b, sigma_target_L, sigma_target_a, sigma_target_b, alpha, beta, lambda1, lambda2, epsilon, max_iter);
    %Local color correction
    Result = adaptive_local_correction(corrected_image);
    imwrite(Result, fullfile(result_dir, [img_name, '.jpg']));
end