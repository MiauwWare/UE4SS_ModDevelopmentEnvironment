#pragma once
#include <Mod/CppUserModBase.hpp>
#include <Unreal/UnrealCoreStructs.hpp>
#include <Unreal/UFunctionStructs.hpp>
#include <utility>


namespace Mods
{
    /**
    * SquareBases: UE4SS c++ mod class defintion
    */
    class SquareBases : public RC::CppUserModBase 
    {
    public:
        // constructor
        SquareBases();
        
        // destructor
        ~SquareBases() override;

        auto on_program_start() -> void override;
        auto on_dll_load(std::wstring_view dll_name) -> void override;
        auto on_unreal_init() -> void override;

    private:
        static auto IsInsideArea_PreHook(Unreal::UnrealScriptFunctionCallableContext& Context, void* CustomData) -> void;
        static auto IsInsideArea_PostHook(Unreal::UnrealScriptFunctionCallableContext& Context, void* CustomData) -> void;

        std::pair<int, int> m_is_inside_area_hook_ids{0, 0};

    };//class
}