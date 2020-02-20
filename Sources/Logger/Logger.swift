//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

public struct Logger<Category: CategoryKey>: Loggerable {
	public let logLevel: LogLevel
	public var disableSymbols: Set<String> = []

	@usableFromInline
	internal let loggers: [AnyLogger<Category>]

	@inlinable
	public init(_ category: Category.Type, level: LogLevel = .none, loggers: [AnyLogger<Category>] = []) {
		self.logLevel = level
		self.loggers = loggers
	}

	@inlinable
	public func add<T: Loggerable>(_ logger: T) -> Logger
		where Category == T.Category {
		var loggers = self.loggers
		loggers.append(AnyLogger(logger))

		var logger = Logger(Category.self, level: logLevel, loggers: loggers)
		logger.disableSymbols = disableSymbols

		return logger
	}

	@inlinable
	public func log(level: LogLevel,
	                access: AccessLevel?,
	                message: String,
	                category: Category,
	                userInfo: [AnyHashable: Any]?,
	                fileName: String = #file,
	                functionName: String = #function,
	                lineNumber: UInt = #line) {
		notifyLoggers(level: level,
		              access: access,
		              message: message,
		              category: category,
		              userInfo: userInfo,
		              fileName: fileName,
		              functionName: functionName,
		              lineNumber: lineNumber)
	}

	@usableFromInline
	internal func notifyLoggers(level: LogLevel,
	                            access: AccessLevel?,
	                            message: String,
	                            category: Category,
	                            userInfo: [AnyHashable: Any]?,
	                            fileName: String,
	                            functionName: String,
	                            lineNumber: UInt) {
		loggers
			.filter { level >= $0.logLevel && $0.isLogAllowed(category: category, objectName: fileName) }
			.forEach { $0.log(level,
			                  access: access,
			                  message: message,
			                  category: category,
			                  userInfo: userInfo,
			                  fileName: fileName,
			                  functionName: functionName,
			                  lineNumber: lineNumber) }
	}
}
