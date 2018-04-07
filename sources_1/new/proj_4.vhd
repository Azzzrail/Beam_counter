----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 08.02.2016 20:12:11
-- Design Name:
-- Module Name: proj_4 - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity proj_4 is
    Port ( clk       : in STD_LOGIC;
    		   reset     : in STD_LOGIC;
		       enable    : in STD_LOGIC;
		       input     : in STD_LOGIC;
           output2   : out STD_LOGIC);
end proj_4;

architecture Behavioral of proj_4 is
signal pre_count                                   :  std_logic_vector(7 downto 0);
signal presignal_time_clear_flag                   :  STD_LOGIC := '0';
signal postsignal_time_clear_flag                  :  STD_LOGIC := '0';
signal out_flag,PLL_CLK_t,pre_count_clr_flag_out   :  STD_LOGIC := '0' ;
signal pre_count_clr_flag_conditions               :  STD_LOGIC := '0' ;
signal PLL_CLK_in                                  :  STD_LOGIC := '0' ;



component clkip
 port
  (-- Clock in ports
   -- Clock out ports
   clk_out1         : out    std_logic;
   clk_in1          : in     std_logic
  );
 end component;

begin
IP_clock : clkip
  port map (
 -- Clock out ports
  clk_out1 => PLL_CLK_t,
  -- Clock in ports
  clk_in1 => PLL_CLK_in
);

PLL_CLK_in <= clk;
---------------parallel process realisation
-----------------------------------------------------------------------------
conditions: process (PLL_CLK_t, input, pre_count, PLL_CLK_t, pre_count_clr_flag_out)
begin
  if rising_edge(PLL_CLK_t) then
    if pre_count_clr_flag_out  = '1' then
      out_flag  <= '0';
      presignal_time_clear_flag <= '0';
      postsignal_time_clear_flag <= '0';
      elsif pre_count = x"5" and presignal_time_clear_flag = '0' then
        presignal_time_clear_flag <= '1';
        elsif pre_count = x"A" and presignal_time_clear_flag = '1' and postsignal_time_clear_flag = '0' then
          postsignal_time_clear_flag <= '1';
          out_flag  <= '1';
    end if;
  end if;
end process conditions;

counter: process (PLL_CLK_t, out_flag, input, pre_count, pre_count_clr_flag_out)
begin
  if ( out_flag  = '0' and input = '1' ) or  (pre_count_clr_flag_out = '1') then
    pre_count <= (others=>'0');
    elsif rising_edge(PLL_CLK_t) and out_flag  = '0' and input = '0' then
      pre_count <= pre_count + "1";
  end if;
end process counter;

output_on: process (out_flag, PLL_CLK_t)
begin
  if rising_edge(PLL_CLK_t)  then
    if out_flag  = '1' then
      output2  <= '1';
      pre_count_clr_flag_out <= '1';
      else
        output2  <= '0';
        pre_count_clr_flag_out <= '0';
    end if;
  end if;
end process output_on;

----------------------------FSM realisation
-- Noise_reduction: process( pres_state, next_state, clk, input, pre_count, presignal_time_clear_flag, PLL_CLK_t  )
--
--     begin
--       case pres_state is
--         when reset_FSM =>
--           if  rising_edge(clk)  then
--             presignal_time_clear_flag <= '0';
--             output4  <= '0';
--           end if;
--           next_state <= reset_counter;
--         when reset_counter =>
--           if  rising_edge(clk)  then
--             output3  <= '0';
--             pre_count  <= (others=>'0');
--           end if;
--           next_state <= counter;
--         when counter =>
--           if pre_count = x"3" and presignal_time_clear_flag = '0' then
--             next_state <= flag;
--             elsif  pre_count = x"3" and presignal_time_clear_flag = '1' then
--               next_state <= out_signal_on;
--                 elsif input = '1' then
--                   next_state <= reset_counter;
--                   elsif rising_edge(clk) and pre_count < x"3" then
--                       pre_count <= pre_count + "1";
--           end if;
--         when flag =>
--           output3  <= '1';
--           presignal_time_clear_flag <= '1';
--           if  rising_edge(clk)  then
--             next_state <= reset_counter;
--           end if;
--         when out_signal_on =>
--           output4  <= '1';
--           next_state <= reset_FSM;
--         when out_signal_off =>
--           next_state <= reset_FSM;
--         end case;
--
-- end process Noise_reduction;

end Behavioral;
