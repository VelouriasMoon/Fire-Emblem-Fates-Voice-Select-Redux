.text
.align 4
.include "../source/Symbols.s"

//Code Forked from https://github.com/Raytwo/Fire-Emblem-Fates-Dual-Dub
//credit to RayTwo and DeathChaos

VoiceSelectMenuHook_ASM:
    add     r1, r4, #0x4
    ldmia   r1, {r1, r2}
    add     r3, r1, #0x1
    str     r3, [r4, #0x4]
    str     r0, [r2, r1, lsl #0x2]
    mov     r1, r7
    mov     r0, #0x4c
    bl      operatornew_2 //malloc
    cmp     r0, #0x0
    nop
    beq     SpeakerModeOption
    bl      anonymous_namespace__ConfigItem__ConfigItem
    ldr     r1, =GameConfigMenuVoiceSelectVTable
    str     r1, [r0, #0]
SpeakerModeOption:
    add     r1, r4, #0x4
    b       anonymous_namespace__ProcGameConfigMenu__CreateConfigMenu + 0x52C // The very next instruction after out branch

VoiceSelect_VoiceSelect:
    b       operatordelete

VoiceSelect_GetName:
    adr     r0, [VoiceSelect_Name]
    b       Mess__Get

VoiceSelect_GetValueNames:
    ldr     r3, VoiceSelect_ValueNames
    str     lr, [sp, #-4]!
    sub     sp, sp, #0xC
    ldmia   r3, {r0, r2, r3}
    stmia   sp, {r0, r2, r3}
    ldr     r0, [sp, r1, lsl #0x2]
    bl      Mess__Get
    add     sp, sp, #0xC
    ldr     pc, [sp], #0x4

VoiceSelect_GetValueHelp:
    ldr     r3, VoiceSelect_ValueHelp
    str     lr, [sp, #-4]!
    sub     sp, sp, #0xC
    ldmia   r3, {r0, r2, r3}
    stmia   sp, {r0, r2, r3}
    ldr     r0, [sp, r1, lsl#2]
    bl      Mess__Get
    add     sp, sp, #0xC
    ldr     pc, [sp], #0x4

VoiceSelect_GetValueNum:
    mov     r0, #3
    bx      lr

.global VoiceSelect_GetValue
VoiceSelect_GetValue:
    ldr     r0, =0x6da0f8
    ldr     r0, [r0, #0]
    ldrb    r0, [r0, #0x17]
    bx      lr

VoiceSelect_SetValue:
    ldr     r0, =0x6da0f8
    ldr     r0, [r0, #0]
    strb    r1, [r0, #0x17]
    bx      lr

// Name of the option
.align 2
VoiceSelect_Name:
.asciz "MID_CONFIG_SELECT"

VoiceSelect_ValueNames:
.word VoiceSelect_Names

// Code related to the values of the option
.align 2
VoiceSelect_Names:
.word VoiceSelect_Value_ALL
.word VoiceSelect_Value_ONCE
.word VoiceSelect_Value_NONE

.align 2
VoiceSelect_Value_ALL:
.asciz "MID_CONFIG_SELECT_ALL"
VoiceSelect_Value_ONCE:
.asciz "MID_CONFIG_SELECT_ONCE"
VoiceSelect_Value_NONE:
.asciz "MID_CONFIG_SELECT_NONE"

// Code related to the Help messages for the values
VoiceSelect_ValueHelp:
.word VoiceSelect_Help

.align 2
VoiceSelect_Help:
.word VoiceSelect_H_Value_ALL
.word VoiceSelect_H_Value_ONCE
.word VoiceSelect_H_Value_NONE

.align 2
VoiceSelect_H_Value_ALL:
.asciz "MID_H_CONFIG_SELECT_ALL"
VoiceSelect_H_Value_ONCE:
.asciz "MID_H_CONFIG_SELECT_ONCE"
VoiceSelect_H_Value_NONE:
.asciz "MID_H_CONFIG_SELECT_NONE"

// The VTable that contains function poitners to everything the option uses. Most of it comes from the Subtitle option VTable.
.align 4
GameConfigMenuVoiceSelectVTable:
.word 0x0
.word VoiceSelect_VoiceSelect
.word BasicMenuItem__BuildAttribute
.word 0x0
.word anonymous_namespace__ConfigItem__BuildW
.word game__menu__SplitLargeMenuItem__BuildH
.word BasicMenuItem__BuildBlankH
.word VoiceSelect_GetName
.word anonymous_namespace__ConfigItem__GetHelp
.word anonymous_namespace__ConfigItem__GetColor
.word BasicMenuItem__Tick
.word anonymous_namespace__ConfigItem__Draw
.word anonymous_namespace__ConfigItem__DrawDirect
.word anonymous_namespace__ConfigItem__OnSelect
.word anonymous_namespace__ConfigItem__KeyCall
.word BasicMenuItem__ACall
.word anonymous_namespace__ConfigItem__BCall
.word BasicMenuItem__XCall
.word BasicMenuItem__YCall
.word BasicMenuItem__LCall
.word BasicMenuItem__RCall
.word BasicMenuItem__StartCall
.word BasicMenuItem__CustomCall
.word game__menu__SplitMenuItem__IsSplitSelecting
.word anonymous_namespace__ConfigItem__GetSplitWindowType
.word game__menu__SplitMenuItem__IsSplitWindowTypeDisable
.word game__menu__SplitMenuItem__IsSplitWindowTypeProvisory
.word anonymous_namespace__ConfigItem__GetMenu
.word VoiceSelect_GetValueNames
.word VoiceSelect_GetValueHelp
.word VoiceSelect_GetValueNum
.word 0x0
.word anonymous_namespace__ConfigItem__GetMask
.word VoiceSelect_GetValue
.word VoiceSelect_SetValue
.word anonymous_namespace__ConfigItem__GetValuePositionOffset
.word 0x0
.word 0x0
.word 0x63808C