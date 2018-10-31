#pragma once
#import "FunSDK/JObject.h"
#define JK_BroadTrends "BroadTrends" 
class BroadTrends : public JObject
{
public:
	JIntObj		AutoGain;
	JIntObj		Gain;

public:
    BroadTrends(JObject *pParent = NULL, const char *szName = JK_BroadTrends):
    JObject(pParent,szName),
	AutoGain(this, "AutoGain"),
	Gain(this, "Gain"){
	};

    ~BroadTrends(void){};
};