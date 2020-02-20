/// Logging levels supported by the package.
///
/// A log type controls the conditions under which a message should be logged. To send a message at a specific level to the logging.
public enum LogLevel: Int {
	/// The default log level.
	///
	/// Use this level to capture information about things that might result a failure.
	case `default` = 0

	/// The info log level.
	///
	/// Use this level to capture information that may be helpful, but isn’t essential, for troubleshooting errors.
	case info

	/// The debug log level.
	///
	/// Use this level to capture information that may be useful during development or while troubleshooting a specific problem.
	case debug

	/// The warning log level.
	///
	/// Use this log level to capture process-level information to report errors in the process.
	case warning

	/// The error log level.
	///
	/// Use this level to capture system-level or multi-process information to report system errors.
	case error

	/// The none log level.
	///
	/// Use this level to skip any logging.
	case none
}

extension LogLevel: Comparable {
	public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

extension LogLevel: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {
		case .`default`: return "verbose"
		case .info: return "info"
		case .debug: return "debug"
		case .warning: return "warning"
		case .error: return "error"
		case .none: return "none"
		}
	}

	/// A textual representation of this instance, suitable for debugging.
	public var description: String { debugDescription }
}
