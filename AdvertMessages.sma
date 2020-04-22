#include <amxmodx>
#include <json>

#pragma semicolon 1

const MSG_LENGTH = 189;
new const CHAT_PREFIX[] = "^4[^3Advert^4]^3";

new Array:MessagesList;
new Float:MessagesDelay;
new LastMsgId;

new const PLUG_NAME[] = "Advert Messages";
new const PLUG_VER[] = "1.0.0";

public plugin_init(){
    register_plugin(PLUG_NAME, PLUG_VER, "ArKaNeMaN");

    register_srvcmd("AdvertMessages_ReloadConfig", "SrvCmd_ReloadConfig");

    InitCvars();
    LoadMessages();
}

public plugin_cfg(){
    set_task(MessagesDelay, "Task_WriteMessage");
}

public SrvCmd_ReloadConfig(){
    LoadMessages();
}

public Task_WriteMessage(){
    LastMsgId++;
    if(LastMsgId >= ArraySize(MessagesList))
        LastMsgId = 0;

    static Msg[MSG_LENGTH]; ArrayGetString(MessagesList, LastMsgId, Msg, charsmax(Msg));
    FormatMessage(Msg);
    for(new UserId = 1; UserId <= MAX_PLAYERS; UserId++)
        if(is_user_connected(UserId))
            client_print_color(UserId, print_team_default, fmt("%s %s", CHAT_PREFIX, Msg));
    
    set_task(MessagesDelay, "Task_WriteMessage");
}

FormatMessage(Msg[MSG_LENGTH]){
    replace_all(Msg, MSG_LENGTH, "!t", "^3");
    replace_all(Msg, MSG_LENGTH, "!n", "^1");
    replace_all(Msg, MSG_LENGTH, "!g", "^4");
}

InitCvars(){
    bind_pcvar_float(create_cvar(
        "AdvertMessages_MessagesDelay", "30.0", FCVAR_NONE,
        "Интервал между рекламными сообщениями",
        true, 5.0
    ), MessagesDelay);

    AutoExecConfig(true, "Cvars", "AdvertMessages");
}

LoadMessages(){
    if(MessagesList != Invalid_Array)
        ArrayDestroy(MessagesList);
    MessagesList = ArrayCreate(MSG_LENGTH, 16);

    new File[PLATFORM_MAX_PATH];
    get_localinfo("amxx_configsdir", File, charsmax(File));
    add(File, charsmax(File), "/plugins/AdvertMessages/Messages.json");
    if(!file_exists(File)){
        set_fail_state("[ERROR] Config file '%s' not found", File);
        return;
    }
    
    new JSON:List = json_parse(File, true);
    if(!json_is_array(List)){
        json_free(List);
        set_fail_state("[ERROR] Invalid config structure. File '%s'.", File);
        return;
    }

    new Msg[MSG_LENGTH];
    for(new i = 0; i < json_array_get_count(List); i++){
        json_array_get_string(List, i, Msg, charsmax(Msg));
        ArrayPushString(MessagesList, Msg);
    }
    server_print("[%s v%s] %d advert messages loaded.", PLUG_NAME, PLUG_VER, ArraySize(MessagesList));
}