#include "SquareBases.hpp"
#include <DynamicOutput/Output.hpp>
#include <Unreal/UObject.hpp>
#include <Unreal/UObjectGlobals.hpp>
#include <Pal_enums.hpp>

namespace Mods
{
    using namespace RC;
    using namespace Unreal;

    namespace
    {
        constexpr const TCHAR* IS_INSIDE_AREA_FUNCTION = STR("/Script/Pal.PalRandomIncidentSpawnerBase:IsInsideArea");

        struct FIsInsideArea_Params
        {
            EPalRandomIncidentSpawnerAreaType Area;
            void* pPlayer;
            bool ReturnValue;
        };
    }

    // constructor
    SquareBases::SquareBases()
    {
        ModVersion = STR("0.1");
        ModName = STR("SquareBases");
        ModAuthors = STR("ru-the-dev");
        ModDescription = STR("A mod that makes the bases in Palworld square instead of circular.");
        
        // Do not change this unless you want to target a UE4SS version
        // other than the one you're currently building with somehow.
        //ModIntendedSDKVersion = STR("2.6");

        Output::send<LogLevel::Warning>(STR("[SquareBases]: Init.\n"));
    }

    // destructor
    SquareBases::~SquareBases()
    {
        if (m_is_inside_area_hook_ids.first != 0 || m_is_inside_area_hook_ids.second != 0)
        {
            try
            {
                UObjectGlobals::UnregisterHook(IS_INSIDE_AREA_FUNCTION, m_is_inside_area_hook_ids);
            }
            catch (...)
            {
                Output::send<LogLevel::Error>(STR("[SquareBases]: Failed to unhook IsInsideArea.\n"));
            }
        }
    }

    auto SquareBases::on_program_start() -> void
    {
    }

    auto SquareBases::on_dll_load(std::wstring_view dll_name) -> void
    {
        (void)dll_name;
    }

    auto SquareBases::on_unreal_init() -> void
    {
        // You are allowed to use the 'Unreal' namespace in this function and anywhere else after this function has fired.
        auto object = UObjectGlobals::StaticFindObject<UObject*>(nullptr, nullptr, STR("/Script/CoreUObject.Object"));
        Output::send<LogLevel::Verbose>(STR("Object Name: {}\n"), object->GetFullName());

        try
        {
            m_is_inside_area_hook_ids = UObjectGlobals::RegisterHook(
                IS_INSIDE_AREA_FUNCTION,
                &SquareBases::IsInsideArea_PreHook,
                &SquareBases::IsInsideArea_PostHook,
                nullptr);

            Output::send<LogLevel::Warning>(STR("[SquareBases]: Hooked IsInsideArea.\n"));
        }
        catch (...)
        {
            Output::send<LogLevel::Error>(STR("[SquareBases]: Failed to hook IsInsideArea.\n"));
        }
    }

    auto SquareBases::IsInsideArea_PreHook(UnrealScriptFunctionCallableContext& context, void* custom_data) -> void
    {
        (void)context;
        (void)custom_data;
    }

    auto SquareBases::IsInsideArea_PostHook(UnrealScriptFunctionCallableContext& context, void* custom_data) -> void
    {
        (void)custom_data;

        auto& params = context.GetParams<FIsInsideArea_Params>();
        (void)params.Area;
        (void)params.pPlayer;

        // Override the game result so the area check always passes.
        params.ReturnValue = true;
    }
    // class
}

/**
* export the start_mod() and uninstall_mod() functions to
* be used by the core ue4ss system to load in our dll mod
*/
#define MOD_EXPORT __declspec(dllexport)
extern "C" {
    MOD_EXPORT RC::CppUserModBase* start_mod(){ return new Mods::SquareBases(); }
    MOD_EXPORT void uninstall_mod(RC::CppUserModBase* mod) { delete mod; }
}
