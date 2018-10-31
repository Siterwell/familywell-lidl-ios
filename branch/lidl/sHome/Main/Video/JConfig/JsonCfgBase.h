#pragma once
#import "FunSDK/JObject.h"
#include <string>
using namespace std;

#define CFG_CHN_NAME(x,y) JCFG::GetChnCfgName(x, y).c_str()
namespace JCFG
{
    string GetChnCfgName(const char *szCfgName, int nChnIndex);
}


