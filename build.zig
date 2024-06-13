const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("mdfunc", .{
        .root_source_file = b.path("src/mdfunc.zig"),
        .target = target,
        .optimize = optimize,
    });

    const mdfunc_mock_build = b.option(
        bool,
        "mock",
        "Enable building a mock version of the MELSEC data link library.",
    ) orelse (target.result.os.tag != .windows);

    const mdfunc_lib_path = b.option(
        []const u8,
        "mdfunc",
        "Specify the path to the MELSEC static library artifact.",
    ) orelse "lib/MdFunc32.lib";

    const options = b.addOptions();
    options.addOption(
        bool,
        "mock",
        mdfunc_mock_build,
    );
    mod.addOptions("options", options);

    if (!mdfunc_mock_build) {
        const mdfunc_dir_path = std.fs.path.dirname(mdfunc_lib_path) orelse
            b.build_root.path.?;
        const mdfunc_lib_name = std.fs.path.stem(mdfunc_lib_path);
        mod.addLibraryPath(.{ .cwd_relative = mdfunc_dir_path });
        mod.linkSystemLibrary(mdfunc_lib_name, .{
            .needed = true,
            .preferred_link_mode = .static,
        });
    }
}
