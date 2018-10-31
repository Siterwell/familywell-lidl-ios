#include "JsonCfgBase.h"

string JCFG::GetChnCfgName(const char *szCfgName, int nChnIndex)
{
    char szName[64];
    snprintf(szName, 64, "%s.[%d]", szCfgName, nChnIndex);
    return szName;
}
