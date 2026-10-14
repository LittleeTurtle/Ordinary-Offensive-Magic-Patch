-- author : BeerShigachi/LittleeTurtle
-- date : 14 October 2026
-- version : 2.5.0

-- CONFIG: every values have to be float number. use float like 1.0 not 1.
local POWER_ATTACK_CHARGE_PERIOD = 3.0 -- 1.0 as default. longer charging period results higher damage.
local RAPID_CHARGE_PERIOD = 0.75 -- 1.0 as default
local COMBO_INTERVAL = 0.2 -- default: 0.28
local COMBO_ATTACK_RATE = 1.0 -- defalut: 1.0
local POWER_ATTACK_RATE = 1.2 -- defalut: 1.0: CAUTION: set this value too high result OP!
local BURST_BOLT_EXPLOSION_RATE = 0.9 -- defalut: 1.0: Burst bolt blob's exlosion. to avoid OP set around 0.9
local ALLIVIATE_STAMINA_COST = 100.0 -- higher value expend less stamina.
local DELAY_EXPLOSION = 0.5 -- default: 3.0 :set lower for insta explosion. require restart the game.

-- CONFIG: VFX_SIZE_SCALE
local NORMAL_SHOT_SCALE_X = 1.0
local NORMAL_SHOT_SCALE_Y = 1.0
local NORMAL_SHOT_SCALE_Z = 1.0
local RAPID_CHARGE_SHOT_SCALE_X = 1.0
local RAPID_CHARGE_SHOT_SCALE_Y = 1.0
local RAPID_CHARGE_SHOT_SCALE_Z = 1.0
local POWER_SHOT_SCALE_X = 1.0
local POWER_SHOT_SCALE_Y = 1.0
local POWER_SHOT_SCALE_Z = 1.0
local BURST_BLOB_SCALE_X = 1.0
local BURST_BLOB_SCALE_Y = 1.0
local BURST_BLOB_SCALE_Z = 1.0
local BURST_EXPLOSION_SCALE_X = 3.0
local BURST_EXPLOSION_SCALE_Y = 3.0
local BURST_EXPLOSION_SCALE_Z = 3.0

-- Persistent configuration. REFramework writes this JSON file under its config folder.
local CONFIG_FILE = "OrdinaryOffensiveMagic_config.json"
local config_dirty = false

local function save_config()
    if not json or not json.dump_file then return end
    json.dump_file(CONFIG_FILE, {
        POWER_ATTACK_CHARGE_PERIOD = POWER_ATTACK_CHARGE_PERIOD,
        RAPID_CHARGE_PERIOD = RAPID_CHARGE_PERIOD,
        COMBO_INTERVAL = COMBO_INTERVAL,
        COMBO_ATTACK_RATE = COMBO_ATTACK_RATE,
        POWER_ATTACK_RATE = POWER_ATTACK_RATE,
        BURST_BOLT_EXPLOSION_RATE = BURST_BOLT_EXPLOSION_RATE,
        ALLIVIATE_STAMINA_COST = ALLIVIATE_STAMINA_COST,
        DELAY_EXPLOSION = DELAY_EXPLOSION,
        NORMAL_SHOT_SCALE_X = NORMAL_SHOT_SCALE_X,
        NORMAL_SHOT_SCALE_Y = NORMAL_SHOT_SCALE_Y,
        NORMAL_SHOT_SCALE_Z = NORMAL_SHOT_SCALE_Z,
        RAPID_CHARGE_SHOT_SCALE_X = RAPID_CHARGE_SHOT_SCALE_X,
        RAPID_CHARGE_SHOT_SCALE_Y = RAPID_CHARGE_SHOT_SCALE_Y,
        RAPID_CHARGE_SHOT_SCALE_Z = RAPID_CHARGE_SHOT_SCALE_Z,
        POWER_SHOT_SCALE_X = POWER_SHOT_SCALE_X,
        POWER_SHOT_SCALE_Y = POWER_SHOT_SCALE_Y,
        POWER_SHOT_SCALE_Z = POWER_SHOT_SCALE_Z,
        BURST_BLOB_SCALE_X = BURST_BLOB_SCALE_X,
        BURST_BLOB_SCALE_Y = BURST_BLOB_SCALE_Y,
        BURST_BLOB_SCALE_Z = BURST_BLOB_SCALE_Z,
        BURST_EXPLOSION_SCALE_X = BURST_EXPLOSION_SCALE_X,
        BURST_EXPLOSION_SCALE_Y = BURST_EXPLOSION_SCALE_Y,
        BURST_EXPLOSION_SCALE_Z = BURST_EXPLOSION_SCALE_Z
    })
end

local function load_config()
    if not json or not json.load_file then return end
    local config = json.load_file(CONFIG_FILE)
    if type(config) ~= "table" then return end

    -- Only accept numeric values for known, editable settings.
    if type(config.POWER_ATTACK_CHARGE_PERIOD) == "number" then POWER_ATTACK_CHARGE_PERIOD = config.POWER_ATTACK_CHARGE_PERIOD end
    if type(config.RAPID_CHARGE_PERIOD) == "number" then RAPID_CHARGE_PERIOD = config.RAPID_CHARGE_PERIOD end
    if type(config.COMBO_INTERVAL) == "number" then COMBO_INTERVAL = config.COMBO_INTERVAL end
    if type(config.COMBO_ATTACK_RATE) == "number" then COMBO_ATTACK_RATE = config.COMBO_ATTACK_RATE end
    if type(config.POWER_ATTACK_RATE) == "number" then POWER_ATTACK_RATE = config.POWER_ATTACK_RATE end
    if type(config.BURST_BOLT_EXPLOSION_RATE) == "number" then BURST_BOLT_EXPLOSION_RATE = config.BURST_BOLT_EXPLOSION_RATE end
    if type(config.ALLIVIATE_STAMINA_COST) == "number" then ALLIVIATE_STAMINA_COST = config.ALLIVIATE_STAMINA_COST end
    if type(config.DELAY_EXPLOSION) == "number" then DELAY_EXPLOSION = config.DELAY_EXPLOSION end
    if type(config.NORMAL_SHOT_SCALE_X) == "number" then NORMAL_SHOT_SCALE_X = config.NORMAL_SHOT_SCALE_X end
    if type(config.NORMAL_SHOT_SCALE_Y) == "number" then NORMAL_SHOT_SCALE_Y = config.NORMAL_SHOT_SCALE_Y end
    if type(config.NORMAL_SHOT_SCALE_Z) == "number" then NORMAL_SHOT_SCALE_Z = config.NORMAL_SHOT_SCALE_Z end
    if type(config.RAPID_CHARGE_SHOT_SCALE_X) == "number" then RAPID_CHARGE_SHOT_SCALE_X = config.RAPID_CHARGE_SHOT_SCALE_X end
    if type(config.RAPID_CHARGE_SHOT_SCALE_Y) == "number" then RAPID_CHARGE_SHOT_SCALE_Y = config.RAPID_CHARGE_SHOT_SCALE_Y end
    if type(config.RAPID_CHARGE_SHOT_SCALE_Z) == "number" then RAPID_CHARGE_SHOT_SCALE_Z = config.RAPID_CHARGE_SHOT_SCALE_Z end
    if type(config.POWER_SHOT_SCALE_X) == "number" then POWER_SHOT_SCALE_X = config.POWER_SHOT_SCALE_X end
    if type(config.POWER_SHOT_SCALE_Y) == "number" then POWER_SHOT_SCALE_Y = config.POWER_SHOT_SCALE_Y end
    if type(config.POWER_SHOT_SCALE_Z) == "number" then POWER_SHOT_SCALE_Z = config.POWER_SHOT_SCALE_Z end
    if type(config.BURST_BLOB_SCALE_X) == "number" then BURST_BLOB_SCALE_X = config.BURST_BLOB_SCALE_X end
    if type(config.BURST_BLOB_SCALE_Y) == "number" then BURST_BLOB_SCALE_Y = config.BURST_BLOB_SCALE_Y end
    if type(config.BURST_BLOB_SCALE_Z) == "number" then BURST_BLOB_SCALE_Z = config.BURST_BLOB_SCALE_Z end
    if type(config.BURST_EXPLOSION_SCALE_X) == "number" then BURST_EXPLOSION_SCALE_X = config.BURST_EXPLOSION_SCALE_X end
    if type(config.BURST_EXPLOSION_SCALE_Y) == "number" then BURST_EXPLOSION_SCALE_Y = config.BURST_EXPLOSION_SCALE_Y end
    if type(config.BURST_EXPLOSION_SCALE_Z) == "number" then BURST_EXPLOSION_SCALE_Z = config.BURST_EXPLOSION_SCALE_Z end
end

load_config()

-- REFRAMEWORK IN-GAME CONFIG MENU
-- These sliders change the same values defined in the CONFIG section above.
-- Changes are saved automatically to CONFIG_FILE and restored on script load.

local function draw_config_slider(label, value, min_value, max_value, format)
    local changed, new_value = imgui.slider_float(label, value, min_value, max_value, format or "%.2f")
    if changed then
        config_dirty = true
        return new_value, true
    end
    return value, false
end

re.on_draw_ui(function()
    if imgui.tree_node("Ordinary Offensive Magic") then
        imgui.text("Changes apply at runtime; some affect the next attack/projectile.")
        imgui.text("Slider changes are saved automatically to an REFramework JSON config.")
        imgui.separator()

        if imgui.tree_node("Attack / Charge") then
            POWER_ATTACK_CHARGE_PERIOD = select(1, draw_config_slider("Power attack charge period", POWER_ATTACK_CHARGE_PERIOD, 0.25, 8.0))
            RAPID_CHARGE_PERIOD = select(1, draw_config_slider("Rapid charge period", RAPID_CHARGE_PERIOD, 0.1, 3.0))
            local changed
            COMBO_INTERVAL, changed = draw_config_slider("Combo interval", COMBO_INTERVAL, 0.05, 1.0)
            if changed then
                updateSorcererRapidShot()
                updateMageRapidShot()
            end
            COMBO_ATTACK_RATE = select(1, draw_config_slider("Combo attack rate", COMBO_ATTACK_RATE, 0.1, 5.0))
            POWER_ATTACK_RATE = select(1, draw_config_slider("Power attack rate", POWER_ATTACK_RATE, 0.1, 10.0))
            BURST_BOLT_EXPLOSION_RATE = select(1, draw_config_slider("Burst Bolt explosion rate", BURST_BOLT_EXPLOSION_RATE, 0.1, 5.0))
            ALLIVIATE_STAMINA_COST = select(1, draw_config_slider("Stamina cost divisor", ALLIVIATE_STAMINA_COST, 1.0, 500.0))
            DELAY_EXPLOSION = select(1, draw_config_slider("Burst Bolt explosion delay", DELAY_EXPLOSION, 0.0, 5.0))
            imgui.tree_pop()
        end

        if imgui.tree_node("Visual Effects — Normal Shot") then
            NORMAL_SHOT_SCALE_X = select(1, draw_config_slider("Normal shot scale X", NORMAL_SHOT_SCALE_X, 0.1, 8.0))
            NORMAL_SHOT_SCALE_Y = select(1, draw_config_slider("Normal shot scale Y", NORMAL_SHOT_SCALE_Y, 0.1, 8.0))
            NORMAL_SHOT_SCALE_Z = select(1, draw_config_slider("Normal shot scale Z", NORMAL_SHOT_SCALE_Z, 0.1, 8.0))
            imgui.tree_pop()
        end

        if imgui.tree_node("Visual Effects — Rapid Charge Shot") then
            RAPID_CHARGE_SHOT_SCALE_X = select(1, draw_config_slider("Rapid shot scale X", RAPID_CHARGE_SHOT_SCALE_X, 0.1, 8.0))
            RAPID_CHARGE_SHOT_SCALE_Y = select(1, draw_config_slider("Rapid shot scale Y", RAPID_CHARGE_SHOT_SCALE_Y, 0.1, 8.0))
            RAPID_CHARGE_SHOT_SCALE_Z = select(1, draw_config_slider("Rapid shot scale Z", RAPID_CHARGE_SHOT_SCALE_Z, 0.1, 8.0))
            imgui.tree_pop()
        end

        if imgui.tree_node("Visual Effects — Power Shot") then
            POWER_SHOT_SCALE_X = select(1, draw_config_slider("Power shot scale X", POWER_SHOT_SCALE_X, 0.1, 10.0))
            POWER_SHOT_SCALE_Y = select(1, draw_config_slider("Power shot scale Y", POWER_SHOT_SCALE_Y, 0.1, 10.0))
            POWER_SHOT_SCALE_Z = select(1, draw_config_slider("Power shot scale Z", POWER_SHOT_SCALE_Z, 0.1, 10.0))
            imgui.tree_pop()
        end

        if imgui.tree_node("Visual Effects — Burst Bolt") then
            BURST_BLOB_SCALE_X = select(1, draw_config_slider("Burst blob scale X", BURST_BLOB_SCALE_X, 0.1, 10.0))
            BURST_BLOB_SCALE_Y = select(1, draw_config_slider("Burst blob scale Y", BURST_BLOB_SCALE_Y, 0.1, 10.0))
            BURST_BLOB_SCALE_Z = select(1, draw_config_slider("Burst blob scale Z", BURST_BLOB_SCALE_Z, 0.1, 10.0))
            BURST_EXPLOSION_SCALE_X = select(1, draw_config_slider("Burst explosion scale X", BURST_EXPLOSION_SCALE_X, 0.1, 10.0))
            BURST_EXPLOSION_SCALE_Y = select(1, draw_config_slider("Burst explosion scale Y", BURST_EXPLOSION_SCALE_Y, 0.1, 10.0))
            BURST_EXPLOSION_SCALE_Z = select(1, draw_config_slider("Burst explosion scale Z", BURST_EXPLOSION_SCALE_Z, 0.1, 10.0))
            imgui.tree_pop()
        end

        imgui.tree_pop()
    end
    if config_dirty then
        save_config()
        config_dirty = false
    end
end)


-- DO NOT TOUCH UNDER THIS LINE

if reframework.get_commit_count() < 1644 then
	re.msg("Ordinary Offensive Magic: Your REFramework is older version.\n If the mod does not work, Get version `REF Nightly 913` from\nhttps://github.com/praydog/REFramework-nightly/releases")
end

local sdk_ = sdk
local _charge_deltatime = 0.0
local cached_multiplier = {}
-- Keep the unmodified ActionRate so repeated damage calculations don't multiply
-- an already-modified value and cause basic attacks to scale without limit.
-- No permanent ActionRate cache: every change is restored in the post-hook.
-- list of hash
local BURST_BOLT_HASH = 2550907203
local BURST_BOLT_HOLD_HASH = 1484381992
local FOCUSED_BOLT_HASH = 1425099050
local FOCUSED_BOLT_HOLD_HASH = 106531605
local MAGE_MAGIC_BOLT_HASH = 1126541769
local MAGE_MAGIC_BOLT_HOLD_HASH = 778730609
local SORCERER_MAGIC_BOLT_HASH = 144413685
local SORCERER_MAGIC_BOLT_HOLD_HASH = 1277318571
local BURST_BOLT_BLOB_HASH = 1430605661
local BURST_BOLT_EXPLOSION_HASH = 2270892601


local SIGNETURES = {
    NORMAL_SHOT_SIGNETURE = 0,
    POWER_SHOT_SIGNETURE = 1,
    BURST_BOLT_BLOG_SIGNETURE = 2,
    BURST_BOLT_EXPLSION_SIGNETURE = 3,
}


local SHELL_HASH_TABLE = {
    [BURST_BOLT_HASH] = SIGNETURES.POWER_SHOT_SIGNETURE,
    [BURST_BOLT_HOLD_HASH] = SIGNETURES.POWER_SHOT_SIGNETURE,
    [FOCUSED_BOLT_HASH] = SIGNETURES.POWER_SHOT_SIGNETURE,
    [FOCUSED_BOLT_HOLD_HASH] = SIGNETURES.POWER_SHOT_SIGNETURE,
    [MAGE_MAGIC_BOLT_HASH] = SIGNETURES.NORMAL_SHOT_SIGNETURE,
    [MAGE_MAGIC_BOLT_HOLD_HASH] = SIGNETURES.NORMAL_SHOT_SIGNETURE,
    [SORCERER_MAGIC_BOLT_HASH] = SIGNETURES.NORMAL_SHOT_SIGNETURE,
    [SORCERER_MAGIC_BOLT_HOLD_HASH] = SIGNETURES.NORMAL_SHOT_SIGNETURE,
    [BURST_BOLT_BLOB_HASH] = SIGNETURES.BURST_BOLT_BLOG_SIGNETURE,
    [BURST_BOLT_EXPLOSION_HASH] = SIGNETURES.BURST_BOLT_EXPLSION_SIGNETURE
}

local _character_manager
local function GetCharacterManager()
    if not _character_manager then
        _character_manager = sdk_.get_managed_singleton("app.CharacterManager")
    end
	return _character_manager
end

local function _get_component(value, func, name)
    if not value then
        local this_ = func()
        if this_ then
            value = this_:call(name)
        end
    end
    return value
end

local _player_chara
local function GetManualPlayer()
    if not _player_chara then
        local characterManager = GetCharacterManager()
        if characterManager then
            _player_chara = characterManager:get_ManualPlayer()
        end
    end
    return _player_chara
end

local _human_param
local function GetHumanParam()
    _human_param = _get_component(_human_param, GetCharacterManager, "get_HumanParam()")
    return _human_param
end

local _job_param
local function GetJobParam()
    _job_param = _get_component(_job_param, GetHumanParam, "get_Job()")
    return _job_param
end

local _mage_param
local function GetMageParam()
    _mage_param = _get_component(_mage_param, GetJobParam, "get_Job03Param()")
    return _mage_param
end

local _sorcerer_param
local function GetSorcererParameter ()
    _sorcerer_param = _get_component(_sorcerer_param, GetJobParam, "get_Job06Param()")
    return _sorcerer_param
end

local _burst_shot_param
local function GetBurstShotParameter()
    _burst_shot_param = _get_component(_burst_shot_param, GetSorcererParameter, "get_BurstShotParam")
    return _burst_shot_param
end

local _rapid_shot_param
local function GetSorcererRapidShotParameter()
    _rapid_shot_param = _get_component(_rapid_shot_param, GetSorcererParameter, "get_RapidShotParam")
    return _rapid_shot_param
end

local _mage_rapid_shot_param
local function GetMageRapidShotParameter()
    _mage_rapid_shot_param = _get_component(_mage_rapid_shot_param, GetMageParam, "get_RapidShotParamProp")
    return _mage_rapid_shot_param
end

local _power_shot_param
local function GetHeavyShotParameter()
    _power_shot_param = _get_component(_power_shot_param, GetMageParam, "get_PowerShotParamProp")
    return _power_shot_param
end

local function updateSorcererRapidShot()
    _rapid_shot_param = GetSorcererRapidShotParameter()
    if _rapid_shot_param then
        _rapid_shot_param:set_field("_ComboRapidShotTime", COMBO_INTERVAL)
    end
end

local function updateBurstShotParameter(value)
    _burst_shot_param = GetBurstShotParameter()
    if _burst_shot_param then
        _burst_shot_param:set_field("_PrepareTime", value)
    end
end

local function updateMageRapidShot()
    _mage_rapid_shot_param = GetMageRapidShotParameter()
    if _mage_rapid_shot_param then
        _mage_rapid_shot_param:set_field("_ComboRapidShotTime", COMBO_INTERVAL)
    end
end

local function updatePowerShotParameter(value)
    _power_shot_param = GetHeavyShotParameter()
    if _power_shot_param then
        _power_shot_param:set_field("_PrepareTime", value)
    end
end

local _stamina_manager
local function GetStaminaManager()
    if not _stamina_manager then
        local manualPlayer = GetManualPlayer()
        if manualPlayer then
            _stamina_manager = manualPlayer:get_StaminaManager()
        end
    end
    return _stamina_manager
end

local function on_post_requestNormalAttack(chara)
    local job = chara:get_field("<Human>k__BackingField"):get_JobContext():get_field("CurrentJob")
    if job == 6 or job == 3 or job == 10 then
        updateBurstShotParameter(POWER_ATTACK_CHARGE_PERIOD)
        updatePowerShotParameter(POWER_ATTACK_CHARGE_PERIOD)
    end
end

local function on_pre_set_rapid_charge_shot(chara)
    local job = chara:get_field("<Human>k__BackingField"):get_JobContext():get_field("CurrentJob")
    if job == 6 or job == 3 or job == 10 then
        updateBurstShotParameter(RAPID_CHARGE_PERIOD)
        updatePowerShotParameter(RAPID_CHARGE_PERIOD)
    end
end

local function initialize_()
    _character_manager = nil
    _human_param = nil
    _job_param = nil
    _sorcerer_param = nil
    _mage_param = nil
    _rapid_shot_param = nil
    _burst_shot_param = nil
    _mage_rapid_shot_param = nil
    _power_shot_param = nil
    _player_chara = nil
    _stamina_manager = nil
    _charge_deltatime = 0.0
    _player_chara = GetManualPlayer()
    _burst_shot_param = GetBurstShotParameter()
    _power_shot_param = GetHeavyShotParameter()
    cached_multiplier = {}
end

initialize_()

-- could use sdk.find_type_definition("app.GuiManager"):get_method("OnChangeSceneType")
sdk_.hook(sdk_.find_type_definition("app.GuiManager"):get_method("OnChangeSceneType"),
    function () end,
    function (...)
        initialize_()
        updateSorcererRapidShot()
        updateBurstShotParameter(RAPID_CHARGE_PERIOD)
        updateMageRapidShot()
        updatePowerShotParameter(RAPID_CHARGE_PERIOD)
        print("player character: zoltraak", _player_chara)
        return ...
    end)

-- combo initialization.
sdk_.hook(sdk_.find_type_definition("app.HumanActionSelector"):get_method("requestComboAction(app.LocomotionSpeedTypeEnum)"),
    function (args)
        if _player_chara == sdk_.to_managed_object(args[2]):get_field("Param"):get_field("Chara") then
            on_pre_set_rapid_charge_shot(sdk_.to_managed_object(args[2]):get_field("Param"):get_field("Chara"))
        end
    end,
    function (rtval)
        return rtval
    end)

local caller_human
sdk_.hook(sdk_.find_type_definition("app.HumanActionSelector"):get_method("requestNormalAttack(app.LocomotionSpeedTypeEnum)"),
    function (args)
        caller_human = sdk_.to_managed_object(args[2]):get_field("Param"):get_field("Chara")
    end,
    function (rtval)
        if _player_chara == caller_human then
            on_post_requestNormalAttack(caller_human)
        end
        return rtval
    end)

local function get_new_vector3(x, y, z)
    local new_vector3 = ValueType.new(sdk_.find_type_definition("via.vec3"))
    local function fixed_size(val)
        if val < 0.1 then
            return 0.1
        end
        return val
    end
    new_vector3.x = fixed_size(x)
    new_vector3.y = fixed_size(y)
    new_vector3.z = fixed_size(z)
    return new_vector3
end

sdk_.hook(sdk_.find_type_definition("app.ShellManager"):get_method("registShell(app.Shell)"),
    function (args)
        local app_shell = sdk_.to_managed_object(args[3])
        local caller_chara= app_shell:get_OwnerCharacter()
        if caller_chara ~= _player_chara then return end
        local shell_param = app_shell:get_ShellParameter()
        local shell_base_param = shell_param:get_field("ShellBaseParam")
        local shell_hash = app_shell:get_ShellParamId()
        if SHELL_HASH_TABLE[shell_hash] == SIGNETURES.NORMAL_SHOT_SIGNETURE then
            shell_base_param["Scale"] = get_new_vector3(NORMAL_SHOT_SCALE_X, NORMAL_SHOT_SCALE_Y, NORMAL_SHOT_SCALE_Z)
        -- cache request id and deltatime
        elseif SHELL_HASH_TABLE[shell_hash] == SIGNETURES.POWER_SHOT_SIGNETURE then
            if _charge_deltatime < 1.0 then
                -- rapid charge
                _charge_deltatime = 1.0
                shell_base_param["Scale"] = get_new_vector3(RAPID_CHARGE_SHOT_SCALE_X, RAPID_CHARGE_SHOT_SCALE_Y, RAPID_CHARGE_SHOT_SCALE_Z)
            else
                -- power shot
                shell_base_param["Scale"] = get_new_vector3(POWER_SHOT_SCALE_X, POWER_SHOT_SCALE_Y, POWER_SHOT_SCALE_Z)
            end
            cached_multiplier[app_shell["<RequestId>k__BackingField"]] = _charge_deltatime
            _charge_deltatime = 0.0
        -- Blob lifetime is used for Burst bolt explosion delay
        elseif SHELL_HASH_TABLE[shell_hash] == SIGNETURES.BURST_BOLT_BLOG_SIGNETURE then
            shell_base_param:set_field("LifeTime", DELAY_EXPLOSION)
            shell_base_param["Scale"] = get_new_vector3(BURST_BLOB_SCALE_X, BURST_BLOB_SCALE_Y, BURST_BLOB_SCALE_Z)
        elseif SHELL_HASH_TABLE[shell_hash] == SIGNETURES.BURST_BOLT_EXPLSION_SIGNETURE then
            shell_base_param["Scale"] = get_new_vector3(BURST_EXPLOSION_SCALE_X, BURST_EXPLOSION_SCALE_Y, BURST_EXPLOSION_SCALE_Z)
        else
            return
        end
        shell_base_param["UseScale"] = true
    end,
    function (rtval)
        return rtval
    end)

sdk_.hook(sdk_.find_type_definition("app.JobContext"):get_method("setJobChanged(app.Character.JobEnum)"),
    function ()
        -- specify chara  here.
        cached_multiplier = {}
    end,
    function (rtval)
        return rtval
    end)

-- Restore the original ActionRate after every damage calculation.
-- AttackUserData can be reused by later hits, so caching a modified field is unsafe.
local pending_action_rate_restores = {}

sdk_.hook(sdk_.find_type_definition("app.HitController"):get_method("calcDamageValue(app.HitController.DamageInfo)"),
function (args)
    local restore = nil
    local damage_info = sdk_.to_managed_object(args[3])
    if damage_info ~= nil then
        local attacker_hit_controller = damage_info:get_field("<AttackOwnerHitController>k__BackingField")
        local attack_hit_controller = damage_info:get_field("<AttackHitController>k__BackingField")
        if attacker_hit_controller ~= nil and attack_hit_controller ~= nil
            and attacker_hit_controller:get_CachedCharacter() == _player_chara then
            local attacker_shell_cache = attack_hit_controller:get_CachedShell()
            if attacker_shell_cache ~= nil then
                local kind = SHELL_HASH_TABLE[attacker_shell_cache:get_ShellParamId()]
                local multiplier = nil
                if kind == SIGNETURES.NORMAL_SHOT_SIGNETURE then
                    multiplier = COMBO_ATTACK_RATE
                elseif kind == SIGNETURES.POWER_SHOT_SIGNETURE then
                    local request_id = attacker_shell_cache["<RequestId>k__BackingField"]
                    multiplier = POWER_ATTACK_RATE * (cached_multiplier[request_id] or 1.0)
                elseif kind == SIGNETURES.BURST_BOLT_EXPLSION_SIGNETURE then
                    multiplier = BURST_BOLT_EXPLOSION_RATE
                end
                if multiplier ~= nil then
                    local attack_user_data = damage_info:get_field("<AttackUserData>k__BackingField")
                    if attack_user_data ~= nil then
                        local original_rate = attack_user_data:get_field("ActionRate")
                        restore = {data = attack_user_data, rate = original_rate}
                        attack_user_data:set_field("ActionRate", original_rate * multiplier)
                        damage_info:set_field("<AttackUserData>k__BackingField", attack_user_data)
                    end
                end
            end
        end
    end
    -- The post-hook runs for each pre-hook, including hits we don't modify.
    pending_action_rate_restores[#pending_action_rate_restores + 1] = restore or false
end,
function (rtval)
    local restore = table.remove(pending_action_rate_restores)
    if restore then
        restore.data:set_field("ActionRate", restore.rate)
    end
    return rtval
end)

sdk_.hook(sdk_.find_type_definition("app.ShellManager"):get_method("requestDestroyShell(System.Int32)"),
function (args)
    local request_id = sdk_.to_int64(args[3])
    if cached_multiplier[request_id] ~= nil then
        cached_multiplier[request_id] = nil
    end
end,
function (rtval)
    return rtval
end)

local timer = os.clock()
local elapsed_time_ = 0.0
sdk_.hook(sdk_.find_type_definition("app.Job06ActionController"):get_method("update()"),
function (args)
    local this = sdk_.to_managed_object(args[2])
    local caller = this:get_field("Chara")
    if _player_chara ~= caller then return end
    local magic_user_context = this:get_field("<JobMagicUserActionContext>k__BackingField")
    local current_frame = os.clock()
    local deltatime = current_frame - timer
    timer = current_frame
    if magic_user_context == nil then return end
    if _burst_shot_param["_PrepareTime"] == POWER_ATTACK_CHARGE_PERIOD or _power_shot_param["_PrepareTime"] == POWER_ATTACK_CHARGE_PERIOD then
        if magic_user_context:get_IsChargingShot() then
            elapsed_time_ = elapsed_time_ + deltatime
            -- print(elapsed_time_)
            if elapsed_time_ < POWER_ATTACK_CHARGE_PERIOD then
                _charge_deltatime = elapsed_time_
                _stamina_manager = GetStaminaManager()
                local cost = _stamina_manager:get_MaxValue() * 0.1 * -1.0
                _stamina_manager:add(cost / ALLIVIATE_STAMINA_COST, false)
            else
                _charge_deltatime = POWER_ATTACK_CHARGE_PERIOD
            end
        else
            elapsed_time_ = 0.0
        end
    end
end,
function ()
end)
