//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

public protocol Loggerable {
	associatedtype Category: CategoryKey

	var logLevel: LogLevel { get }
	var disableSymbols: Set<String> { get set }

	func log(level: LogLevel,
	         access: AccessLevel?,
	         message: String,
	         category: Category,
	         userInfo: [AnyHashable: Any]?,
	         fileName: String,
	         functionName: String,
	         lineNumber: UInt)
}

extension Loggerable {
    /// Loges
    ///
    /// - Parameters:
    ///   - level: The log level that will be used for logged message.
    ///   - access: Access level describing publiicity of the logged message.
    ///   - message: The message to be logged.
    ///   - category: Custom category of the logged message.
    ///   - userInfo: Additional custom info..
    ///   - fileName: Root file name of the log.
    ///   - functionName: Root function name of the log.
    ///   - lineNumber: Line number if the log.
	@usableFromInline
	internal func log(_ level: LogLevel,
	                  access: AccessLevel?,
	                  message: String,
	                  category: Category,
	                  userInfo: [AnyHashable: Any]?,
	                  fileName: String,
	                  functionName: String,
	                  lineNumber: UInt) {
		guard level >= logLevel,
			isLogAllowed(category: category, objectName: fileName.objectName) else { return }

		log(level: level,
		    access: access,
		    message: message,
		    category: category,
		    userInfo: userInfo,
		    fileName: fileName.objectName,
		    functionName: functionName,
		    lineNumber: lineNumber)
	}
}

extension Loggerable {
	@inlinable
	public mutating func ignore(objects: [Any]) {
		disableSymbols = disableSymbols.union(objects.map { String(describing: type(of: $0)) })
	}

	@inlinable
	public mutating func ignore(categories: [Category]) {
		disableSymbols = disableSymbols.union(categories.map { $0.rawValue })
	}

	@usableFromInline
	internal func isLogAllowed(category: Category, objectName: String) -> Bool {
		!disableSymbols.contains(category.rawValue) && !disableSymbols.contains(objectName)
	}
}

public struct AnyLogger<Category: CategoryKey> {
	@usableFromInline
	internal let box: LoggerBoxBase<Category>

	@inlinable
	internal init<LoggerType: Loggerable>(_ logger: LoggerType) where Category == LoggerType.Category {
		self.box = LoggerBox(base: logger)
	}
}

extension AnyLogger: Loggerable {
	@inlinable
	public var logLevel: LogLevel { box.logLevel }

	@inlinable
	public var disableSymbols: Set<String> {
		get { box.disableSymbols }
		set { box.disableSymbols = newValue }
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
		box.log(level: level,
		        access: access,
		        message: message,
		        category: category,
		        userInfo: userInfo,
		        fileName: fileName,
		        functionName: functionName,
		        lineNumber: lineNumber)
	}
}

@usableFromInline
internal class LoggerBoxBase<Category: CategoryKey>: Loggerable {
	@usableFromInline
	internal var logLevel: LogLevel { abstractMethod() }

	@usableFromInline
	internal var disableSymbols: Set<String> {
		get { abstractMethod() }
		set { abstractMethod() }
	}

	@inlinable
	internal init() {}

	@usableFromInline
	internal func log(level: LogLevel,
	                  access: AccessLevel?,
	                  message: String,
	                  category: Category,
	                  userInfo: [AnyHashable: Any]?,
	                  fileName: String,
	                  functionName: String,
	                  lineNumber: UInt) {
		abstractMethod()
	}
}

@usableFromInline
internal final class LoggerBox<LoggerType: Loggerable>: LoggerBoxBase<LoggerType.Category> {
	@usableFromInline
	internal override var logLevel: LogLevel { base.logLevel }

	@usableFromInline
	internal override var disableSymbols: Set<String> {
		get { base.disableSymbols }
		set { base.disableSymbols = newValue }
	}

	@usableFromInline
	internal private(set) var base: LoggerType

	@usableFromInline
	internal init(base: LoggerType) {
		self.base = base

		super.init()
	}

	@inlinable
	internal override func log(level: LogLevel,
	                           access: AccessLevel?,
	                           message: String,
	                           category: Category,
	                           userInfo: [AnyHashable: Any]?,
	                           fileName: String,
	                           functionName: String,
	                           lineNumber: UInt) {
		base.log(level: level,
		         access: access,
		         message: message,
		         category: category,
		         userInfo: userInfo,
		         fileName: fileName,
		         functionName: functionName,
		         lineNumber: lineNumber)
	}
}

extension Loggerable {
	@inlinable
	public func verbose(message: String,
	                    category: Category = .default,
	                    userInfo: [AnyHashable: Any]? = nil,
	                    access: AccessLevel? = nil,
	                    fileName: String = #file,
	                    functionName: String = #function,
	                    lineNumber: UInt = #line) {
		log(.default,
		    access: access,
		    message: message,
		    category: category,
		    userInfo: userInfo,
		    fileName: fileName,
		    functionName: functionName,
		    lineNumber: lineNumber)
	}

	@inlinable
	public func info(message: String,
	                 category: Category = .default,
	                 userInfo: [AnyHashable: Any]? = nil,
	                 access: AccessLevel? = nil,
	                 fileName: String = #file,
	                 functionName: String = #function,
	                 lineNumber: UInt = #line) {
		log(.info,
		    access: access,
		    message: message,
		    category: category,
		    userInfo: userInfo,
		    fileName: fileName,
		    functionName: functionName,
		    lineNumber: lineNumber)
	}

	@inlinable
	public func debug(message: String,
	                  category: Category = .default,
	                  userInfo: [AnyHashable: Any]? = nil,
	                  access: AccessLevel? = nil,
	                  fileName: String = #file,
	                  functionName: String = #function,
	                  lineNumber: UInt = #line) {
		log(.debug,
		    access: access,
		    message: message,
		    category: category,
		    userInfo: userInfo,
		    fileName: fileName,
		    functionName: functionName,
		    lineNumber: lineNumber)
	}

	@inlinable
	public func warning(message: String,
	                    category: Category = .default,
	                    userInfo: [AnyHashable: Any]? = nil,
	                    access: AccessLevel? = nil,
	                    fileName: String = #file,
	                    functionName: String = #function,
	                    lineNumber: UInt = #line) {
		log(.warning,
		    access: access,
		    message: message,
		    category: category,
		    userInfo: userInfo,
		    fileName: fileName,
		    functionName: functionName,
		    lineNumber: lineNumber)
	}

	@inlinable
	public func error(message: String,
	                  category: Category = .default,
	                  userInfo: [AnyHashable: Any]? = nil,
	                  access: AccessLevel? = nil,
	                  fileName: String = #file,
	                  functionName: String = #function,
	                  lineNumber: UInt = #line) {
		log(.error,
		    access: access,
		    message: message,
		    category: category,
		    userInfo: userInfo,
		    fileName: fileName,
		    functionName: functionName,
		    lineNumber: lineNumber)
	}
}
