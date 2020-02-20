//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

public protocol CategoryKey: ExpressibleByStringLiteral, RawRepresentable where RawValue == String {
	static var `default`: Self { get }
}

extension CategoryKey {
	@usableFromInline
	internal init(_ stringValue: String) {
		self = Self(rawValue: stringValue) ?? Self.default
	}

	@inlinable
	public init(stringLiteral value: RawValue) {
		self = Self(value)
	}
}
