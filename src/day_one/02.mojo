import testing
import math


struct Direction:
    comptime LEFT: Int = -1
    comptime RIGHT: Int = 1


fn turn_left(mut position: UInt, magnitude: UInt, mut counter: UInt):
    """Handles turning the lock to the left (counterclockwise).

    Args:
        position: The current lock position.
        magnitude: The magnitude of the turn.
        counter: The counter tracking how many times we pass or land on 0.
    """
    var projected_position = Int(position) - Int(magnitude)
    if projected_position >= 0:
        position -= magnitude
        return

    # How many full loops of 100 did we do? If this function is being called, we know it's at least 1.
    var loops = UInt(max(1, Int(math.ceil(abs(projected_position / 100)))))
    counter += loops - 1 if position == 0 else loops
    position += loops * 100 # Offset to stay within 0-99 range.
    position -= magnitude


fn turn_right(mut position: UInt, magnitude: UInt, mut counter: UInt):
    """Handles turning the lock to the right (clockwise).

    Args:
        position: The current lock position.
        magnitude: The magnitude of the turn.
        counter: The counter tracking how many times we pass or land on 0.
    """
    var projected_position = position + magnitude
    if projected_position < 100:
        position += magnitude
        return

    # How many full loops of 100 did we do? If this function is being called, we know it's at least 1.
    var loops = UInt(max(1, Int(math.floor(abs(projected_position / 100)))))

    # Cover cases where we land exactly on 100, if it lands directly on 0/100 we can discount it.
    # Since landing on 0 does not count as passing 0.
    if projected_position != 100:
        counter += loops
    position -= loops * 100 # Offset to stay within 0-99 range.
    if position + magnitude == 0 and counter > 0:
        counter -= 1
        
    position += magnitude


fn check_adjustment_outcome[origin: ImmutOrigin](line: StringSlice[origin], mut position: UInt) raises -> UInt:
    """Scan the line and adjust the lock position. Tracks how many times we pass and land on 0.
    
    Args:
        line: The adjustment instruction.
        position: The current lock position.
    
    Returns:
        The number of times we pass or land on 0 during this line.
    """
    # The first character indicates direction, L for counterclockwise (-1), R for clockwise (+1).
    # The rest of the string is the magnitude of the adjustment.
    var magnitude = UInt(Int(line[1:]))

    # If we go below 0, we need to offset the negative result with the appropriate multiple of 100.
    # We use ceiling to ensure we NEVER have a negative position at the end.
    # If we go above or equal to 100, we need to offset the positive result with the appropriate negative multiple of 100.
    # We use floor to ensure we NEVER have a position >= 100 at the end.
    var counter: UInt = 0
    if line[0] == "L":
        turn_left(position, magnitude, counter)
    else:
        turn_right(position, magnitude, counter)
    
    if position == 0:
        counter += 1
    
    return counter


fn evaluate_data(data: String) raises -> UInt:
    var position: UInt = 50
    var counter: UInt = 0
    for line in data.splitlines():
        counter += check_adjustment_outcome(line.strip(), position)
        
    return counter


fn main() raises:
    with open("data/01.txt", "r") as file:
        print("Result:", evaluate_data(file.read()))
