const std = @import("std");
const cli = @import("cli.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const allocator = std.heap.page_allocator;
    var curr_path = try std.fs.cwd().realpathAlloc(allocator, ".");
    while (true) {
        try stdout.print("{s}", .{">>: "});
        const stdin = std.io.getStdIn().reader();
        var buffer: [1024]u8 = undefined;
        const user_input = try stdin.readUntilDelimiter(&buffer, '\n');
        const str = user_input[0 .. user_input.len - 1];
        const args = try cli.getArgs(str);
        _ = try cli.process(&curr_path, args);
        try stdout.print("{s} \n", .{curr_path});
    }
}
