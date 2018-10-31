#pragma once
#include "LightOnSec.h"
#define JK_Camera_FishEye "Camera.FishEye"
class Camera_FishEye : public JObject
{
public:
	JIntObj	Duty;
    JIntObj	AppType;
    JIntObj	Secene;  // 鱼眼模式 360VR 180VR....
    JIntObj	WorkMode;

    LightOnSec lightOnSec;
    
public:
    Camera_FishEye(JObject *pParent = NULL, const char *szName = JK_Camera_FishEye):
    JObject(pParent,szName),
    lightOnSec(this, "LightOnSec"),
    Duty(this, "Duty"),
    AppType(this, "AppType"),
    Secene(this, "Secene"),
    WorkMode(this, "WorkMode"){
	};

    ~Camera_FishEye(void){};
};