const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("mdfunc", .{
        .root_source_file = .{ .path = "src/mdfunc.zig" },
        .target = target,
        .optimize = optimize,
    });

    const mdfunc_lib_path = b.option(
        []const u8,
        "mdfunc",
        "Specify the path to the MELSEC static library artifact.",
    ) orelse b.pathFromRoot("lib/MdFunc32.lib");

    const mdfunc_dir_path = std.fs.path.dirname(mdfunc_lib_path) orelse
        b.build_root.path.?;
    const mdfunc_lib_name = std.fs.path.stem(mdfunc_lib_path);

    mod.addLibraryPath(.{ .path = mdfunc_dir_path });
    mod.linkSystemLibrary(mdfunc_lib_name, .{
        .needed = true,
        .preferred_link_mode = .Static,
    });
}
