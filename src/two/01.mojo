fn main() raises:
    var data: String
    with open("data/02.txt", "r") as file:
        data = file.read()

    var result = 0
    for ids in data.split(","):
        var bounds = ids.split("-")
        for number in range(Int(bounds[0]), Int(bounds[1]) + 1):
            var num = String(number)

            # Uneven numbers can't have a repeated block of numbers.
            if len(num) % 2 != 0:
                continue
            
            # Check if the first half matches the second half. If so, cast back to Int and add to result.
            var middle = len(num) // 2
            if num[0:middle] == num[middle:]:
                result += Int(num)
