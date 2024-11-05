const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("mdfunc", .{
        .root_source_file = b.path("src/mdfunc.zig"),
        .target = target,
        .optimize = optimize,
    });

    const unit_tests = b.addTest(.{
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
    ) orelse "vendor/mdfunc/lib/x64/MdFunc32.lib";

    const options = b.addOptions();
    options.addOption(
        bool,
        "mock",
        mdfunc_mock_build,
    );
    mod.addOptions("options", options);
    unit_tests.root_module.addOptions("options", options);

    if (!mdfunc_mock_build) {
        const mdfunc_dir_path = std.fs.path.dirname(mdfunc_lib_path) orelse
            b.build_root.path.?;
        const mdfunc_lib_name = std.fs.path.stem(mdfunc_lib_path);
        mod.addLibraryPath(.{ .cwd_relative = mdfunc_dir_path });
        unit_tests.root_module.addLibraryPath(.{ .cwd_relative = mdfunc_dir_path });
        mod.linkSystemLibrary(mdfunc_lib_name, .{
            .needed = true,
            .preferred_link_mode = .static,
        });
        unit_tests.root_module.linkSystemLibrary(mdfunc_lib_name, .{
            .needed = true,
            .preferred_link_mode = .static,
        });
    }

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    // Check step is same as test, as there is no output artifact.
    const check = b.step("check", "Check if foo compiles");
    check.dependOn(&run_unit_tests.step);
}
