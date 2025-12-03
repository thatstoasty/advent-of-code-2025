import testing

fn check_adjustment_outcome(line: StringSlice, mut position: Int) raises -> Bool:
    var direction = -1 if line[0] == "L" else 1
    var magnitude = Int(line[1:])
    var adjustment = direction * magnitude

    var loop_offset = 0
    var projected_position = position + adjustment
    if projected_position < 0:
        loop_offset = 100 * Int(abs(round(projected_position / 100)))
    elif projected_position >= 100:
        loop_offset = -100 * Int(abs(round(projected_position / 100)))

    position += adjustment + loop_offset
    if position == 0:
        return True
    
    return False


fn evaluate_data(data: String) raises -> Int:
    var position = 50
    var counter = 0
    for line in data.splitlines():
        if check_adjustment_outcome(line.strip(), position):
            counter += 1
        
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
    testing.assert_equal(evaluate_data(test_data), 3)


fn test_day_01_long_spin() raises:
    test_data = """L68
L30
R48
R600
L1117
"""
    testing.assert_equal(evaluate_data(test_data), 2)


fn run_day_01() raises:
    var position = 50
    var counter = 0
    with open("data/01.txt", "r") as file:
        for line in file.read().splitlines():
            if check_adjustment_outcome(line.strip(), position):
                counter += 1

    print("Result:", counter)


fn main() raises:
    test_day_01()
    test_day_01_long_spin()
    run_day_01()