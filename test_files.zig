const expect = std.testing.expect;
const print = std.debug.print;
const std = @import("std");
const files = @import("files.zig");

test "list files" {
    // C:\Users\Amélie\Desktop\Program
    try files.DirFileStat("c:\\Users\\Amélie\\Desktop\\Program");
}
