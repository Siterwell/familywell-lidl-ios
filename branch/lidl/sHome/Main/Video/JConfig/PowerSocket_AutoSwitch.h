#pragma once
#include "FunSDK/JObject.h"
#include "PowerSocketAutoSwitchItem.h"
#define JK_PowerSocket_AutoSwitch "PowerSocket.AutoSwitch" 
class PowerSocket_AutoSwitch : public JObject
{
public:
	JObjArray<PowerSocketAutoSwitchItem>		AutoSwitch;

public:
    PowerSocket_AutoSwitch(JObject *pParent = NULL, const char *szName = JK_PowerSocket_AutoSwitch):
    JObject(pParent,szName),
	AutoSwitch(this, ""){
	};

    ~PowerSocket_AutoSwitch(void){};
};
