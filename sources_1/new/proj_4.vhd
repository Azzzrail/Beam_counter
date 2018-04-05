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
           output1   : inout STD_LOGIC;
           output2   : out STD_LOGIC;
           output3   : out STD_LOGIC;
           output4   : out STD_LOGIC);
end proj_4;

architecture Behavioral of proj_4 is
signal pre_count                                   :  std_logic_vector(7 downto 0);
signal out_signal_width_count                      :  std_logic_vector(2 downto 0);
signal presignal_time_clear_flag                   :  STD_LOGIC;
signal postsignal_time_clear_flag                  :  STD_LOGIC;
signal signal_width                                :  std_logic_vector(8 downto 0);
signal out_flag,PLL_CLK_t                          :  STD_LOGIC;
signal one_second_precounter                       :  std_logic_vector(22 downto 0);
signal pre_counter                                 :  std_logic_vector(22 downto 0);
signal PLL_CLK_in, pre_count_flag                  :  STD_LOGIC;
signal output_allowed_flag,count_allowed_flag      :  STD_LOGIC := '0';
type state_values is (reset_FSM, reset_counter, counter, flag, out_signal_on, out_signal_off);
signal pres_state, next_state : state_values;


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
  clk_in1 => clk
);


Noise_reduction: process( pres_state, next_state, clk, input, output1, pre_count, presignal_time_clear_flag, PLL_CLK_t  )

    begin
      case pres_state is
        when reset_FSM =>
          if  rising_edge(clk)  then
            presignal_time_clear_flag <= '0';
            output4  <= '0';
          end if;
          next_state <= reset_counter;
        when reset_counter =>
          if  rising_edge(clk)  then
            output3  <= '0';
            pre_count  <= (others=>'0');
          end if;
          next_state <= counter;
        when counter =>
          if pre_count = x"3" and presignal_time_clear_flag = '0' then
            next_state <= flag;
            elsif  pre_count = x"3" and presignal_time_clear_flag = '1' then
              next_state <= out_signal_on;
                elsif input = '1' then
                  next_state <= reset_counter;
                  elsif rising_edge(clk) and pre_count < x"3" then
                      pre_count <= pre_count + "1";
          end if;
        when flag =>
          output3  <= '1';
          presignal_time_clear_flag <= '1';
          if  rising_edge(clk)  then
            next_state <= reset_counter;
          end if;
        when out_signal_on =>
          output4  <= '1';
          next_state <= reset_FSM;
        when out_signal_off =>
          next_state <= reset_FSM;
        end case;

end process Noise_reduction;


statereg: process (clk, enable, output1)
  begin
    if (enable = '0') then
      pres_state <= reset_FSM;
    elsif (clk'event and clk ='1') then
          pres_state <= next_state;
     end if;
end process statereg;

end Behavioral;
