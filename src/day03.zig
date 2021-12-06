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
        while (i < data.len) : (i += 1) {
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
        var gamma: [12]u1 = [_]u1{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        var epsilon: [12]u1 = [_]u1{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

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
        {
            var k: usize = 0;
            while (k < 12) : (k += 1) {
                gamma_d *= 2;
                gamma_d += gamma[k];
                eps_d *= 2;
                eps_d += epsilon[k];
            }
        }
        print("part 1: {}\n", .{gamma_d*eps_d});
    }

    var ogr: u64 = 0;
    var co2: u64 = 0;

    {
        var ogr_list = try List([12]u1).initCapacity(allocator, input.items.len);
        try ogr_list.insertSlice(0, input.items);

        var prefix: [12]u1 = [_]u1{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        var j: usize = 0;
        while (j < 12) : (j += 1) {
            var sig: i64 = 0;
            for (ogr_list.items) |num| {
                switch (num[j]) {
                    0 => sig -= 1,
                    1 => sig += 1,
                }
            }
            if (sig < 0) {
                prefix[j] = 0;
            } else {
                prefix[j] = 1;
            }

            var item: usize = 0;
            item: while (item < ogr_list.items.len) {
                var k: usize = 0;
                while (k <= j) : (k += 1) {
                    if (ogr_list.items[item][k] != prefix[k]) {
                        _ = ogr_list.swapRemove(item);
                        continue :item;
                    }
                }
                item += 1;
            }

            if (ogr_list.items.len == 1) {
                {
                    var l: usize = 0;
                    while (l < 12) : (l += 1) {
                        ogr *= 2;
                        ogr += ogr_list.items[0][l];
                    }
                }
                break;
            }
        }
    }

    {
        var co2_list = try List([12]u1).initCapacity(allocator, input.items.len);
        try co2_list.insertSlice(0, input.items);

        var prefix: [12]u1 = [_]u1{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        var j: usize = 0;
        while (j < 12) : (j += 1) {
            var sig: i64 = 0;
            for (co2_list.items) |num| {
                switch (num[j]) {
                    0 => sig -= 1,
                    1 => sig += 1,
                }
            }
            if (sig >= 0) {
                prefix[j] = 0;
            } else {
                prefix[j] = 1;
            }

            var item: usize = 0;
            item: while (item < co2_list.items.len) {
                var k: usize = 0;
                while (k <= j) : (k += 1) {
                    if (co2_list.items[item][k] != prefix[k]) {
                        _ = co2_list.swapRemove(item);
                        continue :item;
                    }
                }
                item += 1;
            }

            if (co2_list.items.len == 1) {
                var l: usize = 0;
                while (l < 12) : (l += 1) {
                    co2 *= 2;
                    co2 += co2_list.items[0][l];
                }
                break;
            }
        }
    }
    print("part 2: {}", .{ogr*co2});
}
