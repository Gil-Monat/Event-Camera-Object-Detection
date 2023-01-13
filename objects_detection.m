function [events_sets , n_iterations] = ...
    objects_detection(events, w ,l, loss_func, initial_velocities,...
    thersh_percentile, kernel_size, enlarge_factor, max_iterations_num, stop_percentage)
    % This fuction runs the algorithm to detect which events make each object in the time frame
    % works in iterations, each taked the next initial guess and find the
    % optimal motion parameters. then inserts it and the compatible events
    % into events_sets

    %event_sets {n_ietraion*2} each row is new iteration,
        %1th column is the events, 2nd column is the optimal velocity (motion parameters)
    expected_object_num = length(initial_velocities);

    events_sets = {1, 1};
    classified_events_count = 0;
    unclassified_events = events;
    sets_num = 1;
    for i=1:max_iterations_num
        if classified_events_count >= stop_percentage/100*length(events)
            n_iterations = i-1;
            break
        end
        n_iterations = i;
        if loss_func == "Support area"
            initial_velocities(mod(i, expected_object_num)+1,:)
            [V_opt_i, contrast_opt] = fminsearch(@(x)Support_area(warp(unclassified_events,x,w,l), 1)...
                ,initial_velocities(mod(i, expected_object_num)+1,:));
            V_opt_i
        elseif loss_func == "Contrast" 
            initial_velocities(mod(i, expected_object_num)+1,:)
            [V_opt_i, contrast_opt] = fminsearch(@(x)-1*Contrast(warp(unclassified_events,x,w,l), w,l)...
                ,initial_velocities(mod(i, expected_object_num)+1,:));
        end
        [new_classified_events, unclassified_events] = thresholding(unclassified_events, V_opt_i, w, l,...
            thersh_percentile-10*floor((i-1)/2), kernel_size, enlarge_factor); 
        % only events which are warped to bright pixels are classified (in each ietration)
        % bright pixels are defiend in thersholding function
        
        events_sets{sets_num, 1}  = new_classified_events;
        events_sets{sets_num, 2} = V_opt_i;
        classified_events_count = classified_events_count + length(new_classified_events);
        sets_num = sets_num + 1;
    end
end