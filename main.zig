const std = @import("std");
const printer = @import("printer.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{">>: "});

    while (true) {
        const stdin = std.io.getStdIn().reader();
        var buffer: [1024]u8 = undefined;
        const user_input = try stdin.readUntilDelimiter(&buffer, '\n');
        const str = user_input[0 .. user_input.len - 1];
        const num = @as(u64, str[0]);
        _ = try printer.printArrow(num);
        _ = try stdout.write("\n>>: ");
    }
}

