#pragma once
#include "FunSDK/JObject.h"

#define JK_NetWork_SPVMN "NetWork.SPVMN"
class NetWork_SPVMN : public JObject
{
public:
	JObjArray<JIntObj>		AlarmLevel;
	JObjArray<JStrObj>		Alarmid;
	JObjArray<JIntObj>		CamreaLevel;
	JObjArray<JStrObj>		Camreaid;
	JBoolObj		bCsEnable;
	JIntObj		iHsIntervalTime;
	JIntObj		iRsAgedTime;
	JIntObj		sCsPort;
	JIntObj		sUdpPort;
	JStrObj		szConnPass;
	JStrObj		szCsIP;
	JStrObj		szDeviceNO;
	JStrObj		szServerDn;
	JStrObj		szServerNo;
	JStrObj		uiAlarmStateBlindEnable;
	JStrObj		uiAlarmStateConnectEnable;
	JStrObj		uiAlarmStateGpinEnable;
	JStrObj		uiAlarmStateLoseEnable;
	JStrObj		uiAlarmStateMotionEnable;
	JStrObj		uiAlarmStatePerformanceEnable;

public:
    NetWork_SPVMN(JObject *pParent = NULL, const char *szName = JK_NetWork_SPVMN):
    JObject(pParent,szName),
	AlarmLevel(this, "AlarmLevel"),
	Alarmid(this, "Alarmid"),
	CamreaLevel(this, "CamreaLevel"),
	Camreaid(this, "Camreaid"),
	bCsEnable(this, "bCsEnable"),
	iHsIntervalTime(this, "iHsIntervalTime"),
	iRsAgedTime(this, "iRsAgedTime"),
	sCsPort(this, "sCsPort"),
	sUdpPort(this, "sUdpPort"),
	szConnPass(this, "szConnPass"),
	szCsIP(this, "szCsIP"),
	szDeviceNO(this, "szDeviceNO"),
	szServerDn(this, "szServerDn"),
	szServerNo(this, "szServerNo"),
	uiAlarmStateBlindEnable(this, "uiAlarmStateBlindEnable"),
	uiAlarmStateConnectEnable(this, "uiAlarmStateConnectEnable"),
	uiAlarmStateGpinEnable(this, "uiAlarmStateGpinEnable"),
	uiAlarmStateLoseEnable(this, "uiAlarmStateLoseEnable"),
	uiAlarmStateMotionEnable(this, "uiAlarmStateMotionEnable"),
	uiAlarmStatePerformanceEnable(this, "uiAlarmStatePerformanceEnable"){
	};

    ~NetWork_SPVMN(void){};
};
