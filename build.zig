const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("mdfunc", .{
        .root_source_file = .{ .path = "src/mdfunc.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .pic = true,
    });
    mod.addIncludePath(.{ .path = "include" });

    const mdfunc_lib_path = b.option(
        []const u8,
        "mdfunc_lib_path",
        "Specify the path to the MELSEC static library artifact.",
    );
    const mdfunc_dir_path = std.fs.path.dirname(
        mdfunc_lib_path orelse "lib/MdFunc32.lib",
    ) orelse "lib";
    const mdfunc_lib_name = std.fs.path.stem(
        mdfunc_lib_path orelse "lib/MdFunc32.lib",
    );

    mod.addLibraryPath(.{ .path = mdfunc_dir_path });
    mod.linkSystemLibrary(mdfunc_lib_name, .{
        .needed = true,
        .preferred_link_mode = .Static,
    });
}
