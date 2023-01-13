function contrast = Contrast(warp_frame, width, length)
 
    %This function caclulates the contrast of an image

    Np = width*length; %num of pixels in the warp frame
    mean_warp_image = sum(warp_frame,'all') ./ Np;
    x = (warp_frame - mean_warp_image).^2;
    contrast = sum(x,'all') ./ Np; 
end