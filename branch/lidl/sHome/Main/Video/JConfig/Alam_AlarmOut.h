#pragma once
#import <FunSDK/Jobject.h>

#import "AlarmOut.h"
#define JK_Alam_AlarmOut "Alam_AlarmOut" 
class Alam_AlarmOut : public JObject
{
public:
	JObjArray<AlarmOut>		Alarm_AlarmOut;

public:
    Alam_AlarmOut():
    JObject(NULL,""),
	Alarm_AlarmOut(this, "Alarm.AlarmOut"){
	};

    ~Alam_AlarmOut(void){};
};