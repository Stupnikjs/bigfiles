const std = @import("std");
const streql = std.mem.eql;
const files = @import("files.zig");
const printer = @import("printer.zig");


// select biggest file keep track of it 
// command to delete it 
// command to navigate throuth dirs 

// selectedFile: ?.[]const u8 = null; 

fn processCMD(cmd: []const u8){
  // if (streql("big", cmd)) //files.BiggestFile()
  
  

}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{">>: "});

    while (true) {
        const stdin = std.io.getStdIn().reader();
        var buffer: [1024]u8 = undefined;
        const user_input = try stdin.readUntilDelimiter(&buffer, '\n');
        const str = user_input[0 .. user_input.len - 1];
        _ = try stdout.write("\n>>: ");
        _ = try stdout.write(str);
    }
}

