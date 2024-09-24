const std = @import("std");
const print = std.debug.print;

const fileError = error{
    extentionNotFound,
    nofileInDir,
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

pub fn listFiles(curr_path: []const u8) !void {
    const dir = try std.fs.openDirAbsolute(curr_path, .{ .iterate = true });
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

pub fn largestFile(arr: []fileStat) !fileStat {
    if (arr.len == 0) return fileError.nofileInDir;
    var largest: fileStat = arr[0];
    for (arr) |stat| {
        if (stat.size > largest.size) largest = stat;
    }
    return largest;
}

pub fn deleteFileInDir(dir_path: []const u8, sub_path: []const u8) !void {
    if (std.mem.eql(u8, dir_path, ".")) {
        try std.fs.cwd().deleteTree(sub_path);
        std.debug.print("success deleting {s} \n", .{sub_path});
    } else {
        const dir = try std.fs.openDirAbsolute(dir_path, .{});
        try dir.deleteTree(sub_path);
        std.debug.print("success deleting {s} \n", .{sub_path});
    }
}

pub fn changeDir(new_path: []const u8) ![]u8 {
    const new_curr = try std.fs.openDirAbsolute(new_path, .{});
    const allocator = std.heap.page_allocator;
    return new_curr.realpathAlloc(allocator, ".");
}
