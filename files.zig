const std = @import("std");
const print = std.debug.print;

const fileError = error {
    extentionNotFound, 
}; 

pub fn listFiles() !void {
    const dir = try std.fs.cwd().openDir(".", .{ .iterate = true });
    var walker = try dir.walk(std.heap.page_allocator);
    defer walker.deinit();
    while (try walker.next()) |entry| {
        if (entry.path[0] == '.') continue;
        print("{s}\n", .{entry.path});
    }
}



pub fn extractExtention(str: []const u8) fileError![] const u8 {
    var i = str.len - 1;
    while (i > 0) {
        if (str[i] == '.') {
            return str[i..];
        }
        i -= 1;
    }
    return fileError.extentionNotFound;
}


pub fn makeDir(str: []const u8) !void {
    try std.fs.cwd().makeDir(str); 
}


pub fn deleteDir(str: []const u8) !void {
    try std.fs.cwd().deleteTree(str); 
}