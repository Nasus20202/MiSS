% [x1, y1, x2, y2]
allowed = [
    [2, 3, 8, 3];
    [9, 3, 15, 3];
];
forbidden = [
    [5, 4, 5, 5];
    [12, 4, 12, 5];
];

v0_range = [0, 15];
alpha_range = [0, 90];
repeat = 100000;
g = 10;
rng('default');

v0 = random_mat(repeat, v0_range);
alpha = random_mat(repeat, alpha_range);

v0x = v0 .* cosd(alpha);
v0y = v0 .* sind(alpha);

is_passing_through_all_allowed = true(repeat, 1);
is_passing_through_any_forbidden = false(repeat, 1);
for i = 1:size(allowed, 1)
    is_passing_through_all_allowed = is_passing_through_all_allowed & ...
        is_passing_through_line(v0x, v0y, allowed(i, :), g);
end
for i = 1:size(forbidden, 1)
    is_passing_through_any_forbidden = is_passing_through_any_forbidden | ...
        is_passing_through_line(v0x, v0y, forbidden(i, :), g);
end

results = is_passing_through_all_allowed & ~is_passing_through_any_forbidden;

figure; hold on; grid on;
title("v0 / alpha"); xlabel("alpha"); ylabel("v0");
plot(alpha(results == 1), v0(results == 1), '.');
theme(gcf, "light");
saveas(gcf, 'zad1.png');

figure; hold on; grid on;
title("wykres 5 rzutów"); xlabel("x"); ylabel("y");
for allowed = allowed'
    plot(allowed([1, 3]), allowed([2, 4]), 'g', 'LineWidth', 2, 'DisplayName', 'allowed');
end
for forbidden = forbidden'
    plot(forbidden([1, 3]), forbidden([2, 4]), 'r', 'LineWidth', 2, 'DisplayName', 'forbidden');
end
idx = find(results, 5);
for i = idx'
    t_end = 2 * v0y(i) / g;
    t = linspace(0, t_end, 500);
    x = v0x(i) * t;
    y = v0y(i) * t - g / 2 * t.^2;
    plot(x, y, 'DisplayName', sprintf("v0=%.2f, alpha=%.2f", v0(i), alpha(i)));
end
legend show;
theme(gcf, "light");
saveas(gcf, 'zad2.png');

probability = sum(results) / repeat;
fprintf("Probability: %.4f\n", probability);

function random_mat = random_mat(size, range)
    random_mat = rand(size, 1) * (range(2) - range(1)) + range(1);
end

function is_passing = is_passing_through_line(v0x, v0y, line, g)
    x1 = line(1); y1 = line(2); x2 = line(3); y2 = line(4);
    line_a = (y2 - y1)/(x2 - x1);

    if x1 == x2
        y = v0y ./ v0x * x1 - g ./ (2 * v0x.^2) * x1^2;
        is_passing = (y >= min(y1, y2) & (y <= max(y1, y2)));
        return
    end

    a = -g ./ (2 * v0x.^2);
    b = v0y ./ v0x - line_a;
    c = x1 * line_a - y1;

    delta = b.^2 - 4 * a * c;
    sqrt_delta = sqrt(max(delta, 0));
    root1 = (-b + sqrt_delta) ./ (2 * a);
    root2 = (-b - sqrt_delta) ./ (2 * a);
    
    min_x = min(x1, x2);
    max_x = max(x1, x2);

    is_passing = delta >= 0 & (root1 >= min_x & root1 <= max_x) | (root2 >= min_x & root2 <= max_x);
end
