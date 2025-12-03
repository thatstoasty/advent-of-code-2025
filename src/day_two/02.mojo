import testing
from algorithm import parallelize


fn check_repeated_substring(block_size: Int, num: String, mut result: Int) raises -> Bool:
    """Check if all substrings of size block_size in num are identical.

    Args:
        block_size: The size of each substring block.
        num: The number string to check.
        result: The cumulative result to update if a match is found.

    Returns:
        True if all substring blocks are identical, False otherwise.
    """
    var blocks = len(num) // block_size
    for block in range(1, blocks):
        # Check if the first substring block matches the each substring block.
        # If any block does not match, we can break early.
        if num[0:block_size] != num[block * block_size : (block + 1) * block_size]:
            return False
        
        # If we complete the loop without breaking, we found a match.
        if block == blocks - 1:
            result += Int(num)
            return True

    return False


fn scan_number(number: Int, mut result: Int) raises:
    var num = String(number)
    for i in [2, 3, 4, 5]:
        if len(num) % i == 0 and check_repeated_substring(len(num) // i, num, result):
            return
    
    var num_bytes = num.as_bytes()
    for i in range(len(num)):
        if num_bytes[0] != num_bytes[i]:
            break
        if i == len(num) - 1:
            result += Int(num)


fn main() raises:
    var data: String
    with open("data/02.txt", "r") as file:
        data = file.read()

    var result = 0
    for ids in data.split(","):
        var bounds = ids.split("-")
        var start = Int(bounds[0])
        var end = Int(bounds[1]) + 1 # Range we check is inclusive
        for number in range(start, end):
            if number < 10:
                continue
            scan_number(number, result)

    print("Result:", result)
