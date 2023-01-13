function [final_sets] = group_sets(events_sets, radius)
    %This function groups the event sets we identified in object_detection.
    %Sets with similiar velocities will be grouped together

    %radius is the maximal euclidean distance we merge two different sets

   V = zeros(length(events_sets), 2);
   for i = 1:length(events_sets)
       V(i,:) = events_sets{i,2};
       events_sets{i , 3} = 0;
   end
   events_sets{1,3} = 1; %events_sets{:,3} is a mark to the final set

   final_sets_num = 1;
    for i = 1:length(events_sets)
        for j = 2:length(events_sets)
            if j ~= i
               if norm(V(i) - V(j)) < radius && events_sets{j, 3} == 0 %in case of merging sets
                events_sets{j, 3} = min(i ,j);
                final_sets_num = min(i ,j);
               end
            end
        end
    end

    for k = 1:length(events_sets)
        if events_sets{k , 3} == 0 %sets that havn't merged
            events_sets{k ,3} = k;
            final_sets_num = k;
        end
    end
    %now we have marked the events sets to the new and merged sets
    final_sets = cell(final_sets_num, 2);

    % making the new sets
    V_final = zeros(size(V));
    for ii = 1:final_sets_num
        for jj = 1:length(events_sets)
            if events_sets{jj , 3} == ii 
                final_sets{ii, 1} = vertcat(final_sets{ii,1}, events_sets{jj , 1});
                V_final(ii, :) = V_final(ii,:) + events_sets{jj, 2} * length(events_sets{jj , 1});
                events_sets{jj, 3} = -1; %this set marked as used
            end
        end
    end
    %normalize the velocities of final sets
    for kk = 1:final_sets_num
        final_sets{kk, 2} = V_final(kk,:) / length(final_sets{kk , 1});
    end

 end



