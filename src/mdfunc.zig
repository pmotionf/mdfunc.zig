const std = @import("std");
const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;

// TODO: Ensure this is actually based off of target arch, not native.
const WINAPI: std.builtin.CallingConvention = if (native_arch == .x86)
    .Stdcall
else
    .C;

/// Open a communication line by specifying a channel number of communication
/// line.
extern "MdFunc32" fn mdOpen(
    /// Channel number of communication line
    chan: i16,
    /// Dummy
    mode: i16,
    /// Opened line path pointer
    path: *i32,
) callconv(WINAPI) i16;

/// Close a communication line by specifying a communication line path.
extern "MdFunc32" fn mdClose(
    /// Path of channel
    path: i32,
) callconv(WINAPI) i16;

/// Batch write data to the devices on the target station for the number of
/// written data bytes from the start device number. / Send data to the
/// specified channel number of the target station.
extern "MdFunc32" fn mdSend(
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
extern "MdFunc32" fn mdReceive(
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
extern "MdFunc32" fn mdDevSet(
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
extern "MdFunc32" fn mdDevRst(
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
extern "MdFunc32" fn mdRandW(
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
extern "MdFunc32" fn mdRandR(
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
extern "MdFunc32" fn mdControl(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Command code
    buf: i16,
) callconv(WINAPI) i16;

/// Read a model name code of the CPU on the target station.
extern "MdFunc32" fn mdTypeRead(
    /// Path of channel
    path: i32,
    /// Station number
    stno: i16,
    /// Model name code
    buf: *i16,
) callconv(WINAPI) i16;

/// Read the LED information of the board.
extern "MdFunc32" fn mdBdLedRead(
    /// Path of channel
    path: i32,
    /// Read data
    buf: [*]i16,
) callconv(WINAPI) i16;

/// Read the mode in which the board is currently operating.
extern "MdFunc32" fn mdBdModRead(
    /// Path of channel
    path: i32,
    /// Mode
    mode: *i16,
) callconv(WINAPI) i16;

/// Change the modes of a board temporarily.
extern "MdFunc32" fn mdBdModSet(
    /// Path of channel
    path: i32,
    /// Mode
    mode: i16,
) callconv(WINAPI) i16;

/// Reset a board.
extern "MdFunc32" fn mdBdRst(
    /// Path of channel
    path: i32,
) callconv(WINAPI) i16;

/// Read a board switch status (such as station number setting, board number
/// setting, board identification, and I/O address setting information).
extern "MdFunc32" fn mdBdSwRead(
    /// Path of channel
    path: i32,
    /// Read data
    buf: [*]i16,
) callconv(WINAPI) i16;

/// Read the version information of the board.
extern "MdFunc32" fn mdBdVerRead(
    /// Path of channel
    path: i32,
    /// Read data
    buf: [*]i16,
) callconv(WINAPI) i16;

/// Refresh a programmable controller device address table which is the
/// internal data of the MELSEC data link library.
extern "MdFunc32" fn mdInit(
    /// Path of channel
    path: i32,
) callconv(WINAPI) i16;

/// Wait an occurrence of event until the time out.
extern "MdFunc32" fn mdWaitBdEvent(
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
extern "MdFunc32" fn mdSendEx(
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
extern "MdFunc32" fn mdReceiveEx(
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
extern "MdFunc32" fn mdDevSetEx(
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
extern "MdFunc32" fn mdDevRstEx(
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
extern "MdFunc32" fn mdRandWEx(
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
extern "MdFunc32" fn mdRandREx(
    /// Path of channel
    path: i32,
    /// Network number
    netno: i32,
    /// Station number
    stno: i32,
    /// Randomly specified device
    dev: [*]i32,
    /// Read data
    buf: [*]i16,
    /// Number of bytes of read data
    bufsize: i32,
) callconv(WINAPI) i32;

/// Write data to the buffer memory of a target station (remote device station
/// of CC-Link IE Field Network).
extern "MdFunc32" fn mdRemBufWriteEx(
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
extern "MdFunc32" fn mdRemBufReadEx(
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

pub const CcLinkV2 = struct {
    pub const Station = struct {
        /// Returns if provided station number is own station.
        pub fn isOwn(station_num: u8) bool {
            return station_num == 255;
        }

        /// Returns if provided station number is other station.
        pub fn isOther(station_num: u8) bool {
            return station_num >= 0 and station_num < 64;
        }

        /// Returns if provided station number is a logical number set by the
        /// MELSEC Device Monitor Utility.
        pub fn isLogicalSetByUtility(station_num: u8) bool {
            return station_num >= 65 and station_num < 240;
        }
    };

    pub const StationEx = struct {
        /// Returns if provided station number is own station.
        pub fn isOwn(network_num: u8, station_num: u8) bool {
            return network_num == 0 and station_num == 255;
        }

        /// Returns if provided station number is other station.
        pub fn isOther(network_num: u8, station_num: u8) bool {
            return network_num == 0 and station_num >= 0 and station_num < 64;
        }

        /// Returns if provided station number is a logical number set by the
        /// MELSEC Device Monitor Utility.
        pub fn isLogicalSetByUtility(network_num: u8, station_num: u8) bool {
            return network_num == 0 and
                station_num >= 65 and
                station_num < 240;
        }
    };
};

pub fn open(chan: Channel, mode: i16) MdFuncError!i32 {
    var path: i32 = undefined;
    try codeToError(mdOpen(@intFromEnum(chan), mode, &path));
    return path;
}

pub fn close(path: i32) MdFuncError!void {
    try codeToError(mdClose(path));
}

pub fn send(
    path: i32,
    stno: i16,
    devtyp: i16,
    devno: i16,
    size: *i16,
    comptime T: type,
    data: []const T,
) MdFuncError!void {
    try codeToError(mdSend(
        path,
        stno,
        devtyp,
        devno,
        size,
        @constCast(data.ptr),
    ));
}

pub fn receive(
    path: i32,
    stno: i16,
    devtyp: Device,
    devno: i16,
    size: *i16,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    try codeToError(mdReceive(
        path,
        stno,
        @intFromEnum(devtyp),
        devno,
        size,
        data.ptr,
    ));
}

pub fn devSet(
    path: i32,
    stno: i16,
    devtyp: Device,
    devno: i16,
) MdFuncError!void {
    try codeToError(mdDevSet(path, stno, @intFromEnum(devtyp), devno));
}

pub fn devRst(
    path: i32,
    stno: i16,
    devtyp: Device,
    devno: i16,
) MdFuncError!void {
    try codeToError(mdDevRst(path, stno, @intFromEnum(devtyp), devno));
}

pub fn randW(
    path: i32,
    stno: i16,
    comptime X: type,
    dev: []X,
    comptime Y: type,
    buf: []Y,
) MdFuncError!void {
    try codeToError(mdRandW(path, stno, dev.ptr, buf.ptr, 0));
}

pub fn randR(
    path: i32,
    stno: i16,
    comptime X: type,
    dev: []X,
    comptime Y: type,
    buf: []Y,
) MdFuncError!void {
    try codeToError(mdRandR(path, stno, dev.ptr, buf.ptr, buf.len));
}

pub fn control(
    path: i32,
    stno: i16,
    buf: i16,
) MdFuncError!void {
    try codeToError(mdControl(path, stno, buf));
}

pub fn typeRead(
    path: i32,
    stno: i16,
    buf: *i16,
) MdFuncError!void {
    try codeToError(mdTypeRead(path, stno, buf));
}

pub fn bdLedRead(path: i32, comptime T: type, buf: []T) MdFuncError!void {
    try codeToError(mdBdLedRead(path, buf.ptr));
}

pub fn bdModRead(path: i32, mode: *i16) MdFuncError!void {
    try codeToError(mdBdModRead(path, mode));
}

pub fn bdModSet(path: i32, mode: i16) MdFuncError!void {
    try codeToError(mdBdModSet(path, mode));
}

pub fn bdRst(path: i32) MdFuncError!void {
    try codeToError(mdBdRst(path));
}

pub fn bdSwRead(path: i32, buf: []i16) MdFuncError!void {
    try codeToError(mdBdSwRead(path, buf.ptr));
}

pub fn bdVerRead(path: i32, buf: []i16) MdFuncError!void {
    try codeToError(mdBdVerRead(path, buf.ptr));
}

pub fn init(path: i32) MdFuncError!void {
    try codeToError(mdInit(path));
}

pub fn waitBdEvent(
    path: i32,
    comptime T: type,
    eventno: []T,
    timeout: i32,
    signaledno: *i16,
    details: *[4]i16,
) MdFuncError!void {
    try codeToError(mdWaitBdEvent(
        path,
        eventno.ptr,
        timeout,
        signaledno,
        details,
    ));
}

pub fn sendEx(
    path: i32,
    netno: i32,
    stno: i32,
    devtyp: Device,
    devno: i32,
    size: *i32,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    try codeToError(mdSendEx(
        path,
        netno,
        stno,
        @intCast(@intFromEnum(devtyp)),
        devno,
        size,
        @constCast(data.ptr),
    ));
}

pub fn receiveEx(
    path: i32,
    netno: i32,
    stno: i32,
    devtyp: Device,
    devno: i32,
    size: *i32,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    try codeToError(mdReceiveEx(
        path,
        netno,
        stno,
        @intCast(@intFromEnum(devtyp)),
        devno,
        size,
        data.ptr,
    ));
}

pub fn devSetEx(
    path: i32,
    netno: i32,
    stno: i32,
    devtyp: Device,
    devno: i32,
) MdFuncError!void {
    try codeToError(mdDevSetEx(
        path,
        netno,
        stno,
        @intCast(@intFromEnum(devtyp)),
        devno,
    ));
}

pub fn devRstEx(
    path: i32,
    netno: i32,
    stno: i32,
    devtyp: Device,
    devno: i32,
) MdFuncError!void {
    try codeToError(mdDevRstEx(
        path,
        netno,
        stno,
        @intCast(@intFromEnum(devtyp)),
        devno,
    ));
}

pub fn randWEx(
    path: i32,
    netno: i32,
    stno: i32,
    dev: []i32,
    comptime T: type,
    buf: []T,
    bufsize: i32,
) MdFuncError!void {
    try codeToError(mdRandWEx(
        path,
        netno,
        stno,
        dev.ptr,
        buf.ptr,
        bufsize,
    ));
}

pub fn randREx(
    path: i32,
    netno: i32,
    stno: i32,
    dev: []i32,
    comptime T: type,
    buf: []T,
    bufsize: i32,
) MdFuncError!void {
    try codeToError(mdRandREx(
        path,
        netno,
        stno,
        dev.ptr,
        buf.ptr,
        bufsize,
    ));
}

pub fn remBufWriteEx(
    path: i32,
    netno: i32,
    stno: i32,
    offset: i32,
    size: *i32,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    try codeToError(mdRemBufWriteEx(
        path,
        netno,
        stno,
        offset,
        size,
        data.ptr,
    ));
}

pub fn remBufReadEx(
    path: i32,
    netno: i32,
    stno: i32,
    offset: i32,
    size: *i32,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    try codeToError(mdRemBufReadEx(
        path,
        netno,
        stno,
        offset,
        size,
        data.ptr,
    ));
}

pub const Channel = enum(i16) {
    melsec_net_h_slot1 = 51,
    melsec_net_h_slot2 = 52,
    melsec_net_h_slot3 = 53,
    melsec_net_h_slot4 = 54,
    cc_link_slot1 = 81,
    cc_link_slot2 = 82,
    cc_link_slot3 = 83,
    cc_link_slot4 = 84,
    cc_link_ie_controller_network_151 = 151,
    cc_link_ie_controller_network_152 = 152,
    cc_link_ie_controller_network_153 = 153,
    cc_link_ie_controller_network_154 = 154,
    cc_link_ie_field_network_181 = 181,
    cc_link_ie_field_network_182 = 182,
    cc_link_ie_field_network_183 = 183,
    cc_link_ie_field_network_184 = 184,
};

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

pub const MdFuncError = error{
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

pub fn codeToError(code: i32) MdFuncError!void {
    switch (code) {
        0 => return,
        1 => return MdFuncError.DriverNotStarted,
        2 => return MdFuncError.TimeOut,
        66 => return MdFuncError.ChannelOpened,
        68 => return MdFuncError.Path,
        69 => return MdFuncError.UnsupportedFunctionExecution,
        70 => return MdFuncError.StationNumber,
        71 => return MdFuncError.NoReceptionData,
        77 => return MdFuncError.MemoryReservation,
        85 => return MdFuncError.SendRecvChannelNumber,
        100 => return MdFuncError.BoardHwResourceBusy,
        101 => return MdFuncError.RoutingParameter,
        102 => return MdFuncError.BoardDriverIfSend,
        103 => return MdFuncError.BoardDriverIfReceive,
        133 => return MdFuncError.Parameter,
        4096...16383 => return MdFuncError.MelsecInternal,
        16384...16431 => return MdFuncError.AccessTargetCpu,
        16432 => return MdFuncError.InvalidDevice,
        16433 => return MdFuncError.DeviceNumber,
        16434...16511 => return MdFuncError.AccessTargetCpu,
        16512 => return MdFuncError.RequestData,
        16513...18943 => return MdFuncError.AccessTargetCpu,
        18944...18945 => return MdFuncError.LinkRelated,
        18946...19201 => return MdFuncError.AccessTargetCpu,
        19202 => return MdFuncError.RequestInvalid,
        19303...20479 => return MdFuncError.AccessTargetCpu,
        -1 => return MdFuncError.InvalidPath,
        -2 => return MdFuncError.StartDeviceNumber,
        -3 => return MdFuncError.DeviceType,
        -5 => return MdFuncError.Size,
        -6 => return MdFuncError.NumberOfBlocks,
        -8 => return MdFuncError.ChannelNumber,
        -12 => return MdFuncError.BlockNumber,
        -13 => return MdFuncError.WriteProtect,
        -16 => return MdFuncError.NetworkNumberAndStationNumber,
        -17 => return MdFuncError.AllStationAndGroupNumberSpecification,
        -18 => return MdFuncError.RemoteCommandCode,
        -19 => return MdFuncError.SendRecvChannelNumber,
        -31 => return MdFuncError.DllLoad,
        -32 => return MdFuncError.ResourceTimeOut,
        -33 => return MdFuncError.IncorrectAccessTarget,
        -36...-34 => return MdFuncError.RegistryAccess,
        -37 => return MdFuncError.CommunicationInitializationSetting,
        -42 => return MdFuncError.Close,
        -43 => return MdFuncError.RomOperation,
        -61 => return MdFuncError.NumberOfEvents,
        -62 => return MdFuncError.EventNumber,
        -63 => return MdFuncError.EventNumberDuplicateRegistration,
        -64 => return MdFuncError.TimeoutTime,
        -65 => return MdFuncError.EventWaitTimeOut,
        -66 => return MdFuncError.EventInitialization,
        -67 => return MdFuncError.NoEventSetting,
        -69 => return MdFuncError.UnsupportedFunctionExecutionPackageDriver,
        -70 => return MdFuncError.EventDuplicationOccurrence,
        -71 => return MdFuncError.RemoteDeviceStationAccess,
        -2173...-257 => return MdFuncError.MelsecnetHAndMelsecnet10NetworkSystem,
        -2174 => return MdFuncError.TransientDataTargetStationNumber,
        -4096...-2175 => return MdFuncError.MelsecnetHAndMelsecnet10NetworkSystem,
        -7655...-4097 => return MdFuncError.CcLinkIeControllerNetworkSystem,
        -7656 => return MdFuncError.TransientDataTargetStationNumber2,
        -7671...-7657 => return MdFuncError.CcLinkIeControllerNetworkSystem,
        -7672 => return MdFuncError.TransientDataTargetStationNumber2,
        -8192...-7673 => return MdFuncError.CcLinkIeControllerNetworkSystem,
        -11682...-8193 => return MdFuncError.CcLinkIeFieldNetworkSystem,
        -11683 => return MdFuncError.TransientDataImproper,
        -11716...-11684 => return MdFuncError.CcLinkIeFieldNetworkSystem,
        -11717 => return MdFuncError.NetworkNumber,
        -11745...-11718 => return MdFuncError.CcLinkIeFieldNetworkSystem,
        -11746 => return MdFuncError.StationNumber2,
        -12127...-11747 => return MdFuncError.CcLinkIeFieldNetworkSystem,
        -12128 => return MdFuncError.TransientDataSendResponseWaitTimeOut,
        -12288...-12129 => return MdFuncError.CcLinkIeFieldNetworkSystem,
        -16384...-12289 => return MdFuncError.EthernetNetworkSystem,
        -18559...-16385 => return MdFuncError.CcLinkSystem,
        -18560 => return MdFuncError.ModuleModeSetting,
        -18571...-18561 => return MdFuncError.CcLinkSystem,
        -18572 => return MdFuncError.TransientUnsupported,
        -20480...-18573 => return MdFuncError.CcLinkSystem,
        -25056 => return MdFuncError.ProcessingCode,
        -26334 => return MdFuncError.Reset,
        -26336 => return MdFuncError.RoutingFunctionUnsupportedStation,
        -27902 => return MdFuncError.EventWaitTimeOut,
        -28138 => return MdFuncError.UnsupportedBlockDataAssurancePerStation,
        -28139 => return MdFuncError.LinkRefresh,
        -28140 => return MdFuncError.IncorrectModeSetting,
        -28141 => return MdFuncError.SystemSleep,
        -28142 => return MdFuncError.Mode,
        -28144...-28143 => return MdFuncError.HardwareSelfDiagnosis,
        -28150 => return MdFuncError.DataLinkDisconnectedDeviceAccess,
        -28151 => return MdFuncError.AbnormalDataReception,
        -28158 => return MdFuncError.DriverWdt,
        -28622 => return MdFuncError.ChannelBusy,
        -28634 => return MdFuncError.HardwareSelfDiagnosis2,
        -28636 => return MdFuncError.HardwareSelfDiagnosis2,
        else => return MdFuncError.Unknown,
    }
}
