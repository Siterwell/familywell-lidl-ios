#import <Foundation/Foundation.h>
#import "NSSDKObject.h"
#import "SDKDataCenter.h"

// get from developer(open.xmeye.net)
const static char* constStrApiAppUuid = "784d254388d34038bb0ac802a7fd73df";
const static char* constStrApiAppKey = "ff567a38b75d44dfa6b8f6171bd90e8c";
const static char* constStrApiAppSecret = "c6716472c76a49769d9715039d1734df";
const static short constIntApiMoveCard = 3;

typedef enum EDevListMode{
    E_DevList_NONE,   // none
    E_DevList_Local,  // save devices information to local
    E_DevList_Server, // save devices information from sever
    E_DevList_AP      // connect ap-device
}EDevListMode;

@interface FunSupport : NSSDKObject
+ (FunSupport *)instance;

@property (atomic, assign) EDevListMode devListMode;

- (int)initSDK;     // init sdk
- (void)unInitSDK;

// set devices data base
- (void)initSys:(EDevListMode)mode;

//alarm fun init
- (int)alarmNetinit:(NSString*)deviceToken;
@end
