const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const data = @embedFile("../data/day03.txt");

const Error = error {
    FuckedUp
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    var input = List([12]u1).init(allocator);
    {
        var i: usize = 0;
        while (i < data.len) : (i += 2) {
            var j: usize = 0;
            var num: [12]u1 = undefined;
            while (j < 12) : (j += 1) {
                num[j] = @truncate(u1, data[i] - '0');
                i += 1;
            }
            try input.append(num);
        }
    }

    {
        var sig: [12]i64 = [_]i64{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        for (input.items) |num| {
            var i: usize = 0;
            while (i < 12) : (i += 1) {
                switch (num[i]) {
                    0 => sig[i] -= 1,
                    1 => sig[i] += 1,
                }
            }
        }
        var gamma: [12]u1 = [_]u1{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        var epsilon: [12]u1 = [_]u1{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        var j: usize = 0;
        while (j < 12) : (j += 1) {
            if (sig[j] == 0) {
                return Error.FuckedUp;
            } else if (sig[j] < 0) {
                gamma[j] = 0;
                epsilon[j] = 1;
            } else {
                gamma[j] = 1;
                epsilon[j] = 0;
            }
        }
        var gamma_d: u32 = 0;
        var eps_d: u32 = 0;
        var k: usize = 0;
        while (k < 12) : (k += 1) {
           gamma_d *= 2;
           gamma_d += gamma[k];
           eps_d *= 2;
           eps_d += epsilon[k];
        }
        print("part 1: {}\n", .{gamma_d*eps_d});

    }
}
