#pragma once
#import <FunSDK/JObject.h>
#include "EventHandler.h"

#define JK_Alarm_LocalAlarm "Alarm.LocalAlarm" 
class Alarm_LocalAlarm : public JObject
{
public:
	JBoolObj		Enable;
	EventHandler		mEventHandler;
	JStrObj		SensorType;

public:
    Alarm_LocalAlarm(JObject *pParent = NULL, const char *szName = JK_Alarm_LocalAlarm):
    JObject(pParent,szName),
	Enable(this, "Enable"),
	mEventHandler(this, "EventHandler"),
	SensorType(this, "SensorType"){
	};

    ~Alarm_LocalAlarm(void){};
};