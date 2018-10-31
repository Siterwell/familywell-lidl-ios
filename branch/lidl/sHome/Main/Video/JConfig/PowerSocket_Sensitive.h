#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocket_Sensitive "PowerSocket.Sensitive" 
class PowerSocket_Sensitive : public JObject
{
public:
	JIntObj		Sensitive;

public:
    PowerSocket_Sensitive(JObject *pParent = NULL, const char *szName = JK_PowerSocket_Sensitive):
    JObject(pParent,szName),
	Sensitive(this, "Sensitive"){
	};

    ~PowerSocket_Sensitive(void){};
};
