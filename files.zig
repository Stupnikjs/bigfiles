const std = @import("std");
const print = std.debug.print;

const fileError = error{
    extentionNotFound,
};

const fileKind = enum {
    file,
    dir,
};
const fileStat = struct {
    kind: fileKind,
    name: []const u8,
    size: u64,
};

pub fn listFiles() !void {
    const dir = try std.fs.cwd().openDir(".", .{ .iterate = true });
    var walker = try dir.walk(std.heap.page_allocator);
    defer walker.deinit();
    while (try walker.next()) |entry| {
        if (entry.path[0] == '.') continue;
        print("{s}\n", .{entry.basename});
    }
}

pub fn DirFileStat(dir_path: []const u8) ![]fileStat {
    const list_al = std.heap.page_allocator;
    var list = std.ArrayList(fileStat).init(list_al);
    defer list.deinit();
    var dir = try std.fs.openDirAbsolute(dir_path, .{ .iterate = true });
    defer dir.close();
    var iter = dir.iterate();

    while (try iter.next()) |entry| {
        const pa = std.heap.page_allocator;
        const name = try std.mem.Allocator.dupe(pa, u8, entry.name);
        if (entry.kind == std.fs.File.Kind.directory) {
            continue;
        }
        const file = try dir.openFile(name, .{});
        defer file.close();
        const stat = try file.stat();
        const file_stat: fileStat = .{
            .name = name,
            .kind = fileKind.file,
            .size = stat.size,
        };
        try list.append(file_stat);
    }
    // create a new independant slice copy
    return list.toOwnedSlice();
}

pub fn orderFileStat(arr: []fileStat) ![]fileStat {
    var list = std.ArrayList(fileStat).init(std.heap.page_allocator);
    defer list.deinit();
    for (arr) |stat| {
        if (list.items.len == 0) try list.append(stat);
        if (stat.size > list.getLast().size) try list.append(stat);
    }
    return list.toOwnedSlice();
}

pub fn extractExtention(str: []const u8) fileError![]const u8 {
    var i = str.len - 1;
    while (i > 0) {
        if (str[i] == '.') {
            return str[i..];
        }
        i -= 1;
    }
    return fileError.extentionNotFound;
}

pub fn deleteDir(str: []const u8) !void {
    try std.fs.cwd().deleteTree(str);
}
