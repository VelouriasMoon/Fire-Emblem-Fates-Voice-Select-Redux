.text
.align 4
.include "../source/Symbols.s"

//Recrates the ending code for Game Config Serializing to add another byte
GameConfigData__Serialize_ASM:
    ldrb    r1, [r4, #0x16]
    mov     r0, r5
    bl      Stream__WriteByte
    ldrb    r1, [r4, #0x17]
    mov     r0, r5
    ldmia   sp!, {r4-r6, lr}
    b       Stream__WriteByte

//Recrates the ending code for Game Config Deserializing to add another byte
GameConfigData__Deserialize_ASM:
    strb    r1, [r4, #0x16]
    mov     r0, r6
    bl      Stream__ReadByte
    strb    r0, [r4, #0x17]
    ldr     r0, [r4, #0x4]
    ldmia   sp!, {r4-r6, lr}
    ands    r0, r0, #0x10000
    movne   r0, #0x1
    b       GameUserGlobalData__ShowMovieSubtitle

GameConfig:
.word 0x0
.word 0x0