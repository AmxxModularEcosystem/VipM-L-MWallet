#include <amxmodx>
#include <json>
#include <VipModular>
#include <ModularWallet>

#pragma semicolon 1
#pragma compress 1

public stock const PluginName[] = "[VipM-L] CWAPI";
public stock const PluginVersion[] = "1.0.0";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "https://github.com/AmxxModularEcosystem/VipM-L-MWallet";
public stock const PluginDescription[] = "[VipModular-Limit] Modular Wallet.";

new const LIMIT_NAME[] = "MWallet-Enough";

public VipM_IC_OnInitTypes() {
    register_plugin(PluginName, PluginVersion, PluginAuthor);
    
    VipM_Limits_RegisterType(LIMIT_NAME, true, false);
    VipM_Limits_AddTypeParams(LIMIT_NAME,
        "Currency", ptString, true,
        "Amount", ptFloat, true
    );

    VipM_Limits_RegisterTypeEvent(LIMIT_NAME, Limit_OnRead, "@OnEnoughRead");
    VipM_Limits_RegisterTypeEvent(LIMIT_NAME, Limit_OnCheck, "@OnEnoughCheck");
}

@OnEnoughRead(const JSON:jLimit, const Trie:tParams) {
    new sCurrencyName[MWALLET_CURRENCY_MAX_NAME_LEN];
    TrieGetString(tParams, "Currecny", sCurrencyName, charsmax(sCurrencyName));

    new T_Currency:iCurrency = MWallet_Currency_Find(sCurrencyName);
    if (iCurrency == Invalid_Currency) {
        VipM_Json_LogForFile(jLimit, "WARNING", "Currency '%s' not found.", iCurrency);
        return VIPM_STOP;
    }

    TrieSetCell(tParams, "Currecny", iCurrency, true);

    return VIPM_CONTINUE;
}

@OnEnoughCheck(const Trie:tParams, const UserId) {
    return MWallet_Currency_IsEnough(
        VipM_Params_GetCell(tParams, "Currency"),
        UserId,
        VipM_Params_GetFloat(tParams, "Amount")
    );
}
