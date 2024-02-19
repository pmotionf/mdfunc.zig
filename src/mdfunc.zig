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
    /// MELSECNET/H (1 slot)
    melsecnet_h_1slot = 51,
    /// MELSECNET/H (2 slot)
    melsecnet_h_2slot = 52,
    /// MELSECNET/H (3 slot)
    melsecnet_h_3slot = 53,
    /// MELSECNET/H (4 slot)
    melsecnet_h_4slot = 54,
    /// CC-Link (1 slot)
    cc_link_1slot = 81,
    /// CC-Link (2 slot)
    cc_link_2slot = 82,
    /// CC-Link (3 slot)
    cc_link_3slot = 83,
    /// CC-Link (4 slot)
    cc_link_4slot = 84,
    /// CC-Link IE Controller Network (Channel No.151)
    cc_link_ie_controller_network_151 = 151,
    /// CC-Link IE Controller Network (Channel No.152)
    cc_link_ie_controller_network_152 = 152,
    /// CC-Link IE Controller Network (Channel No.153)
    cc_link_ie_controller_network_153 = 153,
    /// CC-Link IE Controller Network (Channel No.154)
    cc_link_ie_controller_network_154 = 154,
    /// CC-Link IE Field Network (Channel No.181)
    cc_link_ie_field_network_181 = 181,
    /// CC-Link IE Field Network (Channel No.182)
    cc_link_ie_field_network_182 = 182,
    /// CC-Link IE Field Network (Channel No.183)
    cc_link_ie_field_network_183 = 183,
    /// CC-Link IE Field Network (Channel No.184)
    cc_link_ie_field_network_184 = 184,
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
    DriverNotStarted,
    TimeOut,
    ChannelOpened,
    Path,
    UnsupportedFunctionExecution,
    StationNumber,
    NoReceptionData,
    MemoryReservation,
    SendRecvChannelNumber,
    BoardHwResourceBusy,
    RoutingParameter,
    BoardDriverIfSend,
    BoardDriverIfReceive,
    Parameter,
    MelsecInternal,
    AccessTargetCpu,
    InvalidDevice,
    DeviceNumber,
    RequestData,
    LinkRelated,
    RequestInvalid,
    InvalidPath,
    StartDeviceNumber,
    DeviceType,
    Size,
    NumberOfBlocks,
    ChannelNumber,
    BlockNumber,
    WriteProtect,
    NetworkNumberAndStationNumber,
    AllStationAndGroupNumberSpecification,
    RemoteCommandCode,
    DllLoad,
    ResourceTimeOut,
    IncorrectAccessTarget,
    RegistryAccess,
    CommunicationInitializationSetting,
    Close,
    RomOperation,
    NumberOfEvents,
    EventNumber,
    EventNumberDuplicateRegistration,
    TimeoutTime,
    EventWaitTimeOut,
    EventInitialization,
    NoEventSetting,
    UnsupportedFunctionExecutionPackageDriver,
    EventDuplicationOccurrence,
    RemoteDeviceStationAccess,
    MelsecnetHAndMelsecnet10NetworkSystem,
    TransientDataTargetStationNumber,
    CcLinkIeControllerNetworkSystem,
    TransientDataTargetStationNumber2,
    CcLinkIeFieldNetworkSystem,
    TransientDataImproper,
    NetworkNumber,
    StationNumber2,
    TransientDataSendResponseWaitTimeOut,
    EthernetNetworkSystem,
    CcLinkSystem,
    ModuleModeSetting,
    TransientUnsupported,
    ProcessingCode,
    Reset,
    RoutingFunctionUnsupportedStation,
    UnsupportedBlockDataAssurancePerStation,
    LinkRefresh,
    IncorrectModeSetting,
    SystemSleep,
    Mode,
    HardwareSelfDiagnosis,
    DataLinkDisconnectedDeviceAccess,
    AbnormalDataReception,
    DriverWdt,
    ChannelBusy,
    HardwareSelfDiagnosis2,
    Unknown,
};

pub inline fn codeToError(code: i32) Error!void {
    switch (code) {
        0 => return,
        1 => return Error.DriverNotStarted,
        2 => return Error.TimeOut,
        66 => return Error.ChannelOpened,
        68 => return Error.Path,
        69 => return Error.UnsupportedFunctionExecution,
        70 => return Error.StationNumber,
        71 => return Error.NoReceptionData,
        77 => return Error.MemoryReservation,
        85 => return Error.SendRecvChannelNumber,
        100 => return Error.BoardHwResourceBusy,
        101 => return Error.RoutingParameter,
        102 => return Error.BoardDriverIfSend,
        103 => return Error.BoardDriverIfReceive,
        133 => return Error.Parameter,
        4096...16383 => return Error.MelsecInternal,
        16384...16431 => return Error.AccessTargetCpu,
        16432 => return Error.InvalidDevice,
        16433 => return Error.DeviceNumber,
        16434...16511 => return Error.AccessTargetCpu,
        16512 => return Error.RequestData,
        16513...18943 => return Error.AccessTargetCpu,
        18944...18945 => return Error.LinkRelated,
        18946...19201 => return Error.AccessTargetCpu,
        19202 => return Error.RequestInvalid,
        19303...20479 => return Error.AccessTargetCpu,
        -1 => return Error.InvalidPath,
        -2 => return Error.StartDeviceNumber,
        -3 => return Error.DeviceType,
        -5 => return Error.Size,
        -6 => return Error.NumberOfBlocks,
        -8 => return Error.ChannelNumber,
        -12 => return Error.BlockNumber,
        -13 => return Error.WriteProtect,
        -16 => return Error.NetworkNumberAndStationNumber,
        -17 => return Error.AllStationAndGroupNumberSpecification,
        -18 => return Error.RemoteCommandCode,
        -19 => return Error.SendRecvChannelNumber,
        -31 => return Error.DllLoad,
        -32 => return Error.ResourceTimeOut,
        -33 => return Error.IncorrectAccessTarget,
        -36...-34 => return Error.RegistryAccess,
        -37 => return Error.CommunicationInitializationSetting,
        -42 => return Error.Close,
        -43 => return Error.RomOperation,
        -61 => return Error.NumberOfEvents,
        -62 => return Error.EventNumber,
        -63 => return Error.EventNumberDuplicateRegistration,
        -64 => return Error.TimeoutTime,
        -65 => return Error.EventWaitTimeOut,
        -66 => return Error.EventInitialization,
        -67 => return Error.NoEventSetting,
        -69 => return Error.UnsupportedFunctionExecutionPackageDriver,
        -70 => return Error.EventDuplicationOccurrence,
        -71 => return Error.RemoteDeviceStationAccess,
        -2173...-257 => return Error.MelsecnetHAndMelsecnet10NetworkSystem,
        -2174 => return Error.TransientDataTargetStationNumber,
        -4096...-2175 => return Error.MelsecnetHAndMelsecnet10NetworkSystem,
        -7655...-4097 => return Error.CcLinkIeControllerNetworkSystem,
        -7656 => return Error.TransientDataTargetStationNumber2,
        -7671...-7657 => return Error.CcLinkIeControllerNetworkSystem,
        -7672 => return Error.TransientDataTargetStationNumber2,
        -8192...-7673 => return Error.CcLinkIeControllerNetworkSystem,
        -11682...-8193 => return Error.CcLinkIeFieldNetworkSystem,
        -11683 => return Error.TransientDataImproper,
        -11716...-11684 => return Error.CcLinkIeFieldNetworkSystem,
        -11717 => return Error.NetworkNumber,
        -11745...-11718 => return Error.CcLinkIeFieldNetworkSystem,
        -11746 => return Error.StationNumber2,
        -12127...-11747 => return Error.CcLinkIeFieldNetworkSystem,
        -12128 => return Error.TransientDataSendResponseWaitTimeOut,
        -12288...-12129 => return Error.CcLinkIeFieldNetworkSystem,
        -16384...-12289 => return Error.EthernetNetworkSystem,
        -18559...-16385 => return Error.CcLinkSystem,
        -18560 => return Error.ModuleModeSetting,
        -18571...-18561 => return Error.CcLinkSystem,
        -18572 => return Error.TransientUnsupported,
        -20480...-18573 => return Error.CcLinkSystem,
        -25056 => return Error.ProcessingCode,
        -26334 => return Error.Reset,
        -26336 => return Error.RoutingFunctionUnsupportedStation,
        -27902 => return Error.EventWaitTimeOut,
        -28138 => return Error.UnsupportedBlockDataAssurancePerStation,
        -28139 => return Error.LinkRefresh,
        -28140 => return Error.IncorrectModeSetting,
        -28141 => return Error.SystemSleep,
        -28142 => return Error.Mode,
        -28144...-28143 => return Error.HardwareSelfDiagnosis,
        -28150 => return Error.DataLinkDisconnectedDeviceAccess,
        -28151 => return Error.AbnormalDataReception,
        -28158 => return Error.DriverWdt,
        -28622 => return Error.ChannelBusy,
        -28634 => return Error.HardwareSelfDiagnosis2,
        -28636 => return Error.HardwareSelfDiagnosis2,
        else => return Error.Unknown,
    }
}
