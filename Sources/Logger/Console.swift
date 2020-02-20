//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Foundation
import os.log

public final class Console<Category: CategoryKey>: Loggerable {
	public let logLevel: LogLevel
	public var disableSymbols: Set<String> = []

	@usableFromInline
	internal let access: AccessLevel

	@inlinable
	public init(level: LogLevel = .none, access: AccessLevel = .public) {
		self.logLevel = level
		self.access = access
	}

	@inlinable
	public func log(level: LogLevel,
	                access: AccessLevel?,
	                message: String,
	                category: Category,
	                userInfo: [AnyHashable: Any]?,
	                fileName: String,
	                functionName: String,
	                lineNumber: UInt) {
		guard let osLogType = level.osLogType else { return }

		let osLog = self.osLog(category: category)

		switch access ?? self.access {
		case .public:
			publicLog(osLog,
			          type: osLogType,
			          file: fileName,
			          line: "\(lineNumber)",
			          function: functionName,
			          level: level.description.uppercased(),
			          message: message,
			          userInfo: userInfo)
		case .private:
			privateLog(osLog,
			           type: osLogType,
			           file: fileName,
			           line: "\(lineNumber)",
			           function: functionName,
			           level: level.description.uppercased(),
			           message: message,
			           userInfo: userInfo)
		}
	}
}

extension Console {
	private var currentThread: String {
		if Thread.isMainThread { return "main" }
		if let threadName = Thread.current.name, !threadName.isEmpty {
			return threadName
		}
		if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)), !queueName.isEmpty {
			return queueName
		}

		return "\(Thread.current)"
	}

	@usableFromInline
	internal func osLog(category: Category) -> OSLog {
		OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: category.rawValue)
	}

	private func makePrivateOsLogString(includeUserInfo: Bool) -> StaticString {
		let staticString: StaticString
		if includeUserInfo {
			staticString = "[%{public}@] [%{private}@:%{private}@ %{private}@] %{public}@ > %{private}@\nUserInfo: %{private}@"
		} else {
			staticString = "[%{public}@] [%{private}@:%{private}@ %{private}@] %{public}@ > %{private}@"
		}

		return staticString
	}

	private func makePublicOsLogString(includeUserInfo: Bool) -> StaticString {
		let staticString: StaticString
		if includeUserInfo {
			staticString = "[%{public}@] [%{public}@:%{public}@ %{public}@] %{public}@ > %{public}@\nUserInfo: %{public}@"
		} else {
			staticString = "[%{public}@] [%{public}@:%{public}@ %{public}@] %{public}@ > %{public}@"
		}

		return staticString
	}

	@usableFromInline
	internal func privateLog(_ log: OSLog,
	                         type: OSLogType,
	                         file: String,
	                         line: String,
	                         function: String,
	                         level: String,
	                         message: String,
	                         userInfo: [AnyHashable: Any]? = [:]) {
		let string = makePrivateOsLogString(includeUserInfo: userInfo != nil)
		os_log(string,
		       log: log,
		       type: type,
		       currentThread,
		       file,
		       line,
		       function,
		       level,
		       message,
		       userInfo ?? "")
	}

	@usableFromInline
	internal func publicLog(_ log: OSLog,
	                        type: OSLogType,
	                        file: String,
	                        line: String,
	                        function: String,
	                        level: String,
	                        message: String,
	                        userInfo: [AnyHashable: Any]? = [:]) {
		let string = makePublicOsLogString(includeUserInfo: userInfo != nil)
		os_log(string,
		       log: log,
		       type: type,
		       currentThread,
		       file,
		       line,
		       function,
		       level,
		       message,
		       userInfo ?? "")
	}
}

extension LogLevel {
	@usableFromInline
	internal var osLogType: OSLogType? {
		switch self {
		case .`default`: return .default
		case .info: return .info
		case .debug: return .debug
		case .warning: return .error
		case .error: return .fault
		case .none: return nil
		}
	}
}
