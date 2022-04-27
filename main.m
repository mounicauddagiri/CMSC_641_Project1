clc;
close all;

% declaring the image scale 
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];
% reading the input image and rescaling it to the mentioned scale
% texture_our_pic = imread('green_plum.jpg');
texture_our_pic = imread('pommo.jpg');
input_img = double(texture_our_pic)/255.0;
% getting the dimensions of the input image
[h,w,num_chan] = size(input_img);
% setting the variables for image quilting
patch_size = 60;
overlap_size = patch_size/6;
net_patch_size = patch_size-overlap_size;
error_tolerance = 0.1;

hnew = 2*net_patch_size*floor(h/net_patch_size) + overlap_size;
wnew = 2*net_patch_size*floor(w/net_patch_size) + overlap_size;
final_img = zeros([hnew,wnew,num_chan]);

i_max = (hnew-overlap_size)/net_patch_size;
j_max = (wnew-overlap_size)/net_patch_size;

for i = 1: i_max
    for j = 1:j_max
        if i==1 && j==1
            final_img(1:patch_size,1:patch_size,:) = getRandomPatch(input_img,patch_size);
%       first vertical patch of the image
        elseif i==1 
            start_ind = net_patch_size + (j-2)*net_patch_size;
            prev_patch = final_img(1:patch_size,start_ind - net_patch_size+1:start_ind - net_patch_size + patch_size,:);
            ref_patches = cell(1,3);
            ref_patches{1} = prev_patch;
%           finding the best patch from the random patches
            selected_patch = findBestPatch(ref_patches, input_img, error_tolerance, 'vertical',overlap_size, patch_size);
            final_patch = minCut(ref_patches, selected_patch, overlap_size, 'vertical', patch_size); 
%           appending the mincut patch to the modified pic
            final_img(1:patch_size, start_ind+1:start_ind+patch_size,:) = final_patch;
%       first top patch of the image
        elseif j==1
            start_ind = net_patch_size + (i-2)*net_patch_size;
            prev_patch = final_img(start_ind - net_patch_size + 1:start_ind - net_patch_size + patch_size,1:patch_size,:);
            ref_patches = cell(1,3);
			ref_patches{2} = prev_patch;
%           finding the best patch from the random patches
            selected_patch = findBestPatch(ref_patches, input_img, error_tolerance, 'horizontal', overlap_size, patch_size);
			final_patch = minCut(ref_patches,selected_patch,overlap_size,'horizontal',patch_size);
%           appending the mincut patch to the modified pic			
			final_img(start_ind+1:start_ind+patch_size,1:patch_size,:) = final_patch;
        else
            
            left_ind = net_patch_size + (j-2)*net_patch_size;
            top_ind = net_patch_size + (i-2)*net_patch_size;
            left_patch = final_img(top_ind + 1 : top_ind + patch_size,left_ind - net_patch_size + 1:left_ind - net_patch_size + patch_size,:);
			top_patch = final_img(top_ind - net_patch_size + 1:top_ind - net_patch_size + patch_size,left_ind + 1:left_ind + patch_size,:);
			corner_patch = final_img(top_ind - net_patch_size + 1:top_ind - net_patch_size + patch_size,left_ind - net_patch_size + 1:left_ind - net_patch_size + patch_size,:);
            
            ref_patches = cell(1,3);
			ref_patches{1} = left_patch;
			ref_patches{2} = top_patch;
			ref_patches{3} = corner_patch;
%           finding the best patch for the corner part of the image
			selected_patch = findBestPatch(ref_patches, input_img, error_tolerance, 'both', overlap_size, patch_size);
			final_patch = minCut(ref_patches,selected_patch,overlap_size,'both',patch_size);
%           appending the corner part with the final patch to the modified
%           image
			final_img(top_ind+1:top_ind+patch_size,left_ind+1:left_ind+patch_size,:) = final_patch;
        end
    end
end
% imwrite(final_img,'output_image1.jpg');
imwrite(final_img,'output_image2.jpg');
imshow('output_image2.jpg');