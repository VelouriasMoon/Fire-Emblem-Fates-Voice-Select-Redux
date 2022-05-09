.text
.align 4
.include "../source/Symbols.s"

.global AssetTable__GetVoice
AssetTable__GetVoice:
    //r0 takes character data
    push    {r4-r5, lr}
    mov     r4, r0                  //Store character in r4 for later
    bl      BattleGlobal__Asset
    ldr     r1, [r4, #0x10]         //Load AID into r1
    bl      AssetTable__Find        //Get AssetTable Entry
    mov     r5, r0                  //Store Asset in r5 for later

    //Check if asset has extra flags bit
    ldrb    r0, [r5, #0x0]
    mov     r1, #0x1
    and     r2, r0, r1
    cmp     r1, r2
    bne     GetBreak

    //Check if asset has voice bit
    ldrb    r0, [r5, #0x4]
    mov     r1, #0b00000010
    and     r2, r0, r1
    cmp     r1, r2
    bne     GetBreak
    
    
    //Get total number of flags before the voice

    ldr     r0, [r5, #0x0]
    bl      asm_CountBits     //assume 8
    add     r0, r0, #0x2        //account for 8 byte header
    mov     r3, r0, lsl #0x2    //multiply by 4 for real pointer locations
    ldrb    r0, [r5, #0x4]      //check for clothing sound
    mov     r1, #0x1
    and     r0, r0, r1
    cmp     r1, r0
    addeq   r3, r3, #0x4        //add one more pointer for the clothing sound

    //load the voice string from offset
    add     r0, r5, r3          //store the offset of the string referance in r0
    pop     {r4-r5, lr}         //the function calling it will had to load the string from the offset
    bx      lr

GetBreak:
    mov     r0, #0x0
    pop     {r4-r5, lr}
    bx      lr

Asset_CountBits:
    mov     r1, r0, lsr #31
CountLoop:
    movs    r0, r0, lsl #2
    adc     r1, r1, r0, lsr #31
    bne     CountLoop
    bx      lr