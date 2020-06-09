//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Foundation

extension String {
    /// Returns last path component from file's name full path.
    ///
    /// E.g. ViewController.swift instead of somepath/ViewController.swift
	internal var objectName: String {
		((self as NSString).lastPathComponent as NSString).deletingPathExtension
	}
}

