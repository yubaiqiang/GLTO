function corrected_rgb_image = adaptive_local_correction(distorted_image)
    % Convert the image to the CIELab color space
    lab_image = rgb2lab(distorted_image);
    L_channel = lab_image(:,:,1); 
    a_compensated = lab_image(:,:,2); 
    b_compensated = lab_image(:,:,3); 

    % Parameter setting
    gamma_0 = 0.5;      
    alpha_small = 2.5;  % Increase the small scale high frequency enhancement factor
    alpha_large = 0.5;  % Reduce the large scale high frequency enhancement coefficient

 
    % A different guide filter is used to enhance the high frequency portion of the L-channel
    L_blurred_small = imguidedfilter(L_channel, L_channel);
    L_blurred_large = imguidedfilter(L_channel, L_channel * 0.5);  

    % Computed high frequency part
    L_high_freq_small = L_channel - L_blurred_small;
    
    L_high_freq_large = L_channel - L_blurred_large;
    
    % High-frequency enhancement
    L_high_freq_enhanced = alpha_small * L_high_freq_small + alpha_large * L_high_freq_large;
    
    % Merge enhanced L channels
    L_enhanced = L_channel + L_high_freq_enhanced;
    
    % Adaptive local correction (using guide filtering instead of mean filtering)
    L_max = max(L_enhanced(:));  
    gamma_local = gamma_0 * (1 - L_enhanced / L_max);

    % Local mean correction using guided filtering
    a_local_mean = imguidedfilter(a_compensated, L_enhanced); % Use the enhanced L channel as a guide
    b_local_mean = imguidedfilter(b_compensated, L_enhanced);
    
    % Correct channels a and b
    a_corrected = a_compensated - gamma_local .* a_local_mean;
    b_corrected = b_compensated - gamma_local .* b_local_mean;
    
    % The enhanced L channel and the corrected a and b channels are merged
    corrected_lab_image = cat(3, L_enhanced, a_corrected, b_corrected);

    % Convert back to RGB color space
    corrected_rgb_image = lab2rgb(corrected_lab_image);
end 
