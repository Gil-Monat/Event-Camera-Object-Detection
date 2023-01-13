function [denoised_events] = hot_pixel_denoising(events, width, len, n)
    %This function removes events from all-time noisy pixels [the brightest
    %pixels in IWE image of motionless model]
    
    %events = the orinal events vector. (x,y,p,ts)
    %n = number of pixels in IWE image to denoise 
    
    warp_image = warp(events, [0,0], width, len); %making IWE image of motionless model (projecting the events on XY plane)
    
    [~,idx] = maxk(warp_image(:),n); %finding the indices of wanting pixels
    [ind_row,ind_col] = ind2sub(size(warp_image),idx);
    
    for i = linspace(1,length(ind_row),length(ind_row)) %removing the events mapped to the n brightest pixels
        events(events(:,2) == ind_row(i) & events(:,1) == ind_col(i),: ) = [];
    end
    denoised_events = events;
end