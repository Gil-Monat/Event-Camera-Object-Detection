function  [support_area, support_map]  = Support_area(warp_frame, lambda_0)
    %This function caclulates the support area and support map of an image
    
    % With F(x) = 1-e^-x
    support_map = (1 - exp(-warp_frame./lambda_0)) - (1 - exp(0));
    support_area = sum(support_map, 'all');
end