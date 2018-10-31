#import "FunSDK/FunSDK.h"
#import "FUnSDK/Fun_MC.h"
#import "FunSupport.h"
#import "GUI.h"
#import "SDKDataCenter.h"


@implementation FunSupport

+ (FunSupport *)instance{
    static FunSupport* sharedSupport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSupport = [[self alloc] init];
    });
    
    return sharedSupport;
}


- (int)initSDK{
    SInitParam pa;
    if (true)  {
        strcpy(pa.sLanguage, "zh");
    } else {
        strcpy(pa.sLanguage, "en");
    }
    strcpy(pa.nSource, "xmshop");
    pa.nAppType = H264_DVR_LOGIN_TYPE_MOBILE;
    FUN_Init(0, &pa);
    self.devListMode = E_DevList_NONE;
#if DEBUG
    Fun_LogInit(SDK_HANDLE, "", 0, "", LOG_UI_MSG);
#endif
    // 设备密码存储文件配置
    NSString *filePath = [NSString GetDocumentPath:@"password.txt"];
    
    FUN_SetFunStrAttr(EFUN_ATTR_USER_PWD_DB, SZSTR(filePath));
    
    FUN_InitNetSDK();
    
    //设置配置文件存储目录
    filePath = [NSString GetDocumentPath:@"Configs/"];
    FUN_SetFunStrAttr(EFUN_ATTR_CONFIG_PATH, SZSTR(filePath));
    
    //设置升级文件存储目录
    filePath = [NSString GetDocumentPath:@"Updates/"];
    FUN_SetFunStrAttr(EFUN_ATTR_UPDATE_FILE_PATH, SZSTR(filePath));
    
    //设置临时文件存储目录
    filePath = [NSString GetDocumentPath:@"Temps/"];
    FUN_SetFunStrAttr(EFUN_ATTR_TEMP_FILES_PATH, SZSTR(filePath));
    
    //填写开放平台申请到的uuid， appkey等。
    FUN_XMCloundPlatformInit(constStrApiAppUuid,
                             constStrApiAppKey,
                             constStrApiAppSecret,
                             constIntApiMoveCard);
//    FUN_XMCloundPlatformInit("xmeye", "88335f705ffc4652b22971ce9fe18157", "5a5e852094e349099e7aeca96e60be54", 9);
    
    //用户注册等相关接口需要先设置下云服务
    [self initSys:E_DevList_Server];
    return 0;
}

- (void)unInitSDK{
    FUN_UnInit();
}

- (void)initSys:(EDevListMode)mode{
    if (self.devListMode == mode) {
        return;
    }
    self.devListMode = mode;
    
    //设置用于存储设备信息等的数据配置文件
    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* path = [pathArray lastObject];
    
    if (E_DevList_Local == mode) {
        FUN_SysInit([[path stringByAppendingString:@"/LocalDevs.db"] UTF8String]);
    } else if (E_DevList_Server == mode) {
        FUN_SysInit("", 0);
    } else if (E_DevList_AP == mode) {
        FUN_SysInitAsAPModel([[path stringByAppendingString:@"/APDevs.db"] UTF8String]);
    }
}

//Init alram
- (int)alarmNetinit:(NSString*)deviceToken{
    if (deviceToken.length == 0) {
        return -1;
    }
    
    SMCInitInfo pinfo = { 0 };
    STRNCPY(pinfo.user, SZSTR(DATACENTER.loginUserName));
    STRNCPY(pinfo.password, SZSTR(DATACENTER.loginPassword));
    STRNCPY(pinfo.token, SZSTR(deviceToken));
    STRNCPY(pinfo.szAppType, "");
    if (false) {
        pinfo.language = ELG_CHINESE;
    } else {
        pinfo.language = ELG_ENGLISH;
    }
    
    return MC_Init(SDK_HANDLE, &pinfo, 0);
}


@end
