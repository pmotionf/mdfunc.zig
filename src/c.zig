//! This module contains the extern function declarations from the C MELSEC
//! library.

const builtin = @import("builtin");
const std = @import("std");

const target_arch = builtin.target.cpu.arch;

const WINAPI: std.builtin.CallingConvention = if (target_arch == .x86)
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
    dev: [*]const i16,
    /// Written data
    buf: [*]const i16,
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
    dev: [*]const i16,
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
    eventno: [*]const i16,
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
    dev: [*]const i32,
    /// Written data
    buf: [*]const i16,
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
    dev: [*]const i32,
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
    data: [*]const i16,
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
