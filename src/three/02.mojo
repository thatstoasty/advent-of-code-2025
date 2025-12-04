from algorithm import parallelize


fn parse_highest_joltage[
    origin: ImmutOrigin
](line: StringSlice[origin], start: Int, reserved: Int, mut result: String) -> Int:
    """Parse the highest joltage from the given line.

    The iteration over the line starts at `start`, and goes until the length of the line minus
    `reserved`. For example, for the first pass, we reserve the final 11 digits because the full joltage
    is 12 digits long. Each recursive call reduces the reserved count by 1 until it reaches 0.

    Args:
        line: The line string slice to parse.
        start: The starting index to begin parsing from.
        reserved: The number of digits to reserve for future calls.
        result: The cumulative result string to write the highest joltage into.

    Returns:
        The index of the highest joltage digit found.
    """
    var idx = 0
    var value = "0"
    for i in range(start, len(line) - reserved):
        if line[i] > value:
            idx = i
            value = line[i]
    result.write(line[idx])
    if reserved != 0:
        return parse_highest_joltage(line, idx + 1, reserved - 1, result)
    return idx


fn main() raises:
    var data: String
    with open("data/03.txt", "r") as file:
        data = file.read()
    var lines = data.splitlines()

    # This function is used to parse the highest joltage for each line in parallel.
    # We write the resultant joltage as a String into a result list to convert and sum later.
    var results = List[String](fill="", length=len(lines))

    fn process_line(idx: Int) capturing:
        var result = String(capacity=12)
        _ = parse_highest_joltage(lines[idx], 0, 11, result)
        results[idx].write(result)

    parallelize[process_line](len(lines))
    var result = 0
    for r in results:
        result += Int(r)
    print(result)
