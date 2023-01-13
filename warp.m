function [warp_frame] = warp(events, mot_param, width, length)
    %This function warps the events to IWE image according the motion parameters. 
    % *** Currently we are using a LINEAR MOTION model
    % The dimensions of the resulting image is width*length.

    %mot_param = (Vx,Vy) in pixel/sec
    %events = (x,y,p,ts) 

    t_0 = events(1,4); %Time stamp of the first event
    warped_events = [events(:,1) - mot_param(1)*(events(:,4)-t_0),...
        events(:,2) - mot_param(2)*(events(:,4)-t_0),...
        events(:,4)-t_0]; %Calculating the warp according to the motion model

    warped_events(:,1:2) = floor(warped_events(:,1:2)); 

    warped_events(((warped_events(:,1) >= width) |...
        (warped_events(:,1) < 1) |...
        (warped_events(:,2) >= length) |...
        (warped_events(:,2) < 1)), :) = []; %Removing events that were warped out of IWE image bounds

    %Making the image:
    warp_frame = zeros([length,width]);
    for j = 1:size(warped_events,1)-1
        warp_frame(warped_events(j,2), warped_events(j,1)) = warp_frame(warped_events(j,2), warped_events(j,1)) + 1;
    end

end