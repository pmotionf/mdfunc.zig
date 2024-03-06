const std = @import("std");
const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;

/// Open a communication line by specifying a channel number of communication
/// line.
pub fn open(chan: Channel) Error!i32 {
    var path: i32 = undefined;
    try codeToError(mdOpen(@intFromEnum(chan), -1, &path));
    return path;
}

/// Close a communication line by specifying a communication line path.
pub fn close(path: i32) Error!void {
    try codeToError(mdClose(path));
}

/// Close a communication line by specifying a communication line path.
/// Batch write data to the devices on the target station for the number of
/// written data bytes from the start device number. / Send data to the
/// specified channel number of the target station.
pub fn send(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Device type
    devtyp: Device,
    /// Start device number / Channel number
    devno: i16,
    /// Written data / Send data
    data: []const u8,
) Error!i16 {
    var local_size: i16 = std.math.lossyCast(i16, data.len);
    try codeToError(mdSend(
        path,
        stno,
        @intFromEnum(devtyp),
        devno,
        &local_size,
        @constCast(@ptrCast(@alignCast(data.ptr))),
    ));
    return local_size;
}

/// Batch read data from the devices on the target station for the number of
/// read data bytes from the start device number. / Read data of the specified
/// channel number from the data which are received by the own station.
pub fn receive(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Device type
    devtyp: Device,
    /// Start device number / Channel number
    devno: i16,
    /// Read data / Receive data with send source information
    data: []u8,
) Error!i16 {
    var local_size: i16 = std.math.lossyCast(i16, data.len);
    try codeToError(mdReceive(
        path,
        stno,
        @intFromEnum(devtyp),
        devno,
        &local_size,
        @ptrCast(@alignCast(data.ptr)),
    ));
    return local_size;
}

/// Set the specified bit device on the target station (to ON).
pub fn devSet(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Device type
    devtyp: Device,
    /// Specified device number
    devno: i16,
) Error!void {
    try codeToError(mdDevSet(path, stno, @intFromEnum(devtyp), devno));
}

/// Reset the specified bit device on the target station (to OFF).
pub fn devRst(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Device type
    devtyp: Device,
    /// Specified device number
    devno: i16,
) Error!void {
    try codeToError(mdDevRst(path, stno, @intFromEnum(devtyp), devno));
}

/// Write data to the devices on the target station specified with the
/// randomly-specified devices.
pub fn randW(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Randomly-specified device
    dev: []const i16,
    /// Written data
    buf: []const i16,
) Error!void {
    try codeToError(mdRandW(path, stno, dev.ptr, buf.ptr, 0));
}

/// Read the device specified with the randomly-specified devices from the
/// target station.
pub fn randR(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Randomly-specified device
    dev: []const i16,
    /// Read data
    buf: []i16,
) Error!void {
    const read_size: i16 = if (buf.len > std.math.maxInt(i16) / 2)
        std.math.maxInt(i16)
    else
        @intCast(buf.len * 2);
    try codeToError(mdRandR(path, stno, dev.ptr, buf.ptr, read_size));
}

/// Remotely operate a CPU on the target station. (Remote RUN/STOP/PAUSE)
pub fn control(
    /// Path of a channel
    path: i32,
    /// Station number
    stno: i16,
    /// Command code
    buf: CommandCode,
) Error!void {
    try codeToError(mdControl(path, stno, @intFromEnum(buf)));
}

pub const CommandCode = enum(i16) {
    /// Remote RUN
    remote_run = 0,
    /// Remote STOP
    remote_stop = 1,
    /// Remote PAUSE
    remote_pause = 2,
};

/// Read a model name code of the CPU on the target station.
pub fn typeRead(
    /// Path of a channel
    path: i32,
    /// Station number
    stno: i16,
) Error!i16 {
    var model_name_code: i16 = undefined;
    try codeToError(mdTypeRead(path, stno, &model_name_code));
    return model_name_code;
}

/// Read the LED information of the board.
pub fn bdLedRead(
    /// Path of channel
    path: i32,
    /// Read data; must be of length 5 if reading CC-Link Ver.2 board,
    /// otherwise must be of length 2.
    buf: []i16,
) Error!void {
    try codeToError(mdBdLedRead(path, buf.ptr));
}

/// Read the mode in which the board is currently operating.
pub fn bdModRead(
    /// Path of channel
    path: i32,
) Error!i16 {
    var mode: i16 = undefined;
    try codeToError(mdBdModRead(path, &mode));
    return mode;
}

/// Change the modes of a board temporarily.
pub fn bdModSet(
    /// Path of channel
    path: i32,
    /// Mode
    mode: i16,
) Error!void {
    try codeToError(mdBdModSet(path, mode));
}

/// Reset a board.
pub fn bdRst(
    /// Path of channel
    path: i32,
) Error!void {
    try codeToError(mdBdRst(path));
}

/// Read a board switch status (such as station number setting, board number
/// setting, board identification, and I/O address setting information).
pub fn bdSwRead(
    /// Path of channel
    path: i32,
    /// Read data
    buf: *[6]i16,
) Error!void {
    try codeToError(mdBdSwRead(path, buf));
}

/// Read the version information of the board.
pub fn bdVerRead(
    /// Path of channel
    path: i32,
    /// Read data
    buf: *[32]i16,
) Error!void {
    try codeToError(mdBdVerRead(path, buf));
}

/// Refresh a programmable controller device address table which is the
/// internal data of the MELSEC data link library.
pub fn init(
    /// Path of channel
    path: i32,
) Error!void {
    try codeToError(mdInit(path));
}

/// Wait an occurrence of event until the time out.
pub fn waitBdEvent(
    /// Path of channel
    path: i32,
    /// Waiting event number, max length of 65
    eventno: []const i16,
    /// Timeout value
    timeout: i32,
    /// Event detail information
    details: *[4]i16,
) Error!i16 {
    var driven_event_number: i16 = undefined;
    try codeToError(mdWaitBdEvent(
        path,
        eventno.ptr,
        timeout,
        &driven_event_number,
        details,
    ));
    return driven_event_number;
}

/// Batch write data to the devices on the target station for the number of
/// written data bytes from the start device number. / Send data to the
/// specified channel number of the target station.
pub fn sendEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number,
    stno: i32,
    /// Device type
    devtyp: Device,
    /// Start device number / Channel number
    devno: i32,
    /// Written data / Send data
    data: []const u8,
) Error!i32 {
    var local_size: i32 = std.math.lossyCast(i32, data.len);
    try codeToError(mdSendEx(
        path,
        netno,
        stno,
        @intFromEnum(devtyp),
        devno,
        &local_size,
        @constCast(@ptrCast(@alignCast(data.ptr))),
    ));
    return local_size;
}

/// Batch read data from the devices on the target station for the number of
/// read data bytes from the start device number. / Read data of the specified
/// channel number from the data which are received by the own station.
pub fn receiveEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Device type
    devtyp: Device,
    /// Start device number / Channel number
    devno: i32,
    /// Read data / Receive data
    data: []u8,
) Error!i32 {
    var local_size: i32 = std.math.lossyCast(i32, data.len);
    try codeToError(mdReceiveEx(
        path,
        netno,
        stno,
        @intFromEnum(devtyp),
        devno,
        &local_size,
        @ptrCast(@alignCast(data.ptr)),
    ));
    return local_size;
}

/// Set the specified bit device on the target station (to ON).
pub fn devSetEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Device type
    devtyp: Device,
    /// Specified device number
    devno: i32,
) Error!void {
    try codeToError(mdDevSetEx(
        path,
        netno,
        stno,
        @intFromEnum(devtyp),
        devno,
    ));
}

/// Reset the specified bit device on the target station (to OFF).
pub fn devRstEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Device type
    devtyp: Device,
    /// Specified device number
    devno: i32,
) Error!void {
    try codeToError(mdDevRstEx(
        path,
        netno,
        stno,
        @intFromEnum(devtyp),
        devno,
    ));
}

/// Write data to the devices on the target station specified with the
/// randomly-specified devices.
pub fn randWEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Randomly-specified device
    dev: []const i32,
    /// Written data
    buf: []const i16,
) Error!void {
    try codeToError(mdRandWEx(path, netno, stno, dev.ptr, buf.ptr, 0));
}

/// Read the device specified with the randomly-specified devices from the
/// target station.
pub fn randREx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Randomly-specified device
    dev: []const i32,
    /// Read data
    buf: []i16,
) Error!void {
    const read_buf_bytes: i32 = if (buf.len > std.math.maxInt(i32))
        std.math.maxInt(i32)
    else
        @intCast(buf.len * 2);
    try codeToError(mdRandREx(
        path,
        netno,
        stno,
        dev.ptr,
        buf.ptr,
        read_buf_bytes,
    ));
}

/// Write data to the buffer memory of a target station (remote device station
/// of CC-Link IE Field Network).
pub fn remBufWriteEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Offset
    offset: i32,
    /// Written data
    data: []const i16,
) Error!i32 {
    const data_bytes: i32 = if (data.len > std.math.maxInt(i32))
        std.math.maxInt(i32)
    else
        @intCast(data.len * 2);
    try codeToError(mdRemBufWriteEx(
        path,
        netno,
        stno,
        offset,
        &data_bytes,
        data.ptr,
    ));
}

/// Read data from the buffer memory of a target station (remote device station
/// of CC-Link IE Field Network).
pub fn remBufReadEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Offset
    offset: i32,
    /// Read data
    data: []i16,
) Error!void {
    const data_bytes: i32 = if (data.len > std.math.maxInt(i32))
        std.math.maxInt(i32)
    else
        @intCast(data.len * 2);
    try codeToError(mdRemBufReadEx(
        path,
        netno,
        stno,
        offset,
        &data_bytes,
        data.ptr,
    ));
}

pub const Channel = enum(i16) {
    @"MELSECNET/H (1 slot)" = 51,
    @"MELSECNET/H (2 slot)" = 52,
    @"MELSECNET/H (3 slot)" = 53,
    @"MELSECNET/H (4 slot)" = 54,
    @"CC-Link (1 slot)" = 81,
    @"CC-Link (2 slot)" = 82,
    @"CC-Link (3 slot)" = 83,
    @"CC-Link (4 slot)" = 84,
    @"CC-Link IE Controller Network (Channel No. 151)" = 151,
    @"CC-Link IE Controller Network (Channel No. 152)" = 152,
    @"CC-Link IE Controller Network (Channel No. 153)" = 153,
    @"CC-Link IE Controller Network (Channel No. 154)" = 154,
    @"CC-Link IE Field Network (Channel No. 181)" = 181,
    @"CC-Link IE Field Network (Channel No. 182)" = 182,
    @"CC-Link IE Field Network (Channel No. 183)" = 183,
    @"CC-Link IE Field Network (Channel No. 184)" = 184,
};

// TODO: Ensure this is actually based off of target arch, not native.
const WINAPI: std.builtin.CallingConvention = if (native_arch == .x86)
    .Stdcall
else
    .C;

/// Open a communication line by specifying a channel number of communication
/// line.
pub extern "MdFunc32" fn mdOpen(
    /// Channel number of communication line
    chan: i16,
    /// Dummy
    mode: i16,
    /// Opened line path pointer
    path: *i32,
) callconv(WINAPI) i16;

/// Close a communication line by specifying a communication line path.
pub extern "MdFunc32" fn mdClose(
    /// Path of channel
    path: i32,
) callconv(WINAPI) i16;

/// Close a communication line by specifying a communication line path.
/// Batch write data to the devices on the target station for the number of
/// written data bytes from the start device number. / Send data to the
/// specified channel number of the target station.
pub extern "MdFunc32" fn mdSend(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Device type
    devtyp: i16,
    /// Start device number / Channel number
    devno: i16,
    /// Written byte size / Send byte size
    size: *i16,
    /// Written data / Send data
    data: [*]i16,
) callconv(WINAPI) i16;

/// Batch read data from the devices on the target station for the number of
/// read data bytes from the start device number. / Read data of the specified
/// channel number from the data which are received by the own station.
pub extern "MdFunc32" fn mdReceive(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Device type
    devtyp: i16,
    /// Start device number / Channel number
    devno: i16,
    /// Read byte size / Receive byte size
    size: *i16,
    /// Read data / Receive data with send source information
    data: [*]i16,
) callconv(WINAPI) i16;

/// Set the specified bit device on the target station (to ON).
pub extern "MdFunc32" fn mdDevSet(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Device type
    devtyp: i16,
    /// Specified device number
    devno: i16,
) callconv(WINAPI) i16;

/// Reset the specified bit device on the target station (to OFF).
pub extern "MdFunc32" fn mdDevRst(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Device type
    devtyp: i16,
    /// Specified device number
    devno: i16,
) callconv(WINAPI) i16;

/// Write data to the devices on the target station specified with the
/// randomly-specified devices.
pub extern "MdFunc32" fn mdRandW(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Randomly-specified device
    dev: [*]i16,
    /// Written data
    buf: [*]i16,
    /// Dummy
    bufsize: i16,
) callconv(WINAPI) i16;

/// Read the device specified with the randomly-specified devices from the
/// target station.
pub extern "MdFunc32" fn mdRandR(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Randomly-specified device
    dev: [*]i16,
    /// Read data
    buf: [*]i16,
    /// Number of bytes of read data
    bufsize: i16,
) callconv(WINAPI) i16;

/// Remotely operate a CPU on the target station. (Remote RUN/STOP/PAUSE)
pub extern "MdFunc32" fn mdControl(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Command code
    buf: i16,
) callconv(WINAPI) i16;

/// Read a model name code of the CPU on the target station.
pub extern "MdFunc32" fn mdTypeRead(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Model name code
    buf: *i16,
) callconv(WINAPI) i16;

/// Read the LED information of the board.
pub extern "MdFunc32" fn mdBdLedRead(
    /// Path of channel
    path: i32,
    /// Read data
    buf: [*]i16,
) callconv(WINAPI) i16;

/// Read the mode in which the board is currently operating.
pub extern "MdFunc32" fn mdBdModRead(
    /// Path of channel
    path: i32,
    /// Mode
    mode: *i16,
) callconv(WINAPI) i16;

/// Change the modes of a board temporarily.
pub extern "MdFunc32" fn mdBdModSet(
    /// Path of channel
    path: i32,
    /// Mode
    mode: i16,
) callconv(WINAPI) i16;

/// Reset a board.
pub extern "MdFunc32" fn mdBdRst(
    /// Path of channel
    path: i32,
) callconv(WINAPI) i16;

/// Read a board switch status (such as station number setting, board number
/// setting, board identification, and I/O address setting information).
pub extern "MdFunc32" fn mdBdSwRead(
    /// Path of channel
    path: i32,
    /// Read data
    buf: *[6]i16,
) callconv(WINAPI) i16;

/// Read the version information of the board.
pub extern "MdFunc32" fn mdBdVerRead(
    /// Path of channel
    path: i32,
    /// Read data
    buf: *[32]i16,
) callconv(WINAPI) i16;

/// Refresh a programmable controller device address table which is the
/// internal data of the MELSEC data link library.
pub extern "MdFunc32" fn mdInit(
    /// Path of channel
    path: i32,
) callconv(WINAPI) i16;

/// Wait an occurrence of event until the time out.
pub extern "MdFunc32" fn mdWaitBdEvent(
    /// Path of channel
    path: i32,
    /// Waiting event number
    eventno: [*]i16,
    /// Timeout value
    timeout: i32,
    /// Driven event number
    signaledno: *i16,
    /// Event detail information
    details: *[4]i16,
) callconv(WINAPI) i16;

/// Batch write data to the devices on the target station for the number of
/// written data bytes from the start device number. / Send data to the
/// specified channel number of the target station.
pub extern "MdFunc32" fn mdSendEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Device type
    devtyp: i32,
    /// Start device number / Channel number
    devno: i32,
    /// Written byte size / Send byte size
    size: *i32,
    /// Written data / Send data
    data: [*]i16,
) callconv(WINAPI) i32;

/// Batch read data from the devices on the target station for the number of
/// read data bytes from the start device number. / Read data of the specified
/// channel number from the data which are received by the own station.
pub extern "MdFunc32" fn mdReceiveEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Device type
    devtyp: i32,
    /// Start device number / Channel number
    devno: i32,
    /// Read byte size / Receive byte size
    size: *i32,
    /// Read data / Receive data
    data: [*]i16,
) callconv(WINAPI) i32;

/// Set the specified bit device on the target station (to ON).
pub extern "MdFunc32" fn mdDevSetEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Device type
    devtyp: i32,
    /// Specified device number
    devno: i32,
) callconv(WINAPI) i32;

/// Reset the specified bit device on the target station (to OFF).
pub extern "MdFunc32" fn mdDevRstEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Device type
    devtyp: i32,
    /// Specified device number
    devno: i32,
) callconv(WINAPI) i32;

/// Write data to the devices on the target station specified with the
/// randomly-specified devices.
pub extern "MdFunc32" fn mdRandWEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Randomly-specified device
    dev: [*]i32,
    /// Written data
    buf: [*]i16,
    /// Dummy
    bufsize: i32,
) callconv(WINAPI) i32;

/// Read the device specified with the randomly-specified devices from the
/// target station.
pub extern "MdFunc32" fn mdRandREx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Randomly-specified device
    dev: [*]i32,
    /// Read data
    buf: [*]i16,
    /// Number of bytes of read data
    bufsize: i32,
) callconv(WINAPI) i32;

/// Write data to the buffer memory of a target station (remote device station
/// of CC-Link IE Field Network).
pub extern "MdFunc32" fn mdRemBufWriteEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Offset
    offset: i32,
    /// Written byte size
    size: *i32,
    /// Written data
    data: [*]i16,
) callconv(WINAPI) i32;

/// Read data from the buffer memory of a target station (remote device station
/// of CC-Link IE Field Network).
pub extern "MdFunc32" fn mdRemBufReadEx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Offset
    offset: i32,
    /// Read byte size
    size: *i32,
    /// Read data
    data: [*]i16,
) callconv(WINAPI) i32;

pub const Device = def: {
    var result = std.builtin.Type.Enum{
        .tag_type = i16,
        .fields = &.{
            .{ .name = "DevX", .value = 1 },
            .{ .name = "DevY", .value = 2 },
            .{ .name = "DevL", .value = 3 },
            .{ .name = "DevM", .value = 4 },
            .{ .name = "DevSM", .value = 5 },
            .{ .name = "DevF", .value = 6 },
            .{ .name = "DevTT", .value = 7 },
            .{ .name = "DevTC", .value = 8 },
            .{ .name = "DevCT", .value = 9 },
            .{ .name = "DevCC", .value = 10 },
            .{ .name = "DevTN", .value = 11 },
            .{ .name = "DevCN", .value = 12 },
            .{ .name = "DevD", .value = 13 },
            .{ .name = "DevSD", .value = 14 },
            .{ .name = "DevTM", .value = 15 },
            .{ .name = "DevTS", .value = 16 },
            .{ .name = "DevTS2", .value = 16002 },
            .{ .name = "DevTS3", .value = 16003 },
            .{ .name = "DevCM", .value = 17 },
            .{ .name = "DevCS", .value = 18 },
            .{ .name = "DevCS2", .value = 18002 },
            .{ .name = "DevCS3", .value = 18003 },
            .{ .name = "DevA", .value = 19 },
            .{ .name = "DevZ", .value = 20 },
            .{ .name = "DevV", .value = 21 },
            .{ .name = "DevR", .value = 22 },
            .{ .name = "DevZR", .value = 220 },
            .{ .name = "DevB", .value = 23 },
            .{ .name = "DevW", .value = 24 },
            .{ .name = "DevQSB", .value = 25 },
            .{ .name = "DevSTT", .value = 26 },
            .{ .name = "DevSTC", .value = 27 },
            .{ .name = "DevQSW", .value = 28 },
            .{ .name = "DevQV", .value = 30 },
            .{ .name = "DevMRB", .value = 33 },
            .{ .name = "DevSTN", .value = 35 },
            .{ .name = "DevWw", .value = 36 },
            .{ .name = "DevWr", .value = 37 },
            .{ .name = "DevLZ", .value = 38 },
            .{ .name = "DevRD", .value = 39 },
            .{ .name = "DevLTT", .value = 41 },
            .{ .name = "DevLTC", .value = 42 },
            .{ .name = "DevLTN", .value = 43 },
            .{ .name = "DevLCT", .value = 44 },
            .{ .name = "DevLCC", .value = 45 },
            .{ .name = "DevLCN", .value = 46 },
            .{ .name = "DevLSTT", .value = 47 },
            .{ .name = "DevLSTC", .value = 48 },
            .{ .name = "DevLSTN", .value = 49 },
            .{ .name = "DevSPB", .value = 50 },
            .{ .name = "DevMAIL", .value = 101 },
            .{ .name = "DevMAILNC", .value = 102 },
            .{ .name = "DevRBM", .value = -32768 },
            .{ .name = "DevRAB", .value = -32736 },
            .{ .name = "DevRX", .value = -32735 },
            .{ .name = "DevRY", .value = -32734 },
            .{ .name = "DevRW", .value = -32732 },
            .{ .name = "DevSB", .value = -32669 },
            .{ .name = "DevSW", .value = -32668 },
        },
        .decls = &.{},
        .is_exhaustive = false,
    };
    for (0..257) |i| {
        result.fields = result.fields ++ [_]std.builtin.Type.EnumField{
            .{
                .name = "DevER" ++ std.fmt.comptimePrint("{d}", .{i}),
                .value = 22000 + i,
            },
        };
    }
    for (1..256) |i| {
        result.fields = result.fields ++ [_]std.builtin.Type.EnumField{
            .{
                .name = "DevLX" ++ std.fmt.comptimePrint("{d}", .{i}),
                .value = 1000 + i,
            },
        };
    }
    for (1..256) |i| {
        result.fields = result.fields ++ [_]std.builtin.Type.EnumField{
            .{
                .name = "DevLY" ++ std.fmt.comptimePrint("{d}", .{i}),
                .value = 2000 + i,
            },
        };
    }
    for (1..256) |i| {
        result.fields = result.fields ++ [_]std.builtin.Type.EnumField{
            .{
                .name = "DevLB" ++ std.fmt.comptimePrint("{d}", .{i}),
                .value = 23000 + i,
            },
        };
    }
    for (1..256) |i| {
        result.fields = result.fields ++ [_]std.builtin.Type.EnumField{
            .{
                .name = "DevLW" ++ std.fmt.comptimePrint("{d}", .{i}),
                .value = 24000 + i,
            },
        };
    }
    for (1..256) |i| {
        result.fields = result.fields ++ [_]std.builtin.Type.EnumField{
            .{
                .name = "DevLSB" ++ std.fmt.comptimePrint("{d}", .{i}),
                .value = 25000 + i,
            },
        };
    }
    for (1..256) |i| {
        result.fields = result.fields ++ [_]std.builtin.Type.EnumField{
            .{
                .name = "DevLSW" ++ std.fmt.comptimePrint("{d}", .{i}),
                .value = 28000 + i,
            },
        };
    }
    for (0..256) |i| {
        result.fields = result.fields ++ [_]std.builtin.Type.EnumField{
            .{
                .name = "DevSPG" ++ std.fmt.comptimePrint("{d}", .{i}),
                .value = 29000 + i,
            },
        };
    }
    break :def @Type(.{ .Enum = result });
};

pub const Error = error{
    @"1: Driver not started",
    @"2: Time-out error",
    @"66: Channel-opened error",
    @"68: Path error",
    @"69: Unsupported function execution error",
    @"70: Station number error",
    @"71: No reception data error (for RECV function)",
    @"77: Memory reservation error/resource memory shortage error",
    @"85: SEND/RECV channel number error",
    @"100: Board H/W resource busy",
    @"101: Routing parameter error",
    @"102: Board Driver I/F error",
    @"103: Board Driver I/F error",
    @"130: Start device number error",
    @"131: Size error",
    @"133: Parameter error",
    @"4096..16383: MELSEC data link library internal error",
    @"16384..20479: Error detected by the access target CPU",
    @"16385: The specified target CPU does not exist.",
    @"16386: A request that cannot be processed by the request destination station was received.",
    @"16418: File related error",
    @"16420: File related error",
    @"16421: File related error",
    @"16432: Device error",
    @"16433: Device error",
    @"16512: Request data error",
    @"16685: File related error",
    @"16837: File related error",
    @"18944: Link-related error",
    @"18945: Link-related error",
    @"19202: The request is not for a CPU module.",
    @"28416..28671: Error detected by the redundant function module",
    @"-1: Path error",
    @"-2: Start device number error",
    @"-3: Device type error",
    @"-5: Size error",
    @"-6: Number of blocks error",
    @"-8: Channel number error",
    @"-12: Block number error",
    @"-13: Write protect error",
    @"-16: Network number and station number error",
    @"-17: All station specification and group number specification error",
    @"-18: Remote command code error",
    @"-19: SEND/RECV channel number error",
    @"-31: DLL load error",
    @"-32: Resource time-out error",
    @"-33: Incorrect access target error",
    @"-34: Registry access error",
    @"-35: Registry access error",
    @"-36: Registry access error",
    @"-37: Communication initialization setting error",
    @"-42: Close error",
    @"-43: ROM operation error",
    @"-61: Number of events error",
    @"-62: Event number error",
    @"-63: Event number overlapped registration error",
    @"-64: Timeout time error",
    @"-65: Event wait time-out error",
    @"-66: Event initialization error",
    @"-67: No event setting error",
    @"-69: Unsupported function execution error",
    @"-70: Event overlapped occurrence error",
    @"-71: Remote device station access error",
    @"-72: Pointer error",
    @"-73: IP address error",
    @"-257..-4096: Errors detected in the MELSECNET/H and MELSECNET/10 network system",
    @"-2174: Transient data target station number error",
    @"-4097..-8192: Errors detected in the CC-Link IE Controller network system",
    @"-7656: Transient data target station number error",
    @"-7672: Transient data target station number error",
    @"-8193..-12288: Errors detected in the CC-Link IE Field network system",
    @"-11683: Transient data improper",
    @"-11717: Network number error",
    @"-11746: Station number error",
    @"-12128: Transient data send response wait time-out error",
    @"-12289..-16384: Errors detected in the Ethernet network system",
    @"-16385..-20480: Errors detected in the CC-Link system",
    @"-18560: Module mode setting error",
    @"-18572: Transient unsupported error",
    @"-25056: Processing code error",
    @"-26334: Reset error",
    @"-26336: Routing request error on routing function unsupported station",
    @"-27902: Event wait time-out error",
    @"-28079: Channel No. reading error",
    @"-28080: Incorrect channel No. error",
    @"-28138: Unsupported block data assurance per station",
    @"-28139: Link refresh error",
    @"-28140: Incorrect mode setting error",
    @"-28141: System sleep error",
    @"-28142: Mode error",
    @"-28143: Hardware self-diagnosis error",
    @"-28144: Hardware self-diagnosis error",
    @"-28150: Data link disconnected device access error",
    @"-28151: Abnormal data reception error",
    @"-28153: Data reading error",
    @"-28154: Abnormal data reception error",
    @"-28158: Driver WDT error",
    @"-28160: Hardware resource error",
    @"-28611..-28612: System error",
    @"-28622: Channel busy (dedicated instruction) error",
    @"-28634: Hardware self-diagnosis error",
    @"-28636: Hardware self-diagnosis error",
};

pub inline fn codeToError(code: i32) Error!void {
    switch (code) {
        0 => return,
        1 => return Error.@"1: Driver not started",
        2 => return Error.@"2: Time-out error",
        66 => return Error.@"66: Channel-opened error",
        68 => return Error.@"68: Path error",
        69 => return Error.@"69: Unsupported function execution error",
        70 => return Error.@"70: Station number error",
        71 => return Error.@"71: No reception data error (for RECV function)",
        77 => return Error.@"77: Memory reservation error/resource memory shortage error",
        85 => return Error.@"85: SEND/RECV channel number error",
        100 => return Error.@"100: Board H/W resource busy",
        101 => return Error.@"101: Routing parameter error",
        102 => return Error.@"102: Board Driver I/F error",
        103 => return Error.@"103: Board Driver I/F error",
        130 => return Error.@"130: Start device number error",
        131 => return Error.@"131: Size error",
        133 => return Error.@"133: Parameter error",
        4096...16383 => return Error.@"4096..16383: MELSEC data link library internal error",
        16384 => return Error.@"16384..20479: Error detected by the access target CPU",
        16385 => return Error.@"16385: The specified target CPU does not exist.",
        16386 => return Error.@"16386: A request that cannot be processed by the request destination station was received.",
        16387...16417 => return Error.@"16384..20479: Error detected by the access target CPU",
        16418 => return Error.@"16418: File related error",
        16419 => return Error.@"16384..20479: Error detected by the access target CPU",
        16420 => return Error.@"16420: File related error",
        16421 => return Error.@"16421: File related error",
        16422...16431 => return Error.@"16384..20479: Error detected by the access target CPU",
        16432 => return Error.@"16432: Device error",
        16433 => return Error.@"16433: Device error",
        16434...16511 => return Error.@"16384..20479: Error detected by the access target CPU",
        16512 => return Error.@"16512: Request data error",
        16513...16684 => return Error.@"16384..20479: Error detected by the access target CPU",
        16685 => return Error.@"16685: File related error",
        16686...16836 => return Error.@"16384..20479: Error detected by the access target CPU",
        16837 => return Error.@"16837: File related error",
        16838...18943 => return Error.@"16384..20479: Error detected by the access target CPU",
        18944 => return Error.@"18944: Link-related error",
        18945 => return Error.@"18945: Link-related error",
        18946...19201 => return Error.@"16384..20479: Error detected by the access target CPU",
        19202 => return Error.@"19202: The request is not for a CPU module",
        19203...20479 => return Error.@"16384..20479: Error detected by the access target CPU",
        28416...28671 => return Error.@"28416..28671: Error detected by the redundant function module",
        -1 => return Error.@"-1: Path error",
        -2 => return Error.@"-2: Start device number error",
        -3 => return Error.@"-3: Device type error",
        -5 => return Error.@"-5: Size error",
        -6 => return Error.@"-6: Number of blocks error",
        -8 => return Error.@"-8: Channel number error",
        -12 => return Error.@"-12: Block number error",
        -13 => return Error.@"-13: Write protect error",
        -16 => return Error.@"-16: Network number and station number error",
        -17 => return Error.@"-17: All station specification and group number specification error",
        -18 => return Error.@"-18: Remote command code error",
        -19 => return Error.@"-19: SEND/RECV channel number error",
        -31 => return Error.@"-31: DLL load error",
        -32 => return Error.@"-32: Resource time-out error",
        -33 => return Error.@"-33: Incorrect access target error",
        -34 => return Error.@"-34: Registry access error",
        -35 => return Error.@"-35: Registry access error",
        -36 => return Error.@"-36: Registry access error",
        -37 => return Error.@"-37: Communication initialization setting error",
        -42 => return Error.@"-42: Close error",
        -43 => return Error.@"-43: ROM operation error",
        -61 => return Error.@"-61: Number of events error",
        -62 => return Error.@"-62: Event number error",
        -63 => return Error.@"-63: Event number overlapped registration error",
        -64 => return Error.@"-64: Timeout time error",
        -65 => return Error.@"-65: Event wait time-out error",
        -66 => return Error.@"-66: Event initialization error",
        -67 => return Error.@"-67: No event setting error",
        -69 => return Error.@"-69: Unsupported function execution error",
        -70 => return Error.@"-70: Event overlapped occurrence error",
        -71 => return Error.@"-71: Remote device station access error",
        -72 => return Error.@"-72: Pointer error",
        -73 => return Error.@"-73: IP address error",
        -2173...-257 => return Error.@"-257..-4096: Errors detected in the MELSECNET/H and MELSECNET/10 network system",
        -2174 => return Error.@"-2174: Transient data target station number error",
        -4096...-2175 => return Error.@"-257..-4096: Errors detected in the MELSECNET/H and MELSECNET/10 network system",
        -7655...-4097 => return Error.@"-4097..-8192: Errors detected in the CC-Link IE Controller network system",
        -7656 => return Error.@"-7656: Transient data target station number error",
        -7671...-7657 => return Error.@"-4097..-8192: Errors detected in the CC-Link IE Controller network system",
        -7672 => return Error.@"-7672: Transient data target station number error",
        -8192...-7673 => return Error.@"-4097..-8192: Errors detected in the CC-Link IE Controller network system",
        -11682...-8193 => return Error.@"-8193..-12288: Errors detected in the CC-Link IE Field network system",
        -11683 => return Error.@"-11683: Transient data improper",
        -11716...-11684 => return Error.@"-8193..-12288: Errors detected in the CC-Link IE Field network system",
        -11717 => return Error.@"-11717: Network number error",
        -11745...-11718 => return Error.@"-8193..-12288: Errors detected in the CC-Link IE Field network system",
        -11746 => return Error.@"-11746: Station number error",
        -12127...-11747 => return Error.@"-8193..-12288: Errors detected in the CC-Link IE Field network system",
        -12128 => return Error.@"-12128: Transient data send response wait time-out error",
        -12288...-12129 => return Error.@"-8193..-12288: Errors detected in the CC-Link IE Field network system",
        -16384...-12289 => return Error.@"-12289..-16384: Errors detected in the Ethernet network system",
        -18559...-16385 => return Error.@"-16385..-20480: Errors detected in the CC-Link system",
        -18560 => return Error.@"-18560: Module mode setting error",
        -18571...-18561 => return Error.@"-16385..-20480: Errors detected in the CC-Link system",
        -18572 => return Error.@"-18572: Transient unsupported error",
        -20480...-18573 => return Error.@"-16385..-20480: Errors detected in the CC-Link system",
        -25056 => return Error.@"-25056: Processing code error",
        -26334 => return Error.@"-26334: Reset error",
        -26336 => return Error.@"-26336: Routing request error on routing function unsupported station",
        -27902 => return Error.@"-27902: Event wait time-out error",
        -28079 => return Error.@"-28079: Channel No. reading error",
        -28080 => return Error.@"-28080: Incorrect channel No. error",
        -28138 => return Error.@"-28138: Unsupported block data assurance per station",
        -28139 => return Error.@"-28139: Link refresh error",
        -28140 => return Error.@"-28140: Incorrect mode setting error",
        -28141 => return Error.@"-28141: System sleep error",
        -28142 => return Error.@"-28142: Mode error",
        -28143 => return Error.@"-28143: Hardware self-diagnosis error",
        -28144 => return Error.@"-28144: Hardware self-diagnosis error",
        -28150 => return Error.@"-28150: Data link disconnected device access error",
        -28151 => return Error.@"-28151: Abnormal data reception error",
        -28153 => return Error.@"-28153: Data reading error",
        -28154 => return Error.@"-28154: Abnormal data reception error",
        -28158 => return Error.@"-28158: Driver WDT error",
        -28160 => return Error.@"-28160: Hardware resource error",
        -28612...-28611 => return Error.@"-28611..-28612: System error",
        -28622 => return Error.@"-28622: Channel busy (dedicated instruction) error",
        -28634 => return Error.@"-28634: Hardware self-diagnosis error",
        -28636 => return Error.@"-28636: Hardware self-diagnosis error",
        else => return Error.Unknown,
    }
}
