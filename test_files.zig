const expect = std.testing.expect;
const print = std.debug.print;
const std = @import("std");
const files = @import("files.zig");

test "list files" {
    // try files.FilesWeigth("C:\\Users\\nboud\\downloads");
    const biggest = try files.BiggestFile("C:\\Users\\nboud\\downloads");
    print("biggest file is {s}", .{biggest.name});
}
