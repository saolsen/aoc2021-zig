const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day02.txt");

const Error = error {
    InvalidCommand
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    const Direction = enum {
        Forward,
        Up,
        Down
    };

    const Command = struct {
        direction: Direction,
        units: i32,
    };

    var input = List(Command).init(allocator);
    {    
        var i: usize = 0;
        while (i < data.len) {
            var direction = switch (data[i]) {
                'f' => dir: {
                    i += 7; // forward
                    break :dir Direction.Forward;
                },
                'u' => dir: {
                    i += 2; // up
                    break :dir Direction.Up;
                },
                'd' => dir: {
                    i += 4; // down
                    break :dir Direction.Down;
                },
                else => {
                    return Error.InvalidCommand;
                }
            };
            assert(data[i] == ' ');
            i += 1;
            var units: i32 = 0;
            while (i < data.len) {
                if (data[i] == '\r') {
                    i += 2; // \r\n because windows
                    break;
                } else {
                    units *= 10;
                    units += data[i] - '0';
                    i += 1;
                }
            }
            try input.append(Command{.direction = direction, .units = units});
        }
    }

    {
        var position: i32 = 0;
        var depth: i32 = 0;
        for (input.items) |command| {
            switch (command.direction) {
                Direction.Forward => {
                    position += command.units;
                },
                Direction.Down => {
                    depth += command.units;
                },
                Direction.Up => {
                    depth -= command.units;
                }
            }
        }
        print("part 1: {}\n", .{position*depth});
    }
    
    {
        var position: i32 = 0;
        var aim: i32 = 0;
        var depth: i32 = 0;
        for (input.items) |command| {
            switch (command.direction) {
                Direction.Forward => {
                    position += command.units;
                    depth += aim * command.units;
                },
                Direction.Down => {
                    aim += command.units;
                },
                Direction.Up => {
                    aim -= command.units;
                }
            }
        }
        print("part 2: {}\n", .{position*depth});
    }
    
}
