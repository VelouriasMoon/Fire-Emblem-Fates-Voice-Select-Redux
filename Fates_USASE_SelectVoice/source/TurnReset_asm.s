.text
.align 4
.include "../source/Symbols.s"

TurnResetFix_ASM:
    mov     r3, #0x0
    strb    r3, [r4, #0x8A]
    ldr     r4, [r4, #0x14]
    b       map__Sequence__anonymous_namespace__ProcSequence__TurnEnd + 0x68