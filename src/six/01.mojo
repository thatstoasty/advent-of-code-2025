from algorithm.reduction import product, sum


@fieldwise_init
struct Table(Writable):
    var data: List[List[Int64]]

    fn write_to[W: Writer](self, mut writer: W):
        for row in self.data:
            writer.write(row.__str__(), "\n")

    fn transpose(mut self):
        if not self.data:
            return

        var transposed = List[List[Int64]](capacity=len(self.data[0]))
        for i in range(len(self.data[0])):
            var values = List[Int64](capacity=len(self.data))
            for j in range(len(self.data)):
                values.append(self.data[j][i])
            transposed.append(values^)

        self.data = transposed^


fn main() raises:
    #     var data = """123 328  51 64
    #  45 64  387 23
    #   6 98  215 314
    # *   +   *   +"""
    var data: String
    with open("data/06.txt", "r") as file:
        data = file.read()
    data = data.replace("    ", " ").replace("   ", " ").replace("  ", " ")
    var lines = data.splitlines()
    var table_data = List[List[Int64]](capacity=len(lines))
    for line in lines[:-1]:
        var values = line.strip().split(" ")
        var values_stripped = [Int64(Int(value.strip())) for value in values]
        table_data.append(values_stripped^)

    var table = Table(table_data^)
    table.transpose()

    var operations = lines[-1].replace(" ", "").split("")[1:-1]
    print(operations.__str__())
    # Fold/Reduce each vector
    var result: Int64 = 0
    for i in range(len(table.data)):
        ref operation = operations[i]
        if operation == "+":
            var s = sum(table.data[i])
            print("sum reduce", s)
            result += s
        else:
            var m = product(table.data[i])
            print("mult reduce", m)
            result += m

    print("Final result:", result)
