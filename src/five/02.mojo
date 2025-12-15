from collections import Set


@fieldwise_init
@register_passable("trivial")
struct Bounds(Copyable, Representable, Writable):
    var start: Int
    var finish: Int

    fn __lt__(self: Self, other: Self) -> Bool:
        return self.start < other.start

    fn __gt__(self: Self, other: Self) -> Bool:
        return self.start > other.start

    fn write_to[W: Writer, //](self: Self, mut writer: W):
        writer.write("Bounds(", self.start, ", ", self.finish, ")")

    fn __str__(self: Self) -> String:
        return String.write(self)

    fn __repr__(self: Self) -> String:
        return String.write(self)


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

    var bounds = List[Bounds](capacity=len(ranges))
    for rng in ranges:
        var parts = rng.split("-")
        bounds.append(Bounds(Int(parts[0]), Int(parts[1])))

    fn sort_bounds(a: Bounds, b: Bounds) capturing -> Bool:
        if a.start < b.start:
            return True
        return False

    sort[sort_bounds](bounds)

    fn merge_ranges(b: List[Bounds]) -> Tuple[List[Bounds], Int]:
        var ranges_merged = 0
        var new_bounds = List[Bounds](capacity=len(b))
        var i = 0
        while i < len(b):
            print(b[i])
            if i < len(b) - 1:
                if b[i + 1].start <= b[i].finish:
                    if b[i + 1].finish <= b[i].finish:
                        new_bounds.append(b[i])
                    else:
                        new_bounds.append(Bounds(b[i].start, b[i + 1].finish))
                    ranges_merged += 1
                    i += 2
                else:
                    new_bounds.append(b[i])
                    i += 1
            else:
                new_bounds.append(b[i])
                i += 1

        return new_bounds^, ranges_merged

    var final_bounds = bounds.copy()
    while True:
        var result = merge_ranges(final_bounds)
        final_bounds = result[0].copy()
        if result[1] == 0:
            break

    var reduced_ranges = List[Bounds](capacity=len(final_bounds))
    for bound in final_bounds:
        var magnitude = bound.finish - bound.start
        reduced_ranges.append(Bounds(0, magnitude))

    print("\nReduced Ranges:")
    var result = 0
    for bound in reduced_ranges:
        print(bound)
        result += bound.finish + 1

    print("Fresh:", result)
