#pragma once
#include "FunSDK/JObject.h"
#include "PowerSocketAutoLightItem.h"

#define JK_PowerSocket_AutoLight "PowerSocket.AutoLight" 
class PowerSocket_AutoLight : public JObject
{
public:
	JObjArray<PowerSocketAutoLightItem>		AutoLight;

public:
    PowerSocket_AutoLight(JObject *pParent = NULL, const char *szName = JK_PowerSocket_AutoLight):
    JObject(pParent,szName),
	AutoLight(this, ""){
	};

    ~PowerSocket_AutoLight(void){};
};
