function [bright_events, dark_events] = thresholding(events, mot_param, width, length, percent, kernel_size, enlarge_factor)
    %This function returns the events that are warped to bright pixels
    
    %Bright pixels are considered bright if they are brighter than %percent
    %of the brightest pixel
    
    %We also consider pixels that are in a rectangular vacinity of those pixels
    %as bright
    %The rectangle (Kernel) dimensions are determined by the parameters
    %"kernel_size" and "enlarge_factor"
    
    %bright_events is the vector of the events warped to bright pixels
    %dark_events is the vector of the rest of the events
    
    bright_events = [];
    dark_events = [];
    warped_image = warp(events,mot_param,width,length);
    t_0 = events(1,4);
    i=0;
    max_warp_val = max(warped_image,[], 'all');
    thresh = max_warp_val*(100-percent)/100;
    bright_image = warped_image;
    bright_image(bright_image < thresh) = 0;
    bright_image(bright_image >= thresh) = 1;
    
    
    v_norm = mot_param./norm(mot_param);
    kernel = ones(kernel_size + uint8(abs(v_norm)*enlarge_factor)).';
    
    
    kernel = imrotate(kernel, atan2(mot_param(2),mot_param(1)));


    
    dilated_image = imdilate(bright_image, kernel);
    figure()
    imshow(dilated_image,[])
%     figure();
%     imshow(dilated_image,[]);
%     title("Dilated brightest event image")
    for j = 1:size(events,1)-1
        i = i+1;
        if (floor(events(i,1) - mot_param(1)*(events(i,4)-t_0)) < width)...
            && (floor(events(i,2) - mot_param(2)*(events(i,4)-t_0)) < length) ...
            && (floor(events(i,1) - mot_param(1)*(events(i,4)-t_0)) >= 1)...
            && (floor(events(i,2) - mot_param(2)*(events(i,4)-t_0)) >=1 ) 
            %this ignores events that are warped out of bounds

            if dilated_image(floor(events(i,2) - mot_param(2)*(events(i,4)-t_0))...
                    , floor(events(i,1) - mot_param(1)*(events(i,4)-t_0))) == 1
                %this is for linear motion model
                bright_events = cat(1,bright_events, events(i,:));
            else
                 dark_events = cat(1, dark_events, events(i,:)); 
            end
        
        end
    end
end