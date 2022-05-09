.text
.align 4
.include "../source/Symbols.s"

UnitSelectVoice_ASM:
    // r5 = unit struct
    // r0 is used for the sound string in SEPlay
    sub     sp, #0x100
    
    // Guard caluse for voice select
    bl      VoiceSelect_GetValue
    cmp     r0, #0x1                 // should check "once" value
    bgt     UnitSelectSoundAbort     // setting disable or greater
    blt     UnitSelectContine        // setting always or less

    //Check if unit has already talked
    ldrb    r0, [r5, #0x8A]
    cmp     r0, #0x1
    beq     UnitSelectSoundAbort

UnitSelectContine:
    // Do we have a unit struct?
    mov     r0, r5
    cmp     r0, #0
    beq     UnitSelectSoundAbort

    // What about a character struct?
    ldr     r0, [r0, #0x9C]                // Loads character sturct into r0
    cmp     r0, #0
    beq     UnitSelectSoundAbort
    
    // Is character player?
    ldrh    r6, [r0, #0x24]             // Loads char ID into r6
    cmp     r6, #2
    bgt     NotPlayer
    
IsPlayer:
	// Is corrin a dragon?
	ldr     r0, [r5, #0xA0]               // Loads Class struct into r0
	ldrb    r0, [r0, #0x18]               // Loads Class ID into r0
	cmp     r0, #0x6F
	beq     UnitSelectSoundAbort
	cmp     r0, #0x70
	beq     UnitSelectSoundAbort

    // Checking for extra data
    ldr     r0, [r5, #0xB0]                // Loads the logbook pointer into r0
    cmp     r0, #0
    moveq   r0, #1                         // if pointer is empty default to voice set 1
    
    // Getting voice byte
    ldrneb  r0, [r0, #0x2A]                // Loads voice byte into r0
    addne   r0, r0, #1                     // Adds 1 to the voice byte to get the set num
    
    // snprintf to get player voice line
    mov     r3, r0
    mov     r0, sp
    mov     r1, #0x100
    cmp     r6, #1                         // Checks char ID
    ldreq   r2, =VoiceFormatMale            // if Char ID equals 1 use male voice
    ldrne   r2, =VoiceFormatFemale          // if not, 0 or 2, use female
    bl      sut__snprintf
    mov     r0, sp
    b       UnitSelectSoundComplete

NotPlayer:
    // What about a voice pointer?
    //ldr     r0, [r0, #140]
    ldr     r0, [r5, #0x9C]
    bl      AssetTable__GetVoice
    ldr     r0, [r0, #0x0]
    cmp     r0, #0
    beq     UnitSelectSoundAbort
    
    // snprintf to get the voice line
    mov     r3, r0
    mov     r0, sp
    mov     r1, #0x100
    ldr     r2, =VoiceFormatString
    bl      sut__snprintf
    mov     r0, sp

UnitSelectSoundComplete:
    bl      Sound__SEPlay

    // Set byte "played this turn" byte
    bl      VoiceSelect_GetValue
    //cmp     r0, #0x1
    //bne     UnitSelectSoundAbort
    //mov     r0, #0x1
    strb    r0, [r5, #0x8A]
    
UnitSelectSoundAbort:
    add     sp, #0x100
    pop     {r4-r11, lr}
    b       map__sound__Se__UnitSelect

    
.align 4
VoiceFormatString:
.asciz    "VOICE_%s_B_SUPPORT"
VoiceFormatMale:
.asciz    "VOICE_PLAYER_M%i_B_SUPPORT"
VoiceFormatFemale:
.asciz    "VOICE_PLAYER_F%i_B_SUPPORT"