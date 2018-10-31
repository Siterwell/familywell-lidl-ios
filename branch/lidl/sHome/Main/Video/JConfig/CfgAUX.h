#pragma once
#import <FunSDK/Jobject.h>

#define JK_AUX "AUX" 
class AUX : public JObject
{
public:
	JIntObj		Number;
	JStrObj		Status;

public:
    AUX(JObject *pParent = NULL, const char *szName = JK_AUX):
    JObject(pParent,szName),
	Number(this, "Number"),
	Status(this, "Status"){
	};

    ~AUX(void){};
};