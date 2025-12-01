import testing
import math

fn check_adjustment_outcome(line: StringSlice, mut position: Int) raises -> Int:
    var increment_by = 0
    var direction = -1 if line[0] == "L" else 1
    var magnitude = Int(line[1:])
    var adjustment = direction * magnitude

    var loop_offset = 0
    var projected_position = position + adjustment
    if projected_position < 0:
        var loops = max(1, Int(math.ceil(abs(projected_position / 100))))
        increment_by += (loops - 1) if position == 0 else loops
        loop_offset = 100 * loops
    elif projected_position >= 100:
        var loops = max(1, Int(math.floor(abs(projected_position / 100))))
        if projected_position != 100:
            increment_by += loops
        loop_offset = -100 * loops
        if position + adjustment + loop_offset == 0 and increment_by > 0:
            increment_by -= 1
        
    position += adjustment + loop_offset
    if position == 0:
        increment_by += 1
    
    return increment_by


fn evaluate_data(data: String) raises -> Int:
    var position = 50
    var counter = 0
    for line in data.splitlines():
        counter += check_adjustment_outcome(line.strip(), position)
        
    return counter


fn test_day_01() raises:
    var test_data = """L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""
    testing.assert_equal(evaluate_data(test_data), 6)


fn test_day_01_long_spin() raises:
    test_data = """L68
L30
R48
R600
L1117
"""
    testing.assert_equal(evaluate_data(test_data), 19)


fn run_day_01() raises:
    with open("data/01.txt", "r") as file:
        print("Result:", evaluate_data(file.read()))


fn main() raises:
    test_day_01()
    test_day_01_long_spin()
    run_day_01()