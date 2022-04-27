function random_patch = getRandomPatch(original_pic,patch_size)
    [h,w,~] = size(original_pic);
    h_rand = randi(h-patch_size+1);
    w_rand = randi(w-patch_size+1);
    random_patch = original_pic(h_rand:h_rand+patch_size-1,w_rand:w_rand+patch_size-1,:);
end