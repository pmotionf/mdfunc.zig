const std = @import("std");

const c = @cImport(
    @cInclude("Mdfunc.h"),
);

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

pub fn mdOpen(chan: Channel, mode: i16) MdFuncError!i32 {
    var path: i32 = undefined;
    try codeToError(c.mdOpen(@intFromEnum(chan), mode, &path));
    return path;
}

pub fn mdClose(path: i32) MdFuncError!void {
    try codeToError(c.mdClose(path));
}

pub fn mdSend(
    path: i32,
    stno: i16,
    devtyp: i16,
    devno: i16,
    size: *i16,
    comptime T: type,
    data: []const T,
) MdFuncError!void {
    try codeToError(c.mdSend(
        path,
        stno,
        devtyp,
        devno,
        size,
        @constCast(data.ptr),
    ));
}

pub fn mdReceive(
    path: i32,
    stno: i16,
    devtyp: Device,
    devno: i16,
    size: *i16,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    var local_size: i16 = size.*;
    try codeToError(c.mdReceive(
        path,
        stno,
        @intFromEnum(devtyp),
        devno,
        &local_size,
        data.ptr,
    ));
}

pub fn mdDevSet(
    path: i32,
    stno: i16,
    devtyp: Device,
    devno: i16,
) MdFuncError!void {
    try codeToError(c.mdDevSet(path, stno, @intFromEnum(devtyp), devno));
}

pub fn mdDevRst(
    path: i32,
    stno: i16,
    devtyp: Device,
    devno: i16,
) MdFuncError!void {
    try codeToError(c.mdDevRst(path, stno, @intFromEnum(devtyp), devno));
}

pub fn mdRandW(
    path: i32,
    stno: i16,
    comptime X: type,
    dev: []X,
    comptime Y: type,
    buf: []Y,
    bufsize: i16,
) MdFuncError!void {
    try codeToError(c.mdRandW(path, stno, dev, buf, bufsize));
}

pub fn mdRandR(
    path: i32,
    stno: i16,
    comptime X: type,
    dev: []X,
    comptime Y: type,
    buf: []Y,
    bufsize: i16,
) MdFuncError!void {
    try codeToError(c.mdRandR(path, stno, dev, buf, bufsize));
}

pub fn mdControl(
    path: i32,
    stno: i16,
    buf: i16,
) MdFuncError!void {
    try codeToError(c.mdControl(path, stno, buf));
}

pub fn mdTypeRead(
    path: i32,
    stno: i16,
    buf: *i16,
) MdFuncError!void {
    try codeToError(c.mdTypeRead(path, stno, buf));
}

pub fn mdBdLedRead(
    path: i32,
    comptime T: type,
    buf: []T,
) MdFuncError!void {
    try codeToError(c.mdBdLedRead(path, buf.ptr));
}

pub fn mdBdModRead(
    path: i32,
    mode: *i16,
) MdFuncError!void {
    try codeToError(c.mdBdModRead(path, mode));
}

pub fn mdBdModSet(
    path: i32,
    mode: i16,
) MdFuncError!void {
    try codeToError(c.mdBdModSet(path, mode));
}

pub fn mdBdRst(path: i32) MdFuncError!void {
    try codeToError(c.mdBdRst(path));
}

pub fn mdBdSwRead(path: i32, buf: []i16) MdFuncError!void {
    try codeToError(c.mdBdSwRead(path, buf.ptr));
}

pub fn mdBdVerRead(path: i32, buf: []i16) MdFuncError!void {
    try codeToError(c.mdBdVerRead(path, buf.ptr));
}

pub fn mdInit(path: i32) MdFuncError!void {
    try codeToError(c.mdInit(path));
}

pub fn mdWaitBdEvent(
    path: i32,
    comptime T: type,
    eventno: []T,
    timeout: i32,
    signaledno: *i16,
    details: [4]i16,
) MdFuncError!void {
    try codeToError(c.mdWaitBdEvent(
        path,
        eventno.ptr,
        timeout,
        signaledno,
        details,
    ));
}

pub fn mdSendEx(
    path: i32,
    netno: i32,
    stno: i32,
    devtyp: Device,
    devno: i32,
    size: *i32,
    comptime T: type,
    data: []const T,
) MdFuncError!void {
    try codeToError(c.mdSendEx(
        path,
        netno,
        stno,
        @intCast(@intFromEnum(devtyp)),
        devno,
        size,
        @constCast(data.ptr),
    ));
}

pub fn mdReceiveEx(
    path: i32,
    netno: i32,
    stno: i32,
    devtyp: Device,
    devno: i32,
    size: *i32,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    try codeToError(c.mdReceiveEx(
        path,
        netno,
        stno,
        @intCast(@intFromEnum(devtyp)),
        devno,
        size,
        data.ptr,
    ));
}

pub fn mdDevSetEx(
    path: i32,
    netno: i32,
    stno: i32,
    devtyp: Device,
    devno: i32,
) MdFuncError!void {
    try codeToError(c.mdDevSetEx(
        path,
        netno,
        stno,
        @intCast(@intFromEnum(devtyp)),
        devno,
    ));
}

pub fn mdDevRstEx(
    path: i32,
    netno: i32,
    stno: i32,
    devtyp: Device,
    devno: i32,
) MdFuncError!void {
    try codeToError(c.mdDevRstEx(
        path,
        netno,
        stno,
        @intCast(@intFromEnum(devtyp)),
        devno,
    ));
}

pub fn mdRandWEx(
    path: i32,
    netno: i32,
    stno: i32,
    dev: []i32,
    comptime T: type,
    buf: []T,
    bufsize: i32,
) MdFuncError!void {
    try codeToError(c.mdRandWEx(
        path,
        netno,
        stno,
        dev.ptr,
        buf.ptr,
        bufsize,
    ));
}

pub fn mdRandREx(
    path: i32,
    netno: i32,
    stno: i32,
    dev: []i32,
    comptime T: type,
    buf: []T,
    bufsize: i32,
) MdFuncError!void {
    try codeToError(c.mdRandREx(
        path,
        netno,
        stno,
        dev.ptr,
        buf.ptr,
        bufsize,
    ));
}

pub fn mdRemBufWriteEx(
    path: i32,
    netno: i32,
    stno: i32,
    offset: i32,
    size: *i32,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    try codeToError(c.mdRemBufWriteEx(
        path,
        netno,
        stno,
        offset,
        size,
        data.ptr,
    ));
}

pub fn mdRemBufReadEx(
    path: i32,
    netno: i32,
    stno: i32,
    offset: i32,
    size: *i32,
    comptime T: type,
    data: []T,
) MdFuncError!void {
    try codeToError(c.mdRemBufReadEx(
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
