% format [x1, y1, x2, y2] for each row
allowed = [
    [2, 1, 2, 4];
    [4, 1, 7, 1];
];
forbidden = [
    [3, 2, 3, 3];
];

v0_range = [0, 15];
alpha_range = [0, 90];
repeat = 100000;
g = 10;
rng('default'); % for reproducibility

v0 = random_mat(repeat, v0_range);
alpha = random_mat(repeat, alpha_range);

v0_x = v0 .* cosd(alpha);
v0_y = v0 .* sind(alpha);

allowed_ok = true(repeat, 1);
for j = 1:size(allowed, 1)
    % passes through all allowed lines
    allowed_ok = allowed_ok & ...
        is_passing_through_line(v0_x, v0_y, allowed(j, :), g);
end
forbidden_hit = false(repeat, 1);
for j = 1:size(forbidden, 1)
    % but not through any forbidden lines
    forbidden_hit = forbidden_hit | ...
        is_passing_through_line(v0_x, v0_y, forbidden(j, :), g);
end
result = allowed_ok & ~forbidden_hit;

% Chart of v0 versus alpha
figure; hold on; grid on;
plot(alpha(result == 1), v0(result == 1), '.');
title('v0 versus alpha'); ylabel('v0 [m/s]'); xlabel('alpha [degrees]');
saveas(gcf, 'zad1.png');

% Trajectories fulfilling the conditions
figure; hold on; grid on;
for region = 1:size(allowed, 1)
    plot(allowed(region, [1, 3]), allowed(region, [2, 4]), 'g', 'LineWidth', 3);
end
for region = 1:size(forbidden, 1)
    plot(forbidden(region, [1, 3]), forbidden(region, [2, 4]), 'r', 'LineWidth', 3);
end
idx = find(result, 5);
for i = idx'
    t_end = 2 * v0_y(i) / g;
    t = linspace(0, t_end, 300);
    plot(v0_x(i) * t, v0_y(i) * t - 0.5 * g * t.^2, 'LineWidth', 1.2);
end
title('Allowed (green) and forbidden (red) regions with trajectories');
ylabel('y'); xlabel('x');
saveas(gcf, 'zad2.png');

% Probability of passing for a single try
prob = sum(result) / length(result);
fprintf('Probability of passing for a single try: %.4f\n', prob);


function random_mat = random_mat(size, range)
    random_mat = rand(size, 1) * (range(2) - range(1)) + range(1);
end

function is_passing = is_passing_through_line(v0_x, v0_y, line, g)
    x1 = line(1); y1 = line(2);
    x2 = line(3); y2 = line(4);

    if x1 == x2 % vertical line
        % calculate y at x = x1 and check if it is between y1 and y2
        y = v0_y ./ v0_x * x1 - g ./ (2 * v0_x.^2) * x1^2;
        is_passing = (y >= min(y1, y2)) & (y <= max(y1, y2));
        return
    end

    % line: y = l_a * x + b
    l_a = (y2 - y1) / (x2 - x1);
    l_b = y1 - l_a * x1;

    % trajectory: 
    % x = v0_x * t
    % y = v0_y * t - 0.5 * g * t^2
    %
    % t = x / v0_x
    % y = v0_y * (x / v0_x) - 0.5 * g * (x / v0_x)^2
    % y = (v0_y / v0_x) * x - g/(2 * v0_x^2) * x^2
    % 
    % y = t_a * x ^ 2 + t_b * x + t_c
    t_a = -g ./ (2 * v0_x.^2);
    t_b = v0_y ./ v0_x;

    % l_a * x + l_b = t_a * x ^ 2 + t_b * x
    % 0 = t_a * x ^ 2 + (t_b - l_a) * x - l_b
    % 0 = a * x ^ 2 + b * x + c
    a = t_a;
    b = t_b - l_a;
    c = -l_b;
    D = b.^2 - 4 * a * c;

    % D < 0: no intersection
    sqrt_D = sqrt(max(D, 0)); % if D is negative, we should use 0
    root1 = (-b + sqrt_D) ./ (2 * a);
    root2 = (-b - sqrt_D) ./ (2 * a);
    x_min = min(x1, x2);
    x_max = max(x1, x2);
    is_passing = D >= 0 & (root1 >= x_min & root1 <= x_max) | (root2 >= x_min & root2 <= x_max);
end