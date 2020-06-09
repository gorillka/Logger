//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

/// Access levels supported by the package.
///
/// - Note: Both messages logged with 'public' or 'private' access level will be visible via Xcode console or Console.app. However, opening the app while no debugger is attached will  display parameters marked with 'private' access level as \<private\> in the Console.app.
public enum AccessLevel: String {
	case `public`, `private`
}
