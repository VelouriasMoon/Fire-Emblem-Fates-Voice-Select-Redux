int CountBits(int v)
{
    v = v - ((v >> 1) & 0x55555555);
    v = (v & 0x33333333) + ((v >> 2) & 0x33333333);
    int c = (((v + (v >> 4)) & 0xF0F0F0F) * 0x1010101) >> 24;
    return c;
}

extern "C" 
{
    int asm_CountBits(int v) 
    {
        return CountBits(v);
    }
}