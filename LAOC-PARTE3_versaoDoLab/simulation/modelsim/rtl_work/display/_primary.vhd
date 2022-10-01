library verilog;
use verilog.vl_types.all;
entity display is
    port(
        entrada         : in     vl_logic_vector(3 downto 0);
        clockDisplay    : in     vl_logic;
        saida           : out    vl_logic_vector(0 to 6)
    );
end display;
