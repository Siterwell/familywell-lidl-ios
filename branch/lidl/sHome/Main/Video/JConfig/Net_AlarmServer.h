#pragma once

#import "AlarmServer.h"
#import <FunSDK/Jobject.h>

#define JK_Net_AlarmServer "NetWork.AlarmServer"
class Net_AlarmServer : public JObject
{
public:
	JObjArray<AlarmServer>		params;

public:
    Net_AlarmServer():
    JObject(NULL, ""),
	params(this, JK_Net_AlarmServer){
	};

    ~Net_AlarmServer(void){};
};
