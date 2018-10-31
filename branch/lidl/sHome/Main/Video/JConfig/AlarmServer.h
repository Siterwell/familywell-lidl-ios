#pragma once
#import <FunSDK/Jobject.h>
#include "Server.h"

#define JK_AlarmServer ""
class AlarmServer : public JObject
{
public:
	JBoolObj		Alarm;
	JBoolObj		Enable;
	JBoolObj		Log;
	JStrObj		Protocol;
	Server		mServer;

public:
    AlarmServer(JObject *pParent = NULL, const char *szName = JK_AlarmServer):
    JObject(pParent,szName),
	Alarm(this, "Alarm"),
	Enable(this, "Enable"),
	Log(this, "Log"),
	Protocol(this, "Protocol"),
	mServer(this, "Server"){
	};

    ~AlarmServer(void){};
};
