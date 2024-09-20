const expect = std.testing.expect;
const print = std.debug.print;
const std = @import("std");
const files = @import("files.zig");

test "list files" {
    try files.listFiles();
    try files.FilesWeigth();
}
