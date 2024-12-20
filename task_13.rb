line_counter = 0
da_1 = 0
db_1 = 0
da_2 = 0
db_2 = 0
a = 0
b = 0

cost1 = 0
cost2 = 0

def find_cost(da_1, db_1, da_2, db_2, a, b)
    # da_1 * x + da_2 * y = a
    # db_1 * x + db_2 * y = b

    # db_1*da_1*x + db_1*da_2*y = db_1*a
    # da_1*db_1*x + da_1*db_2*y = da_1*b

    # y = (db_1*a - da_1*b) / (db_1*da_2 - da_1*db_2)
    y_num = db_1*a - da_1*b
    y_denom = db_1*da_2 - da_1*db_2

    if y_denom == 0
        puts "Error: y denominator is 0"
    else
        if y_num % y_denom == 0
            y = y_num / y_denom
            if y > 0
                x_num = a - da_2 * y
                x_denom = da_1
                if x_num % x_denom == 0
                    x = x_num / x_denom
                    if x > 0
                        # puts "\tsol: x=%d y=%d" % [x,y]

                        return x*3 + y;
                    end
                end
            end
        end
    end
    
    return 0
end

File.open("input/13.txt", "r") do |f|
    f.each_line do |line|
        if line.length > 2
            # puts line_counter
            # puts line
            
            if line_counter % 3 == 0
                offsets = line.sub(/Button A: X\+/, '').sub(/, Y\+/, ' ').split(' ')
                da_1 = Integer(offsets[0])
                db_1 = Integer(offsets[1])
            elsif line_counter % 3 == 1
                offsets = line.sub(/Button B: X\+/, '').sub(/, Y\+/, ' ').split(' ')
                da_2 = Integer(offsets[0])
                db_2 = Integer(offsets[1])
            elsif line_counter % 3 == 2
                goals = line.sub(/Prize: X=/, '').sub(/, Y=/, ' ').split(' ')
                a = Integer(goals[0])
                b = Integer(goals[1])
            end
            
            if line_counter % 3 == 2
                # puts "da_1=%d db_1=%d da_2=%d db_2=%d a=%d b=%d" % [da_1, db_1, da_2, db_2, a, b]
                
                cost1 += find_cost(da_1, db_1, da_2, db_2, a, b)
                cost2 += find_cost(da_1, db_1, da_2, db_2, a+10000000000000, b+10000000000000)
            end

            line_counter += 1
        end
    end

    puts "Task 1: %d" % cost1
    puts "Task 2: %d" % cost2
end