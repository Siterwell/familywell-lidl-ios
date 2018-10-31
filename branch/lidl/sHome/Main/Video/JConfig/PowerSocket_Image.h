#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocket_Image "PowerSocket.Image" 
class PowerSocket_Image : public JObject
{
public:
	JIntObj		flip;

public:
    PowerSocket_Image(JObject *pParent = NULL, const char *szName = JK_PowerSocket_Image):
    JObject(pParent,szName),
	flip(this, "flip"){
	};

    ~PowerSocket_Image(void){};
};
