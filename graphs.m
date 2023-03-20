% This code gives the graphs in our report.
% It shows how to use the algorithm
close all;
%% Loading "Cars_sequence.mat"
close all;
clear all;

load("Cars_sequence.mat")
x = davis.dvs.x;
y = davis.dvs.y;
p = davis.dvs.p;
ts = davis.dvs.t;
w = double(davis.size(1));%set to change for our videos
l = double(davis.size(2));% in our camera 640x480
events = [x,y,p,ts];

time_of_frame = 0.02;
start_time = 1; 

events = events((events(:,4) >= start_time), :);
events = events((events(:,4) < start_time+time_of_frame), :);
events = hot_pixel_denoising(events, w , l , 1);
%% Loading 'rolling pass_cd_filtered.mat'
close all;
clear;
load('rolling pass_cd_filtered.mat')
x = tdData.x;
y = tdData.y;
p = tdData.p;
ts = tdData.ts;

A = struct2cell(mov);
B = A{:,:,2};
size_of_B = size(B);
w = double(size_of_B(2));%set to change for our videos
l = double(size_of_B(1));
events = [x,y,p,ts];
start_time = 4052640;
time_of_frame = 48250;

events = events((events(:,4) >= start_time), :);
events = events((events(:,4) < start_time+time_of_frame), :);
events = hot_pixel_denoising(events, w , l , 1);

%% Loading 'drop_and_roll_cut_cd_filtered.mat'
close all;
clear all;
load('drop_and_roll_cut_cd_filtered.mat')
x = tdData.x;
y = tdData.y;
p = tdData.p;
ts = tdData.ts;

A = struct2cell(mov);
B = A{:,:,2};
size_of_B = size(B);
w = double(size_of_B(2));%set to change for our videos
l = double(size_of_B(1));
events = [x,y,p,ts];
start_time = 603783;
time_of_frame = 75601;

events = events((events(:,4) >= start_time), :);
events = events((events(:,4) < start_time+time_of_frame), :);
events= hot_pixel_denoising(events, w , l , 1);

%% Visualizing the events
figure();
scatter3(events(:,1), events(:,4), l-events(:,2), 0.1, '.');
xlabel("X");
ylabel("t");
zlabel("Y");
title("Events - car sequence 2");
view(18,18)
naive_WI = warp(events, [0,0], w, l);
figure();
imshow(naive_WI);
title("Naive warp image");


%% Graph of loss function in parameter space
% N = 100;
% axis_x = linspace(-400,400,N);
% axis_y = linspace(-400,400,N);
% 
% contrast2D = zeros(N);
% for i = linspace(1,N,N)
%    for j = linspace(1,N,N)
%        contrast2D(i,j) = -1*Contrast(warp(events,[axis_x(i),axis_y(j)],w,l),w,l);
%    end
% end 
% 
% figure();
% h = surf(axis_x,axis_y,contrast2D);
% xlabel('v_y')
% ylabel('v_x')
% zlabel('loss func')

%% Cars_sequence 1 - Best hyper parameters
% Start time = 0.25
% time of frame = 0.02

thersh_percentile = 18;%18
kernel_size = 25;%25
enlarge_factor = 20;%20
max_iterations_num = 8; % Does not affect the results, needs to big enough 
stop_percentage = 10;%90
radius = 30; %30
loss_function = "Contrast"; % "Support area" or "Contrast"


[events_sets, n_iteration] = objects_detection(events, w, l,loss_function,...
    [[-160, 0];[250, 0]], thersh_percentile, kernel_size, enlarge_factor,...
    max_iterations_num, stop_percentage);

grouped_sets = group_sets(events_sets, radius);
figure();
legends = cell(1,length(grouped_sets));
for i = 1:length(grouped_sets)
    scatter3(grouped_sets{i, 1}(:,1), grouped_sets{i, 1}(:,4),...
        l-grouped_sets{i, 1}(:,2),0.1,'.');
    if ~isequal(grouped_sets{i,2}, "rest")
        legends{1,i} = sprintf("v=[%0.5f,%0.5f]", grouped_sets{i,2}(1), grouped_sets{i,2}(2));
    elseif isequal(grouped_sets{i,2}, "rest")
        legends{1,i} = "rest";
    end
    set(gca,'XLim',[0 w],'ZLim',[0 l], 'YLim',...
        [start_time time_of_frame+start_time])
    hold on;
end
legend(legends,'location','best')
title("tagged events by objects - cars sequence 1 - radius 30")
xlabel("x")
ylabel("t")
zlabel("y")
view(18,18)
%% Cars_sequence 2 -  Best hyper parameters
% Start time = 1
% time of frame = 0.02

thersh_percentile = 5;%18
kernel_size = 23;%23
enlarge_factor = 25;%25
max_iterations_num = 6; % Does not affect the results, needs to big enough 
stop_percentage = 90;%90 
radius = 30;%30
loss_function = "Contrast"; % "Support area" or "Contrast"


[events_sets, n_iteration] = objects_detection(events, w, l,loss_function,...
    [[-160, 0];[250, 0]], thersh_percentile, kernel_size, enlarge_factor,...
    max_iterations_num, stop_percentage);

grouped_sets = group_sets(events_sets, radius);
figure();
legends = cell(1,length(grouped_sets));
for i = 1:length(grouped_sets)
    scatter3(grouped_sets{i, 1}(:,1), grouped_sets{i, 1}(:,4),...
        l-grouped_sets{i, 1}(:,2),0.01, '.');
    if ~isequal(grouped_sets{i,2}, "rest")
        legends{1,i} = sprintf("v=[%0.5f,%0.5f]", grouped_sets{i,2}(1), grouped_sets{i,2}(2));
    elseif isequal(grouped_sets{i,2}, "rest")
        legends{1,i} = "rest";
    end
    set(gca,'XLim',[0 w],'ZLim',[0 l], 'YLim',...
        [start_time time_of_frame+start_time])
    hold on;
end
legend(legends,'location','best')
title("tagged events by objects - cars sequence 2 - radius 30px")
xlabel("x")
ylabel("t")
zlabel("y")
view(18,18)
%% rolling pass_cd_filtered - Best hyper parameters
% Start time = 4052640
% Time of frame = 48250

thersh_percentile = 50; %50
kernel_size = 30; %20
enlarge_factor = 120; %40
max_iterations_num = 5; % 5 % Does not affect the results, needs to big enough 
stop_percentage = 60; %60
radius =8e-4; %8e-4
loss_function = "Contrast"; % "Support area" or "Contrast"


[events_sets, n_iteration] = objects_detection(events, w, l,loss_function,...
    [[-0.0011, -2.1805e-4];[5.2202e-4, 2.6076e-04]], thersh_percentile, kernel_size, enlarge_factor,...
    max_iterations_num, stop_percentage);

grouped_sets = group_sets(events_sets, radius);
figure();
legends = cell(1,length(grouped_sets));
for i = 1:length(grouped_sets)
    scatter3(grouped_sets{i, 1}(:,1), grouped_sets{i, 1}(:,4),...
        l-grouped_sets{i, 1}(:,2), 0.001,  '.');
    if ~isequal(grouped_sets{i,2}, "rest")
        legends{1,i} = sprintf("v=[%0.5f,%0.5f]", grouped_sets{i,2}(1), grouped_sets{i,2}(2));
    elseif isequal(grouped_sets{i,2}, "rest")
        legends{1,i} = "rest";
    end
    set(gca,'XLim',[0 w],'ZLim',[0 l], 'YLim',...
        [start_time time_of_frame+start_time])
    hold on;
end
legend(legends,'location','best')
title("tagged events by objects - rolling pass - (kernel size,enlarge factor)=(30,120)")
xlabel("x")
ylabel("t")
zlabel("y")
view(18,18)
%% drop_and_roll_cut_cd_filtered - Best hyper parameters
% Start time = 603783
% Time of frame = 75601

thersh_percentile = 60; %60
kernel_size = 30; %15
enlarge_factor = 120; %30
max_iterations_num = 8; % Does not affect the results, needs to big enough 
stop_percentage = 50; %50 
radius =8e-4; %8e-4
loss_function = "Contrast"; % "Support area" or "Contrast"


[events_sets, n_iteration] = objects_detection(events, w, l,loss_function,...
    [[-0.001, 0];[3.9085e-4, 0.002]], thersh_percentile, kernel_size, enlarge_factor,...
    max_iterations_num, stop_percentage);

grouped_sets = group_sets(events_sets, radius);
figure();
legends = cell(1,length(grouped_sets));
for i = 1:length(grouped_sets)
    scatter3(grouped_sets{i, 1}(:,1), grouped_sets{i, 1}(:,4),...
        l-grouped_sets{i, 1}(:,2),0.001, '.');
    if ~isequal(grouped_sets{i,2}, "rest")
        legends{1,i} = sprintf("v=[%0.5f,%0.5f]", grouped_sets{i,2}(1), grouped_sets{i,2}(2));
    elseif isequal(grouped_sets{i,2}, "rest")
        legends{1,i} = "rest";
    end
    set(gca,'XLim',[0 w],'ZLim',[0 l], 'YLim',...
        [start_time time_of_frame+start_time])
    hold on;
end
legend(legends,'location','best')
title("tagged events by objects - drop and roll -radius 8e-6%")
xlabel("x")
ylabel("t")
zlabel("y")
view(18,18)