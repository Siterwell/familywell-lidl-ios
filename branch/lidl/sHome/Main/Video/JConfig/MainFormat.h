#pragma once
#import "FunSDK/JObject.h"
#include "Video.h"

#define JK_MainFormat "MainFormat" 
class MainFormat : public JObject  //主码流配置
{
public:
	JBoolObj		AudioEnable;
	Video		mVideo;
	JBoolObj		VideoEnable;

public:
	MainFormat(JObject *pParent = NULL, const char *szName = JK_MainFormat):
	JObject(pParent,szName),
	AudioEnable(this, "AudioEnable"),
	mVideo(this, "Video"),
	VideoEnable(this, "VideoEnable"){
	};

	~MainFormat(void){};
};