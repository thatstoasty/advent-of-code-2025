from algorithm import parallelize

fn main() raises:
    var data: String
    with open("data/03.txt", "r") as file:
        data = file.read()
    var lines = data.splitlines()

    var results = List[String](fill="", length=len(lines))
    fn process_line(idx: Int) capturing:
        var result = String(capacity=2)
        var left = 0
        for i in range(len(lines[idx]) - 1):
            if lines[idx][i] > lines[idx][left]:
                left = i
        result.write(lines[idx][left])

        var right = left + 1
        for i in range(left + 1, len(lines[idx])):
            if lines[idx][i] > lines[idx][right]:
                right = i
        result.write(lines[idx][right])
        results[idx] = (result)

    parallelize[process_line](len(lines))
    var result = 0
    for r in results:
        result += Int(r)
    print(result)
