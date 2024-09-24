const expect = std.testing.expect;
const print = std.debug.print;
const std = @import("std");
const files = @import("files.zig");

test "order files" {
    // C:\Users\Amélie\Desktop\Program
    const stats = try files.DirFileStat("c:\\Users\\Amélie\\Desktop\\Program\\gotube");
    const largest = try files.largestFile(stats);
    print("{s} \n", .{largest.name});
}
