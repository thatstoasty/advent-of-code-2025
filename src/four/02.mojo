from algorithm import parallelize


@fieldwise_init
struct Matrix:
    var data: List[List[String]]

    fn __init__(out self, *, capacity: Int):
        self.data = List[List[String]](capacity=capacity)

    fn row_count(self) -> Int:
        return len(self.data)

    fn column_count(self) -> Int:
        if not self.data:
            return 0
        return len(self.data[0])

    fn is_corner_node(self, row: Int, col: Int) -> Bool:
        if (
            (row == 0 and col == 0)
            or (row == self.row_count() - 1 and col == 0)
            or (row == 0 and col == self.column_count() - 1)
            or (row == self.row_count() - 1 and col == self.column_count() - 1)
        ):
            return True
        return False

    fn is_roll_accessible(self, row: Int, col: Int) raises -> Bool:
        if row > len(self.data):
            raise Error("Row is greater than row count of data.")

        if self.data[row][col] != "@":
            return False

        if self.is_corner_node(row, col):
            return True

        # Check top and bottom rows which only have 5 neighbors.
        var tp_count = 0
        if row == 0:
            if self.data[row][col - 1] == "@":
                tp_count += 1
            if self.data[row][col + 1] == "@":
                tp_count += 1
            if self.data[row + 1][col - 1] == "@":
                tp_count += 1
            if self.data[row + 1][col] == "@":
                tp_count += 1
            if self.data[row + 1][col + 1] == "@":
                tp_count += 1
        elif row == self.row_count() - 1:
            if self.data[row][col - 1] == "@":
                tp_count += 1
            if self.data[row][col + 1] == "@":
                tp_count += 1
            if self.data[row - 1][col - 1] == "@":
                tp_count += 1
            if self.data[row - 1][col] == "@":
                tp_count += 1
            if self.data[row - 1][col + 1] == "@":
                tp_count += 1
        elif col == 0:
            if self.data[row + 1][col] == "@":
                tp_count += 1
            if self.data[row - 1][col] == "@":
                tp_count += 1
            if self.data[row - 1][col + 1] == "@":
                tp_count += 1
            if self.data[row][col + 1] == "@":
                tp_count += 1
            if self.data[row + 1][col + 1] == "@":
                tp_count += 1
        elif col == self.column_count() - 1:
            if self.data[row + 1][col] == "@":
                tp_count += 1
            if self.data[row - 1][col] == "@":
                tp_count += 1
            if self.data[row - 1][col - 1] == "@":
                tp_count += 1
            if self.data[row][col - 1] == "@":
                tp_count += 1
            if self.data[row + 1][col - 1] == "@":
                tp_count += 1
        else:
            if self.data[row - 1][col - 1] == "@":
                tp_count += 1
            if self.data[row - 1][col] == "@":
                tp_count += 1
            if self.data[row - 1][col + 1] == "@":
                tp_count += 1
            if self.data[row][col - 1] == "@":
                tp_count += 1
            if self.data[row][col + 1] == "@":
                tp_count += 1
            if self.data[row + 1][col - 1] == "@":
                tp_count += 1
            if self.data[row + 1][col] == "@":
                tp_count += 1
            if self.data[row + 1][col + 1] == "@":
                tp_count += 1

        if tp_count >= 4:
            return False
        return True

    fn count_accessible_rolls(mut self) raises -> Int:
        var rolls_to_remove = List[Tuple[Int, Int]]()
        var total_rolls_removed = 0
        var accessible_rolls = 0

        while accessible_rolls > -1:
            accessible_rolls = 0
            for row in range(self.row_count()):
                for col in range(self.column_count()):
                    if self.is_roll_accessible(row, col):
                        accessible_rolls += 1
                        rolls_to_remove.append((row, col))

            if accessible_rolls == 0:
                break

            total_rolls_removed += accessible_rolls
            for coordinate in rolls_to_remove:
                self.data[coordinate[0]][coordinate[1]] = "."

        return total_rolls_removed


fn main() raises:
    var data: String
    with open("data/04.txt", "r") as file:
        data = file.read()
    var lines = data.splitlines()
    var matrix = Matrix(capacity=len(lines))
    for line in lines:
        matrix.data.append([String(node) for node in line.split("")[1:-1]])

    print(matrix.count_accessible_rolls())
