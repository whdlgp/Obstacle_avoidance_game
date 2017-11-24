clear;
clc;

% Arduino with joystick Y axis, analog pin 1
ANALOG_PIN = 'A1';
% Arduino Com port number
COM_NUMBER = 'COM5';

%declare arduino joystick
joystick = arduino(COM_NUMBER, 'UNO');

%make random obstacle array
obstacle_number = 100;
obstacle = randi(9, 1, obstacle_number);

%make obstacle map that obstacle rocate
obstacle_start_point = 1;
obstacle_map = [obstacle(1) 0 0 0];
for i = 2 : obstacle_number
    obstacle_map = [obstacle_map obstacle(i) 0 0 0];
end

%declare window that will actually display and handle
display_obstacle = zeros(1,20);
obstacle_window = plot(display_obstacle, '*');
axis([0 20 0 10]);

%declare window that handle charactor
hold on;
chara = [5 5 5];
chara_window = plot(chara, '-');
set(chara_window, 'LineWidth',5);
hold off;

%flag for checking collision
collision = 0;

for i = 1 : obstacle_number*4
    %shift obstacles
    for j = 1 : 19
        display_obstacle(j) = display_obstacle(j + 1);
    end
    display_obstacle(20) = obstacle_map(obstacle_start_point);
    set(obstacle_window, 'Ydata', display_obstacle);
    
    obstacle_start_point = obstacle_start_point + 1;
    
    %move charactor
    joystick_y = readVoltage(joystick, ANALOG_PIN);
    chara = round([1 1 1] * (joystick_y/0.625 + 1));
    set(chara_window, 'Ydata', chara);
    
    %check collision
    if display_obstacle(2) == chara(2)
        collision = 1; 
    end
    
    if collision == 1
        fprintf('Obstacle collision! You Are Looser!');
        break;
    end
    
    pause(0.05);
end

close all;

clear joystick;
