library verilog;
use verilog.vl_types.all;
entity p3_cache is
    port(
        addr            : in     vl_logic_vector(4 downto 0);
        clock           : in     vl_logic;
        wren            : in     vl_logic;
        dataIn          : in     vl_logic_vector(7 downto 0);
        dataMemOut      : in     vl_logic_vector(7 downto 0);
        dataOut         : out    vl_logic_vector(7 downto 0);
        cacheWriteBackMem: out    vl_logic;
        dataCacheParaMem: out    vl_logic_vector(7 downto 0);
        hit             : out    vl_logic;
        blocoVia0       : out    vl_logic_vector(8 downto 0);
        blocoVia1       : out    vl_logic_vector(8 downto 0);
        blocoVia0Antes  : out    vl_logic_vector(8 downto 0);
        blocoVia1Antes  : out    vl_logic_vector(8 downto 0);
        dataMem         : out    vl_logic_vector(2 downto 0);
        dataInOut       : out    vl_logic_vector(2 downto 0);
        addrCacheOut    : out    vl_logic_vector(4 downto 0);
        via             : out    vl_logic
    );
end p3_cache;
