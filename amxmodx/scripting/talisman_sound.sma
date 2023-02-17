#include <tl_api>
#include <ini_file>

new const FileName[] = "talisman";
new const Section[] = "Sounds";

#define SOUND_MAX_LENGTH 64

new const SoundList[][] = {
	"talisman/talisman.wav"
}

new Array:g_SoundArray;

public plugin_precache(){
    g_SoundArray = ArrayCreate(SOUND_MAX_LENGTH, 1);
    ini_read_string_array(FileName, Section, "SoundList", g_SoundArray);

    new sound[SOUND_MAX_LENGTH], i;

    if (ArraySize(g_SoundArray) == 0)
    {
        for (i = 0; i < sizeof(SoundList); i++)
            ArrayPushString(g_SoundArray, SoundList[i]);

        ini_write_string_array(FileName, Section, "SoundList", g_SoundArray);
    }

    for(i = 0; i < ArraySize(g_SoundArray); i++){
        ArrayGetString(g_SoundArray, i, sound, charsmax(sound));
        precache_sound(sound);
	}
}

public plugin_init()
{
    register_plugin("[RE] Talisman Sound", PLUGIN_VERSION, "BiZaJe")

}

public give_talisman(){
    static sound[SOUND_MAX_LENGTH]
    ArrayGetString(g_SoundArray, random_num(0, ArraySize(g_SoundArray) - 1), sound, charsmax(sound));
    rg_send_audio(player_is_talisman(), sound);
}

public rise_talisman_post(iPlayer){
    static sound[SOUND_MAX_LENGTH]
    ArrayGetString(g_SoundArray, random_num(0, ArraySize(g_SoundArray) - 1), sound, charsmax(sound));
    rg_send_audio(iPlayer, sound);
}

public plugin_end(){
    ArrayDestroy(g_SoundArray);
}
