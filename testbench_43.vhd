library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity project_tb is
end project_tb;


architecture projecttb of project_tb is
constant c_CLOCK_PERIOD		: time := 15 ns;
signal   tb_done		: std_logic;
signal   mem_address		: std_logic_vector (15 downto 0) := (others => '0');
signal   tb_rst		    : std_logic := '0';
signal   tb_start		: std_logic := '0';
signal   tb_clk		    : std_logic := '0';
signal   mem_o_data,mem_i_data		: std_logic_vector (7 downto 0);
signal   enable_wire  		: std_logic;
signal   mem_we		: std_logic;

type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
--test con righe e colonne a 0
RAM <= (2 => "00000000", 3 => "00000000", 4 => "11111010",  5 => "00001101", 6 => "00000010", 7 => "00000001", 8 => "00000000", 9 => "00010100", 10 => "00000010", 11 => "00000010", 12 => "00000000", 13 => "00000011", 14 => "00001100", 15 => "00000010", 16 => "00000010", 17 => "00000001", 18 => "00010110", 19 => "00000001", 20 => "00000000", 21 => "00000010", 22 => "00000100", 23 => "00000111", 24 => "00000100", 25 => "00001011", 26 => "00001001", 27 => "00000011", 28 => "00001011", 29 => "01111001", 30 => "00000010", 31 => "00000110", 32 => "00000001", 33 => "00000111", 34 => "00000010", 35 => "00000001", 36 => "00000000", 37 => "00000110", 38 => "00000101", 39 => "10000010", 40 => "00001001", 41 => "10000100", 42 => "00001101", 43 => "00000011", 44 => "00010000", 45 => "00011010", 46 => "00010110", 47 => "00011010", 48 => "00011011", 49 => "00100010", 50 => "00000010", 51 => "00000011", 52 => "00000000", 53 => "00000110", 54 => "00001100", 55 => "00010010", 56 => "00000111", 57 => "10111110", 58 => "00000010", 59 => "00001111", 60 => "00001100", 61 => "00100111", 62 => "00010110", 63 => "00011100", 64 => "00001010", 65 => "00000000", 66 => "00000010", 67 => "00000001", 68 => "00000000", 69 => "00000101", 70 => "00011110", 71 => "00000000", 72 => "00010001", 73 => "11110111", 74 => "00010111", 75 => "00010100", 76 => "00001010", 77 => "00101001", 78 => "00011001", 79 => "00011101", 80 => "00101001", 81 => "00010110", 82 => "00000010", 83 => "00000001", 84 => "00000000", 85 => "00001010", 86 => "00001100", 87 => "00001101", 88 => "00010101", 89 => "00010110", 90 => "11100111", 91 => "10011011", 92 => "00000000", 93 => "00001010", 94 => "00010001", 95 => "00011001", 96 => "00001101", 97 => "00110010", 98 => "00000010", 99 => "00000001", 100 => "00000100", 101 => "00000000", 102 => "00001111", 103 => "00010011", 104 => "00011101", 105 => "00010011", 106 => "00101101", 107 => "00000010", 108 => "00010100", 109 => "00010010", 110 => "00001100", 111 => "01001101", 112 => "01000000", 113 => "00011000", 114 => "00000010", 115 => "00000011", 116 => "00000000", 117 => "00000000", 118 => "00001111", 119 => "00010011", 120 => "00011101", 121 => "00010011", 122 => "00101101", 123 => "00000010", 124 => "00010100", 125 => "00100010", 126 => "00001100", 127 => "01001101", 128 => "01000000", 129 => "00011000", 130 => "00000010", 131 => "00000001", 132 => "00000000", 133 => "00000000", 134 => "00001111", 135 => "00010011", 136 => "00011101", 137 => "00010011", 138 => "00101101", 139 => "00000010", 140 => "00010100", 141 => "00010010", 142 => "00001100", 143 => "01001101", 144 => "01000000", 145 => "00011000", 146 => "00000010", 147 => "00000001", 148 => "00000110", 149 => "00000000", 150 => "00001111", 151 => "00010011", 152 => "00011101", 153 => "00010011", 154 => "00101101", 155 => "00000010", 156 => "00010100", 157 => "00010010", 158 => "00001100", 159 => "01001101", 160 => "01000000", 161 => "00011000", 162 => "00000010", 163 => "00001100", 164 => "00000000", 165 => "00001101", 166 => "00010000", 167 => "00001101", 168 => "10000110", 169 => "00000001", 170 => "00000101", 171 => "00111111", 172 => "00000001", 173 => "00011111", 174 => "00111111", 175 => "00101101", 176 => "00010101", 177 => "00001001", 178 => "00000010", 179 => "00000001", 180 => "00000000", others => (others =>'0'));

component project_reti_logiche is 
    port (
            i_clk         : in  std_logic;
            i_start       : in  std_logic;
            i_rst         : in  std_logic;
            i_data       : in  std_logic_vector(7 downto 0); --1 byte
            o_address     : out std_logic_vector(15 downto 0); --16 bit addr: max size is 255*255 + 3 more for max x and y and thresh.
            o_done            : out std_logic;
            o_en         : out std_logic;
            o_we       : out std_logic;
            o_data            : out std_logic_vector (7 downto 0)
          );
end component project_reti_logiche;


begin 
	UUT: project_reti_logiche
	port map (
		  i_clk      	=> tb_clk,	
          i_start       => tb_start,
          i_rst      	=> tb_rst,
          i_data    	=> mem_o_data,
          o_address  	=> mem_address, 
          o_done      	=> tb_done,
          o_en   	=> enable_wire,
		  o_we 	=> mem_we,
          o_data    => mem_i_data
);

p_CLK_GEN : process is
  begin
    wait for c_CLOCK_PERIOD/2;
    tb_clk <= not tb_clk;
  end process p_CLK_GEN; 
  
  
MEM : process(tb_clk)
   begin
    if tb_clk'event and tb_clk = '1' then
     if enable_wire = '1' then
      if mem_we = '1' then
       RAM(conv_integer(mem_address))              <= mem_i_data;
       mem_o_data                      <= mem_i_data after 1 ns;
      else
       mem_o_data <= RAM(conv_integer(mem_address)) after 1 ns;
      end if;
     end if;
    end if;
   end process;
 

  
test : process is
begin 
wait for 100 ns;
wait for c_CLOCK_PERIOD;
tb_rst <= '1';
wait for c_CLOCK_PERIOD;
tb_rst <= '0';
wait for c_CLOCK_PERIOD;
tb_start <= '1';
wait for c_CLOCK_PERIOD; 
tb_start <= '0';
wait until tb_done = '1';
wait until tb_done = '0';
wait until rising_edge(tb_clk); 
assert RAM(1) = "00000000" report "FAIL high bits" severity failure;
assert RAM(0) = "00000000" report "FAIL low bits" severity failure;
       


assert false report "Simulation Ended!, test passed" severity failure;

end process test;

end projecttb; 