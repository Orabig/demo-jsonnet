
# Full width in Grafana is 24
local FULL_WIDTH =  { w: 24 };

local HALF_WIDTH_1_on_2 =  { w: 12 };
local HALF_WIDTH_2_on_2 =  { w: 12, x: 12 };

local THIRD_WIDTH_1_on_3 =  { w: 8 };
local THIRD_WIDTH_2_on_3 =  { w: 8, x: 8 };
local THIRD_WIDTH_3_on_3 =  { w: 8, x: 16 };

local QUARTER_WIDTH_1_on_4 =  { w: 6 };
local QUARTER_WIDTH_2_on_4 =  { w: 6, x: 6 };
local QUARTER_WIDTH_3_on_4 =  { w: 6, x: 12 };
local QUARTER_WIDTH_4_on_4 =  { w: 6, x: 18 };

local SIXTH_WIDTH_1_on_6 =  { w: 4 };
local SIXTH_WIDTH_2_on_6 =  { w: 4, x: 4 };
local SIXTH_WIDTH_3_on_6 =  { w: 4, x: 8 };
local SIXTH_WIDTH_4_on_6 =  { w: 4, x: 12 };
local SIXTH_WIDTH_5_on_6 =  { w: 4, x: 16 };
local SIXTH_WIDTH_6_on_6 =  { w: 4, x: 20 };

local LINE_HEIGHT =    { h: 1 };   # This is generally too tiny to contain a graph
local HALF_HEIGHT = { h: 2 };
local DEFAULT_HEIGHT =  { h: 4 };
local DOUBLE_HEIGHT =  { h: 8 };
local TRIPLE_HEIGHT =  { h: 12 };
local QUAD_HEIGHT =    { h: 16 };

#  Prefix :
#  |                                    FULL                                   |
#  |                HALF_1               |                HALF_2               |
#  |         THIRD_1        |         THIRD_2         |         THIRD_3        |
#  |      QUAD_1      |      QUAD_2      |      QUAD_3      |     QUAD_4       |
#  |  SIXTH_1  |  SIXTH_2   |  SIXTH_3  |  SIXTH_4    |  SIXTH_5  |  SIXTH_6   |
#
#  Suffix:
#  _HALF_LINE : Single line
#  _LINE      : Small height
#  (none)     : Default height
#  _H2        : Double height
#  _H3        : Triple height
#  _H4        : Quad height
#
{

    FULL_HALF_LINE:     { gridPos: FULL_WIDTH        + LINE_HEIGHT },
    HALF_1_HALF_LINE:   { gridPos: HALF_WIDTH_1_on_2 + LINE_HEIGHT },
    HALF_2_HALF_LINE:   { gridPos: HALF_WIDTH_2_on_2 + LINE_HEIGHT },
    THIRD_1_HALF_LINE:  { gridPos: THIRD_WIDTH_1_on_3 + LINE_HEIGHT },
    THIRD_2_HALF_LINE:  { gridPos: THIRD_WIDTH_2_on_3 + LINE_HEIGHT },
    THIRD_3_HALF_LINE:  { gridPos: THIRD_WIDTH_2_on_3 + LINE_HEIGHT },
    QUAD_1_HALF_LINE:   { gridPos: QUARTER_WIDTH_1_on_4 + LINE_HEIGHT },
    QUAD_2_HALF_LINE:   { gridPos: QUARTER_WIDTH_2_on_4 + LINE_HEIGHT },
    QUAD_3_HALF_LINE:   { gridPos: QUARTER_WIDTH_3_on_4 + LINE_HEIGHT },
    QUAD_4_HALF_LINE:   { gridPos: QUARTER_WIDTH_4_on_4 + LINE_HEIGHT },
    SIXTH_1_HALF_LINE:  { gridPos: SIXTH_WIDTH_1_on_6 + LINE_HEIGHT },
    SIXTH_2_HALF_LINE:  { gridPos: SIXTH_WIDTH_2_on_6 + LINE_HEIGHT },
    SIXTH_3_HALF_LINE:  { gridPos: SIXTH_WIDTH_3_on_6 + LINE_HEIGHT },
    SIXTH_4_HALF_LINE:  { gridPos: SIXTH_WIDTH_4_on_6 + LINE_HEIGHT },
    SIXTH_5_HALF_LINE:  { gridPos: SIXTH_WIDTH_5_on_6 + LINE_HEIGHT },
    SIXTH_6_HALF_LINE:  { gridPos: SIXTH_WIDTH_6_on_6 + LINE_HEIGHT },

    FULL_LINE:     { gridPos: FULL_WIDTH        + HALF_HEIGHT },
    HALF_1_LINE:   { gridPos: HALF_WIDTH_1_on_2 + HALF_HEIGHT },
    HALF_2_LINE:   { gridPos: HALF_WIDTH_2_on_2 + HALF_HEIGHT },
    THIRD_1_LINE:  { gridPos: THIRD_WIDTH_1_on_3 + HALF_HEIGHT },
    THIRD_2_LINE:  { gridPos: THIRD_WIDTH_2_on_3 + HALF_HEIGHT },
    THIRD_3_LINE:  { gridPos: THIRD_WIDTH_2_on_3 + HALF_HEIGHT },
    QUAD_1_LINE:   { gridPos: QUARTER_WIDTH_1_on_4 + HALF_HEIGHT },
    QUAD_2_LINE:   { gridPos: QUARTER_WIDTH_2_on_4 + HALF_HEIGHT },
    QUAD_3_LINE:   { gridPos: QUARTER_WIDTH_3_on_4 + HALF_HEIGHT },
    QUAD_4_LINE:   { gridPos: QUARTER_WIDTH_4_on_4 + HALF_HEIGHT },
    SIXTH_1_LINE:  { gridPos: SIXTH_WIDTH_1_on_6 + HALF_HEIGHT },
    SIXTH_2_LINE:  { gridPos: SIXTH_WIDTH_2_on_6 + HALF_HEIGHT },
    SIXTH_3_LINE:  { gridPos: SIXTH_WIDTH_3_on_6 + HALF_HEIGHT },
    SIXTH_4_LINE:  { gridPos: SIXTH_WIDTH_4_on_6 + HALF_HEIGHT },
    SIXTH_5_LINE:  { gridPos: SIXTH_WIDTH_5_on_6 + HALF_HEIGHT },
    SIXTH_6_LINE:  { gridPos: SIXTH_WIDTH_6_on_6 + HALF_HEIGHT },

    FULL:     { gridPos: FULL_WIDTH        + DEFAULT_HEIGHT },
    HALF_1:   { gridPos: HALF_WIDTH_1_on_2 + DEFAULT_HEIGHT },
    HALF_2:   { gridPos: HALF_WIDTH_2_on_2 + DEFAULT_HEIGHT },
    THIRD_1:  { gridPos: THIRD_WIDTH_1_on_3 + DEFAULT_HEIGHT },
    THIRD_2:  { gridPos: THIRD_WIDTH_2_on_3 + DEFAULT_HEIGHT },
    THIRD_3:  { gridPos: THIRD_WIDTH_2_on_3 + DEFAULT_HEIGHT },
    QUAD_1:   { gridPos: QUARTER_WIDTH_1_on_4 + DEFAULT_HEIGHT },
    QUAD_2:   { gridPos: QUARTER_WIDTH_2_on_4 + DEFAULT_HEIGHT },
    QUAD_3:   { gridPos: QUARTER_WIDTH_3_on_4 + DEFAULT_HEIGHT },
    QUAD_4:   { gridPos: QUARTER_WIDTH_4_on_4 + DEFAULT_HEIGHT },
    SIXTH_1:  { gridPos: SIXTH_WIDTH_1_on_6 + DEFAULT_HEIGHT },
    SIXTH_2:  { gridPos: SIXTH_WIDTH_2_on_6 + DEFAULT_HEIGHT },
    SIXTH_3:  { gridPos: SIXTH_WIDTH_3_on_6 + DEFAULT_HEIGHT },
    SIXTH_4:  { gridPos: SIXTH_WIDTH_4_on_6 + DEFAULT_HEIGHT },
    SIXTH_5:  { gridPos: SIXTH_WIDTH_5_on_6 + DEFAULT_HEIGHT },
    SIXTH_6:  { gridPos: SIXTH_WIDTH_6_on_6 + DEFAULT_HEIGHT },

    FULL_H2:     { gridPos: FULL_WIDTH        + DOUBLE_HEIGHT },
    HALF_1_H2:   { gridPos: HALF_WIDTH_1_on_2 + DOUBLE_HEIGHT },
    HALF_2_H2:   { gridPos: HALF_WIDTH_2_on_2 + DOUBLE_HEIGHT },
    THIRD_1_H2:  { gridPos: THIRD_WIDTH_1_on_3 + DOUBLE_HEIGHT },
    THIRD_2_H2:  { gridPos: THIRD_WIDTH_2_on_3 + DOUBLE_HEIGHT },
    THIRD_3_H2:  { gridPos: THIRD_WIDTH_2_on_3 + DOUBLE_HEIGHT },
    QUAD_1_H2:   { gridPos: QUARTER_WIDTH_1_on_4 + DOUBLE_HEIGHT },
    QUAD_2_H2:   { gridPos: QUARTER_WIDTH_2_on_4 + DOUBLE_HEIGHT },
    QUAD_3_H2:   { gridPos: QUARTER_WIDTH_3_on_4 + DOUBLE_HEIGHT },
    QUAD_4_H2:   { gridPos: QUARTER_WIDTH_4_on_4 + DOUBLE_HEIGHT },
    SIXTH_1_H2:  { gridPos: SIXTH_WIDTH_1_on_6 + DOUBLE_HEIGHT },
    SIXTH_2_H2:  { gridPos: SIXTH_WIDTH_2_on_6 + DOUBLE_HEIGHT },
    SIXTH_3_H2:  { gridPos: SIXTH_WIDTH_3_on_6 + DOUBLE_HEIGHT },
    SIXTH_4_H2:  { gridPos: SIXTH_WIDTH_4_on_6 + DOUBLE_HEIGHT },
    SIXTH_5_H2:  { gridPos: SIXTH_WIDTH_5_on_6 + DOUBLE_HEIGHT },
    SIXTH_6_H2:  { gridPos: SIXTH_WIDTH_6_on_6 + DOUBLE_HEIGHT },

    FULL_H3:     { gridPos: FULL_WIDTH        + TRIPLE_HEIGHT },
    HALF_1_H3:   { gridPos: HALF_WIDTH_1_on_2 + TRIPLE_HEIGHT },
    HALF_2_H3:   { gridPos: HALF_WIDTH_2_on_2 + TRIPLE_HEIGHT },
    THIRD_1_H3:  { gridPos: THIRD_WIDTH_1_on_3 + TRIPLE_HEIGHT },
    THIRD_2_H3:  { gridPos: THIRD_WIDTH_2_on_3 + TRIPLE_HEIGHT },
    THIRD_3_H3:  { gridPos: THIRD_WIDTH_2_on_3 + TRIPLE_HEIGHT },
    QUAD_1_H3:   { gridPos: QUARTER_WIDTH_1_on_4 + TRIPLE_HEIGHT },
    QUAD_2_H3:   { gridPos: QUARTER_WIDTH_2_on_4 + TRIPLE_HEIGHT },
    QUAD_3_H3:   { gridPos: QUARTER_WIDTH_3_on_4 + TRIPLE_HEIGHT },
    QUAD_4_H3:   { gridPos: QUARTER_WIDTH_4_on_4 + TRIPLE_HEIGHT },
    SIXTH_1_H3:  { gridPos: SIXTH_WIDTH_1_on_6 + TRIPLE_HEIGHT },
    SIXTH_2_H3:  { gridPos: SIXTH_WIDTH_2_on_6 + TRIPLE_HEIGHT },
    SIXTH_3_H3:  { gridPos: SIXTH_WIDTH_3_on_6 + TRIPLE_HEIGHT },
    SIXTH_4_H3:  { gridPos: SIXTH_WIDTH_4_on_6 + TRIPLE_HEIGHT },
    SIXTH_5_H3:  { gridPos: SIXTH_WIDTH_5_on_6 + TRIPLE_HEIGHT },
    SIXTH_6_H3:  { gridPos: SIXTH_WIDTH_6_on_6 + TRIPLE_HEIGHT },

    FULL_H4:     { gridPos: FULL_WIDTH        + QUAD_HEIGHT },
    HALF_1_H4:   { gridPos: HALF_WIDTH_1_on_2 + QUAD_HEIGHT },
    HALF_2_H4:   { gridPos: HALF_WIDTH_2_on_2 + QUAD_HEIGHT },
    THIRD_1_H4:  { gridPos: THIRD_WIDTH_1_on_3 + QUAD_HEIGHT },
    THIRD_2_H4:  { gridPos: THIRD_WIDTH_2_on_3 + QUAD_HEIGHT },
    THIRD_3_H4:  { gridPos: THIRD_WIDTH_2_on_3 + QUAD_HEIGHT },
    QUAD_1_H4:   { gridPos: QUARTER_WIDTH_1_on_4 + QUAD_HEIGHT },
    QUAD_2_H4:   { gridPos: QUARTER_WIDTH_2_on_4 + QUAD_HEIGHT },
    QUAD_3_H4:   { gridPos: QUARTER_WIDTH_3_on_4 + QUAD_HEIGHT },
    QUAD_4_H4:   { gridPos: QUARTER_WIDTH_4_on_4 + QUAD_HEIGHT },
    SIXTH_1_H4:  { gridPos: SIXTH_WIDTH_1_on_6 + QUAD_HEIGHT },
    SIXTH_2_H4:  { gridPos: SIXTH_WIDTH_2_on_6 + QUAD_HEIGHT },
    SIXTH_3_H4:  { gridPos: SIXTH_WIDTH_3_on_6 + QUAD_HEIGHT },
    SIXTH_4_H4:  { gridPos: SIXTH_WIDTH_4_on_6 + QUAD_HEIGHT },
    SIXTH_5_H4:  { gridPos: SIXTH_WIDTH_5_on_6 + QUAD_HEIGHT },
    SIXTH_6_H4:  { gridPos: SIXTH_WIDTH_6_on_6 + QUAD_HEIGHT },
}
