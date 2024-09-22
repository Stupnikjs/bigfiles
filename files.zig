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

pub fn FilesWeigth(dir_path: []const u8) !void {
    var dir = try std.fs.openDirAbsolute(dir_path, .{ .iterate = true });
    defer dir.close();
    var iter = dir.iterate();

    while (try iter.next()) |entry| {
        if (entry.kind == std.fs.File.Kind.directory) {
            print("{s} \n", .{entry.name});
            continue;
        }
        if (entry.name[0] == '.') continue;
        print("{s} \n", .{entry.name});
        const file = try dir.openFile(entry.name, .{});
        const stat = try file.stat();
        print("{d} bytes \n", .{stat.size / 8});
    }
}

pub fn DirFileStat(dir_path: []const u8) !void {
    var dir = try std.fs.openDirAbsolute(dir_path, .{ .iterate = true });
    defer dir.close();
    var iter = dir.iterate();
    var arr: [3][]const u8 = undefined;
    var count: u8 = 0;

    while (try iter.next()) |entry| {
        print("name {s}", .{entry.name});
        const pa = std.heap.page_allocator;
        const name = pa.alloc([]const u8, entry.name.len);
        @memcpy(name, entry.name);
        arr[count] = name;
        count += 1;
    }
    print("{s}", .{arr});
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
