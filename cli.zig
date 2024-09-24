const std = @import("std");
const streql = std.mem.eql;
const files = @import("files.zig");

pub fn getArgs(cmd: []const u8) ![2][]const u8 {
    var arr: [2][]const u8 = undefined;
    var list1 = std.ArrayList(u8).init(std.heap.page_allocator);
    var list2 = std.ArrayList(u8).init(std.heap.page_allocator);
    defer list1.deinit();
    defer list2.deinit();
    var count: u8 = 0;
    for (cmd) |s| {
        if (s != ' ' and count == 0) {
            try list1.append(s);
        }
        if (s == ' ') {
            count = 1;
        }
        if (s != ' ' and count == 1) {
            try list2.append(s);
        }
    }
    arr[0] = try list1.toOwnedSlice();
    arr[1] = try list2.toOwnedSlice();
    return arr;
}
// retourne le currDir a chaque appel de la fonction
// ou uniquement quand cd
pub fn process(curr_path: *[]u8, args: [2][]const u8) !void {
    if (streql(u8, args[0], "del")) try files.deleteFileInDir(".", args[1]);
    if (streql(u8, args[0], "list")) try files.listFiles(curr_path.*);
    if (streql(u8, args[0], "exit")) std.process.exit(1);
    if (streql(u8, args[0], "pwd")) std.debug.print("curr path {s} \n", .{curr_path.*});
    if (streql(u8, args[0], "cd")) {
        curr_path.* = try files.changeDir(args[1]);
    }
    // else std.debug.print("unknown command {s}\n", .{args[0]});
}
