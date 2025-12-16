from algorithm.reduction import product, sum


comptime PLUS = "+".as_bytes()[0]
comptime MULT = "*".as_bytes()[0]


fn construct_number[origin: Origin](numbers: Span[StringSlice[origin]], i: Int) raises -> Int:
    """Traverse through a cell column and construct the number by concatenating digits.

    Args:
        numbers: The lines of the table as strings.
        i: The column index to construct the number from.

    Returns:
        The constructed integer from the column.
    """
    var temp = ""
    for row in range(len(numbers)):
        # If we hit an empty cell, stop constructing the number.
        if numbers[row][i] == "":
            break

        temp.write(numbers[row][i])

    return Int(temp)


fn main() raises:
    var data: String
    with open("data/06.txt", "r") as file:
        data = file.read()
    var lines = data.splitlines()

    # First operator is at index 0
    var operations_line = lines[-1]
    var operations: List[String] = [operations_line[0]]

    # We want to determine the width of each cell before we start constructing numbers
    var cell_widths: List[Int] = []
    var cell_width = 0
    var bytes = operations_line.as_bytes()
    for i in range(1, len(bytes)):  # skip first operator at 0 index
        if bytes[i] in [PLUS, MULT]:
            cell_widths.append(cell_width)
            cell_width = 0
            operations.append("+") if bytes[i] == PLUS else operations.append("*")
            continue

        cell_width += 1

    cell_widths.append(cell_width + 1)  # append last cell width
    var numbers = lines[:-1]
    var constructed_numbers: List[List[Int64]] = []
    var start = 0
    for width in cell_widths:
        var cell_numbers: List[Int64] = []
        for i in range(width):
            cell_numbers.append(construct_number(numbers, i + start))
        constructed_numbers.append(cell_numbers^)
        start += width + 1

    var result: Int64 = 0
    for i in range(len(constructed_numbers)):
        if operations[i] == "*":
            result += product(constructed_numbers[i])
        else:
            result += sum(constructed_numbers[i])

    print("Result", result)
