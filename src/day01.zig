const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
const List = std.ArrayList;

const data = @embedFile("../data/day01.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    var list = List(i32).init(allocator);
    {    
        var i: i32 = 0;
        for (data) |c| {
            if (c == '\n') {
            } else if (c == '\r') {
                try list.append(i);
                i = 0;
            } else {
                i *= 10;
                i += c - '0';
            }
        }
    }

    {
        var last: i32 = std.math.maxInt(i32);
        var increases: i32 = 0;
        for (list.items) |n| {
            if (n > last) {
                increases += 1;
            }
            last = n;
        }
        print("part 1: {}\n", .{increases});
    }

    {
        var last_window: i64 = std.math.maxInt(i64);
        var increases: i32 = 0;
        var i: i32 = 2;
        while (i < list.items.len) : (i += 1) {
            var window: i64 = 0;
            var start: usize = @intCast(usize, i-2);
            var end: usize = @intCast(usize, i);
            var y: usize = start;
            while (y <= end) : (y += 1) {
                window += list.items[y];
            }
            if (window > last_window) {
                increases += 1;
            } else {
            }
            last_window = window;
        }
        print("part 2: {}\n", .{increases});
    }
}

test "This is a test" {
    try std.testing.expect(false);
}