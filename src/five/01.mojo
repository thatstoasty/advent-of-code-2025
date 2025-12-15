@fieldwise_init
@register_passable("trivial")
struct Bounds:
    var start: Int
    var finish: Int


fn is_in_bounds(num: Int, bounds: Span[Bounds]) -> Int:
    for bound in bounds:
        if bound.start <= num <= bound.finish:
            return 1
    return 0


fn main() raises:
    var data: String
    with open("data/05.txt", "r") as file:
        data = file.read()
    var lines = data.split("\n\n")
    var ranges = lines[0].splitlines()
    var ids = lines[1].splitlines()

    var bounds = List[Bounds](capacity=len(ranges))
    for rng in ranges:
        var parts = rng.split("-")
        bounds.append(Bounds(start=Int(parts[0]), finish=Int(parts[1])))

    var result = 0
    for id in ids:
        var num = Int(id)
        result += is_in_bounds(num, bounds)

    print("Fresh:", result)
