//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Foundation
import os.signpost

@available(iOS 12.0, tvOS 12.0, macOS 10.14, *)
public protocol Signpostable {}

@available(iOS 12.0, tvOS 12.0, macOS 10.14, *)
extension Signpostable {
    /// Logs a point of interest in your code as a time interval or
    /// as an event for debugging performance in
    /// Instruments, and includes a detailed message.
    ///
    /// OSSignpostType.Event is used by default.
    ///
    /// - Parameters:
    ///   - name: The name of the signpost.
    ///   - signpostID: A signpost identifier you use to disambiguate between signposts with the same name.
	@inlinable
	public func event(name: StaticString,
	                  signpostID: UInt64? = nil) {
		event(name: name,
		      signpostID: signpostID,
		      "",
		      [])
	}

    /// Logs a point of interest in your code as a time interval or
    /// as an event for debugging performance in
    /// Instruments, and includes a detailed message.
    ///
    ///  OSSignpostType.Event is used by default.
    ///
    /// - Parameters:
    ///   - name: The name of the signpost.
    ///   - signpostID: A signpost identifier you use to disambiguate between signposts with the same name.
    ///   - format: A constant string or format string that produces a human-readable log message.
    ///   - arguments: If format is a constant string, do not specify arguments. If format is a format string, pass the expected number of arguments in the order that they appear in the string.
	@inlinable
	public func event(name: StaticString,
	                  signpostID: UInt64? = nil,
	                  _ format: StaticString,
	                  _ arguments: CVarArg...) {
		signpost(type: .event,
		         name: name,
		         signpostID: signpostID,
		         format,
		         arguments)
	}

    /// Logs a point of interest in your code as a time interval or
    /// as an event for debugging performance in
    /// Instruments, and includes a detailed message.
    ///
    /// OSSignpostType.Begin is used by default.
    ///
    /// - Parameters:
    ///   - name: The name of the signpost.
    ///   - signpostID: A signpost identifier you use to disambiguate between signposts with the same name.
	@inlinable
	public func beginEvent(name: StaticString,
	                       signpostID: UInt64? = nil) {
		beginEvent(name: name,
		           signpostID: signpostID,
		           "",
		           [])
	}

    /// Logs a point of interest in your code as a time interval or
    /// as an event for debugging performance in
    /// Instruments, and includes a detailed message.
    ///
    ///  OSSignpostType.Begin is used by default.
    ///
    /// - Parameters:
    ///   - name: The name of the signpost.
    ///   - signpostID: A signpost identifier you use to disambiguate between signposts with the same name.
    ///   - format: A constant string or format string that produces a human-readable log message.
    ///   - arguments: If format is a constant string, do not specify arguments. If format is a format string, pass the expected number of arguments in the order that they appear in the string.
	@inlinable
	public func beginEvent(name: StaticString,
	                       signpostID: UInt64? = nil,
	                       _ format: StaticString,
	                       _ arguments: CVarArg...) {
		signpost(type: .begin,
		         name: name,
		         signpostID: signpostID,
		         format,
		         arguments)
	}

    /// Logs a point of interest in your code as a time interval or
    /// as an event for debugging performance in
    /// Instruments, and includes a detailed message.
    ///
    /// OSSignpostType.End is used by default.
    ///
    /// - Parameters:
    ///   - name: The name of the signpost.
    ///   - signpostID: A signpost identifier you use to disambiguate between signposts with the same name.
	@inlinable
	public func endEvent(name: StaticString,
	                     signpostID: UInt64? = nil) {
		endEvent(name: name,
		         signpostID: signpostID,
		         "",
		         [])
	}

    /// Logs a point of interest in your code as a time interval or
    /// as an event for debugging performance in
    /// Instruments, and includes a detailed message.
    ///
    ///  OSSignpostType.End is used by default.
    ///
    /// - Parameters:
    ///   - name: The name of the signpost.
    ///   - signpostID: A signpost identifier you use to disambiguate between signposts with the same name.
    ///   - format: A constant string or format string that produces a human-readable log message.
    ///   - arguments: If format is a constant string, do not specify arguments. If format is a format string, pass the expected number of arguments in the order that they appear in the string.
	@inlinable
	public func endEvent(name: StaticString,
	                     signpostID: UInt64? = nil,
	                     _ format: StaticString,
	                     _ arguments: CVarArg...) {
		signpost(type: .end,
		         name: name,
		         signpostID: signpostID,
		         format,
		         arguments)
	}
}

@available(iOS 12.0, tvOS 12.0, macOS 10.14, *)
extension Signpostable {
    /// A custom log object that can be passed to logging functions in order to send messages to the logging system.
    ///
    /// Custom log objects are identified by an identifier string (in reverse DNS notation, like com.your_company.your_subsystem_name) and a category for the logging subsystem. Both of these are used to categorize and filter related log messages and group related logging settings.
	@usableFromInline
	internal var osLog: OSLog {
		OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: .pointsOfInterest)
	}

    /// Returns OSSignpostID from UInt64 or OSLog
    ///
    /// OSSignpostID is an identifier you use to distinguish signposts that have the same name and that log to the same OSLog.
	@usableFromInline
	internal func makeSignpostID(_ id: UInt64?) -> OSSignpostID {
		if let id = id {
			return OSSignpostID(id)
		} else {
			return OSSignpostID(log: osLog)
		}
	}

    /// Marks a point of interest in your code as a time interval or as an event for debugging performance in Instruments, and includes a detailed message.
    ///
    /// Removes signpost if type is OSSignpostType.End.
    ///
    /// Adds signpost if type is OSSignpostType.Begin
    ///
    /// - Parameters:
    ///   -  type: The values that determine the role of a signpost.
    ///   - name: The name of the signpost.
    ///   - signpostID: A signpost identifier you use to disambiguate between signposts with the same name.
    ///   - format: A constant string or format string that produces a human-readable log message.
    ///   - arguments: If format is a constant string, do not specify arguments. If format is a format string, pass the expected number of arguments in the order that they appear in the string.
	@usableFromInline
	internal func signpost(type: OSSignpostType,
	                       name: StaticString,
	                       signpostID: UInt64?,
	                       _ format: StaticString,
	                       _ arguments: CVarArg...) {
		let signpost = type == .event ? makeSignpostID(signpostID) : add(signpostID)

		os_signpost(type,
		            log: osLog,
		            name: name,
		            signpostID: signpost,
		            format,
		            arguments)

		if type == .end { remove(signpost) }
	}

    
	fileprivate func add(_ signpostID: UInt64?) -> OSSignpostID {
		let signpost = makeSignpostID(signpostID)

		if let existSignpost = signposts.first(where: { $0 == signpost }) {
			return existSignpost
		}

		return signposts.insert(signpost).memberAfterInsert
	}

	fileprivate func remove(_ signpostID: OSSignpostID) {
		signposts.remove(signpostID)
	}
}

@available(iOS 12.0, tvOS 12.0, macOS 10.14, *)
private var signposts: Set<OSSignpostID> = []

@available(iOS 12.0, tvOS 12.0, macOS 10.14, *)
extension OSSignpostID: Hashable {
	@inlinable
	public func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
}

@available(iOS 12.0, tvOS 12.0, macOS 10.14, *)
extension Logger: Signpostable {}
