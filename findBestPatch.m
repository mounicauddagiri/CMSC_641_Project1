function selected_patch = findBestPatch(ref_patches, original_pic, error_tolerance, overlap_type, overlap_size, patch_size)
    [h,w,num_chan] = size(original_pic);
    error_patch = zeros([h-patch_size+1,w-patch_size+1]);
    min_error = 10000000.0;
    for i=1:h-patch_size+1
		for j=1:w-patch_size+1
			curr_patch = original_pic(i:i+patch_size-1,j:j+patch_size-1,:);
			overlap_error = findError(curr_patch,ref_patches,overlap_type,overlap_size,patch_size);
			if overlap_error == 0
				error_patch(i,j) = 0;
			else
				error_patch(i,j) = overlap_error;
				if overlap_error < min_error
					min_error = overlap_error;
				end
			end			
        end
    end
    
    min_error = min_error*(1+error_tolerance);
    [best_patches_i, best_patches_j] = find(error_patch<min_error);
    x = randi(length(best_patches_i),1);
    
    start_i = best_patches_i(x);
	start_j = best_patches_j(x);

	selected_patch = original_pic(start_i:start_i+patch_size-1, start_j:start_j+patch_size-1, :);
end

% choosing the best patch based on the minimum rms error for the chosen
% random patches
function overlap_error = findError(curr_patch, ref_patches, overlap_type, overlap_size, patch_size)
    if strcmp(overlap_type,'vertical')
        left_patch = ref_patches{1};
        left_overlap = left_patch(:,patch_size-overlap_size+1:patch_size,:);
        curr_overlap = curr_patch(:,1:overlap_size,:);
        overlap_error = rmsError(left_overlap,curr_overlap);
    elseif strcmp(overlap_type,'horizontal')
        top_patch = ref_patches{2};
		top_overlap = top_patch(patch_size-overlap_size+1:patch_size,:,:);
		curr_overlap = curr_patch(1:overlap_size,:,:);
		overlap_error = rmsError(top_overlap,curr_overlap);
    else
        left_patch = ref_patches{1};
		left_overlap = left_patch(:,patch_size-overlap_size+1:patch_size,:);
		
		top_patch = ref_patches{2};
		top_overlap = top_patch(patch_size-overlap_size+1:patch_size,:,:);
        
        corner_patch = ref_patches{3};
		corner_overlap = corner_patch(patch_size-overlap_size+1:patch_size,patch_size-overlap_size+1:patch_size,:);
		
		curr_top_overlap = curr_patch(1:overlap_size,:,:);
		curr_left_overlap = curr_patch(:,1:overlap_size,:);
		curr_corner_overlap = curr_patch(1:overlap_size,1:overlap_size,:);

		overlap_left_error = rmsError(left_overlap,curr_left_overlap);
		overlap_top_error = rmsError(top_overlap,curr_top_overlap);
		overlap_corner_error = rmsError(corner_overlap,curr_corner_overlap);

		overlap_error = overlap_left_error + overlap_top_error - overlap_corner_error;
    end
end

% Root Mean Square Error function
function rmse_error = rmsError(patch_a,patch_b)
    diff_patch = patch_a - patch_b;
    square_diff = diff_patch.*diff_patch;
    rmse_error = sum(sum(sum(square_diff)));
end