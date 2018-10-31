#pragma once
#import <FunSDK/Jobject.h>
#include "OPPTZControl.h"
#import "Parameter.h"
#include "JsonCfgBase.h"

#define JK_OPPTZControl "OPPTZControl" 
class OPPTZControl : public JObject
{
public:
//	OPPTZControl		mOPPTZControl;
    Parameter		mParameter;
    JStrObj		Command;

public:
    OPPTZControl():
    JObject(),
	mParameter(this, "Parameter"),
    Command(this,"Command")
    {};

    ~OPPTZControl(void){};
};

