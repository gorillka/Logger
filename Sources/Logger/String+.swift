//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Foundation

extension String {
	@usableFromInline
	internal var objectName: String {
		((self as NSString).lastPathComponent as NSString).deletingPathExtension
	}
}
