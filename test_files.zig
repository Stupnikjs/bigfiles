const expect = std.testing.expect;
const print = std.debug.print;
const std = @import("std");
const files = @import("files.zig");

test "list files" {
    // try files.FilesWeigth("C:\\Users\\nboud\\downloads");
    const biggest = try files.BiggestFile("c:\\Users\\nboud\\OneDrive\\Bureau\\CloudSave\\Vente\\Notaire");
    print("biggest file is {s}", .{biggest.name});
}
