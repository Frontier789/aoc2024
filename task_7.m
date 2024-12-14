lines = readlines("input/7.txt");
lines = lines(1:end-1);

function n = cat(a, b)
    a_str = num2str(a, 100);
    b_str = num2str(b, 100);
    catted = strcat(a_str, b_str);
    n = str2double(catted);
end

function possible = check(target, value, nums, allow_concat)
    if isempty(nums)
        possible = target == value;
        return
    end

    next = nums(1);

    if (value + next > target) && (value * next > target) && (~allow_concat || cat(value, next) > target)
        possible = 0;
        return
    end

    tail = nums(2:end);
    
    if check(target, value + next, tail, allow_concat)
        possible = 1;
        return
    end
    
    if check(target, value * next, tail, allow_concat)
        possible = 1;
        return
    end
    
    if allow_concat && check(target, cat(value, next), tail, allow_concat)
        possible = 1;
        return
    end

    possible = 0;
end

sum1 = 0;
sum2 = 0;

parfor i = 1:length(lines)
    nums = split(lines(i));
    target = nums{1};
    target = str2double(target(1:end-1));

    nums = nums(2:end);
    nums = str2double(nums);
    
    % disp(nums)

    if check(target, nums(1), nums(2:end), 0)
        sum1 = sum1+target;
    end

    if check(target, nums(1), nums(2:end), 1)
        sum2 = sum2+target;
    end
end

disp("Task 1: " + num2str(sum1, 100))
disp("Task 2: " + num2str(sum2, 100))