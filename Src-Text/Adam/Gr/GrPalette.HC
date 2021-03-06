#help_index "Graphics/Color"
public U8 gr_rainbow_10[10]={
  BLACK,BROWN,RED,LTRED,YELLOW,GREEN,BLUE,PURPLE,LTGRAY,WHITE};

DefineLstLoad("ST_RAINBOW_10",
  "BLACK\0BROWN\0RED\0LTRED\0YELLOW\0GREEN\0BLUE\0PURPLE\0LTGRAY\0WHITE\0");

U0 GrPaletteIndicesSet()
{//There is a level of indirection that we identity map.
// Set 16-colors to use first 16 DAC BGR entries, so we
// never need to worry about indexes, just DAC palette settings.
  I64 i;
  if (!Bt(&sys_run_level,RLf_VGA)) return;
  PUSHFD
  CLI
  while (LBts(&sys_semas[SEMA_VGA],0))
    Yield;
  InU8(VGAP_INPUT_STAT); //Rsts attr index/data
  for (i=0;i<COLORS_NUM;i++) {
    OutU8(VGAP_ATTR_INDEX,i);
    OutU8(VGAP_ATTR_DATA_WRITE,i);
  }
  OutU8(VGAP_ATTR_INDEX,0x20);
  OutU8(VGAP_ATTR_DATA_WRITE,0); //Dummy write
  InU8(VGAP_INPUT_STAT); //Rsts attr index/data
  LBtr(&sys_semas[SEMA_VGA],0);
  POPFD
}

public U0 GrPaletteColorSet(I64 color_num,CBGR48 bgr48)
{//VGA has 6-bits for blue, for green, and for red.
  if (!Bt(&sys_run_level,RLf_VGA)) return;
  PUSHFD
  CLI
  while (LBts(&sys_semas[SEMA_VGA],0))
    Yield;
  OutU8(VGAP_PALETTE_MASK,0xFF);
  OutU8(VGAP_REG_WRITE,color_num);
  OutU8(VGAP_PALETTE_DATA,bgr48.r>>10);
  OutU8(VGAP_PALETTE_DATA,bgr48.g>>10);
  OutU8(VGAP_PALETTE_DATA,bgr48.b>>10);
  LBtr(&sys_semas[SEMA_VGA],0);
  POPFD
}

public CBGR48 GrPaletteColorGet(I64 color_num)
{//VGA has 6-bits for blue, for green, and for red.
  CBGR48 res=0;
  if (!Bt(&sys_run_level,RLf_VGA)) return 0;
  PUSHFD
  CLI
  while (LBts(&sys_semas[SEMA_VGA],0))
    Yield;
  OutU8(VGAP_PALETTE_MASK,0xFF);
  OutU8(VGAP_REG_READ,color_num);
  res.r=0xFFFF<<10*InU8(VGAP_PALETTE_DATA)/0xFC00;
  res.g=0xFFFF<<10*InU8(VGAP_PALETTE_DATA)/0xFC00;
  res.b=0xFFFF<<10*InU8(VGAP_PALETTE_DATA)/0xFC00;
  LBtr(&sys_semas[SEMA_VGA],0);
  POPFD
  return res;
}

//public CBGR48 gr_test[COLORS_NUM]={};


public CBGR48 gr_palette_std[COLORS_NUM]={
0x000000000000,0x00000000AAAA,0x0000AAAA0000,0x0000AAAAAAAA,
0xAAAA00000000,0xAAAA0000AAAA,0xAAAA55550000,0xAAAAAAAAAAAA,
0x555555555555,0x55555555FFFF,0x5555FFFF5555,0x5555FFFFFFFF,
0xFFFF55555555,0xFFFF5555FFFF,0xFFFFFFFF5555,0xFFFFFFFFFFFF};

public CBGR48 gr_palette_gray[COLORS_NUM]={
0x000000000000,0x111111111111,0x222222222222,0x333333333333,
0x444444444444,0x555555555555,0x666666666666,0x777777777777,
0x888888888888,0x999999999999,0xAAAAAAAAAAAA,0xBBBBBBBBBBBB,
0xCCCCCCCCCCCC,0xDDDDDDDDDDDD,0xEEEEEEEEEEEE,0xFFFFFFFFFFFF};

public CBGR48 gr_palette_gutter[COLORS_NUM] = {
0xD0D0D0D0D0D0,0x65658282C2C2,0x6565A4A44646,0x5C5C9D9D8888,
0xBFBF63638282,0x9E9E6B6BB8B8,0xADAD8A8A4343,0x515151515151,
0x919191919191,0xAFAFC4C4E9E9,0xAEAED4D49B9B,0xA4A4D0D0C1C1,
0xEAEAAEAEC2C2,0xD2D2B1B1E2E2,0xD4D4C3C3A0A0,0x1E1E1E1E1E1E
};

public CBGR48 gr_palette_light[COLORS_NUM]={
0x1C1C20202727,0x35355C5C9A9A,0x383891912B2B,0x25258F8F8F8F,
0xA6A62A2A3E3E,0x7C7C4F4F9F9F,0xB2B27D7D1212,0xC0C0C0C0C0C0,
0x777785858C8C,0x4545A3A3E6E6,0x9393C7C72424,0x6060C6C6C8C8,
0xF0F047475858,0xC9C95353EFEF,0xDDDDB6B62B2B,0xDFDFDFDFEBEB
};

public CBGR48 gr_palette_gruvbox_light[COLORS_NUM]={
0x3C3C38383636,0x070766667878,0x797974740E0E,0x42427B7B5858,
0x9D9D00000606,0x8F8F3F3F7171,0xB5B576761414,0x929283837474,
0x7C7C6F6F6464,0x454585858888,0x989897971A1A,0x68689D9D6A6A,
0xCCCC24241D1D,0xB1B162628686,0xD7D799992121,0xF9F9F5F5D7D7
};

public CBGR48 gr_palette_solarlight[COLORS_NUM]={
0x65657B7B8383,0x26268B8BD2D2,0x858599990000,0x2A2AA1A19898,
0xDCDC32322F2F,0x6C6C7171C4C4,0xCBCB4B4B1616,0x58586E6E7575,
0x00002B2B3636,0x6565C0C0FFFF,0xB7B7FFFFB7B7,0x3737D4D4C8C8,
0xF0F047475858,0xD3D336368282,0xB5B589890000,0xFDFDF6F6E3E3  
};

public CBGR48 gr_palette_aci[COLORS_NUM]={
0x0d0d19192626,0xffff08088383,0x8383ffff0808,0xffff83830808,
0x08088383ffff,0x83830808ffff,0x0808ffff8383,0xb6b6b6b6b6b6,
0x424242424242,0xffff1e1e8e8e,0x8e8effff1e1e,0xffff8e8e1e1e,
0x1e1e8e8effff,0x8e8e1e1effff,0x1e1effff8e8e,0xb4b4e1e1fdfd
};

public CBGR48 gr_palette_aci[COLORS_NUM]={
0xb4b4e1e1fdfd, // Hintergrundfarbe
0x08088383ffff, // blau 
0x8383ffff0808, // gr�n
0x0808ffff8383, // mint
0xffff08088383, // pink
0x83830808ffff, // lila
0xffff83830808, // orange
0xb6b6b6b6b6b6, // hellgrau
0x424242424242, // mittelgrau
0x1e1e8e8effff, // himmelblau
0x8e8effff1e1e, // grasgr�n
0x08088383ffff, // hellblau
0xffff1e1e8e8e, // hellpink
0x8e8e1e1effff, // hell lila
0xffff8e8e1e1e, // hell orange
0x0d0d19192626  // Hintergrund
};


public U0 GrPaletteGet(CBGR48 *bgr48)
{//16 colors
  I64 i;
  for (i=0;i<COLORS_NUM;i++)
    bgr48[i]=GrPaletteColorGet(i);
}

public U0 GrPaletteSet(CBGR48 *bgr48)
{//16 colors
  I64 i;
  for (i=0;i<COLORS_NUM;i++)
    GrPaletteColorSet(i,bgr48[i]);
}

public U0 PaletteSetStd()
{//Activate std palette.
  GrPaletteSet(gr_palette_aci);
}
