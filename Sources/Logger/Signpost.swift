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
	@inlinable
	public func event(name: StaticString,
	                  signpostID: UInt64? = nil) {
		event(name: name,
		      signpostID: signpostID,
		      "",
		      [])
	}

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

	@inlinable
	public func beginEvent(name: StaticString,
	                       signpostID: UInt64? = nil) {
		beginEvent(name: name,
		           signpostID: signpostID,
		           "",
		           [])
	}

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

	@inlinable
	public func endEvent(name: StaticString,
	                     signpostID: UInt64? = nil) {
		endEvent(name: name,
		         signpostID: signpostID,
		         "",
		         [])
	}

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
	@usableFromInline
	internal var osLog: OSLog {
		OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: .pointsOfInterest)
	}

	@usableFromInline
	internal func makeSignpostID(_ id: UInt64?) -> OSSignpostID {
		if let id = id {
			return OSSignpostID(id)
		} else {
			return OSSignpostID(log: osLog)
		}
	}

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
