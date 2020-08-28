library verilog;
use verilog.vl_types.all;
entity LCD_CTRL is
    generic(
        write           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        up              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        down            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        left            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        right           : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        average         : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        mx              : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        my              : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        IROM_Q          : in     vl_logic_vector(7 downto 0);
        cmd             : in     vl_logic_vector(2 downto 0);
        cmd_valid       : in     vl_logic;
        IROM_EN         : out    vl_logic;
        IROM_A          : out    vl_logic_vector(5 downto 0);
        IRB_RW          : out    vl_logic;
        IRB_D           : out    vl_logic_vector(7 downto 0);
        IRB_A           : out    vl_logic_vector(5 downto 0);
        busy            : out    vl_logic;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of write : constant is 1;
    attribute mti_svvh_generic_type of up : constant is 1;
    attribute mti_svvh_generic_type of down : constant is 1;
    attribute mti_svvh_generic_type of left : constant is 1;
    attribute mti_svvh_generic_type of right : constant is 1;
    attribute mti_svvh_generic_type of average : constant is 1;
    attribute mti_svvh_generic_type of mx : constant is 1;
    attribute mti_svvh_generic_type of my : constant is 1;
end LCD_CTRL;
