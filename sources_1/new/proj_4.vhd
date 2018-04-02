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
    Port ( clk      : in STD_LOGIC;
--    		   GHzClk   : out STD_LOGIC;
    		   reset    : in STD_LOGIC;
		       enable   : in STD_LOGIC;
		       input    : in STD_LOGIC;
           output1   : inout STD_LOGIC;
           output2   : inout STD_LOGIC);
end proj_4;

architecture Behavioral of proj_4 is
signal pre_count                         :  std_logic_vector(7 downto 0);
signal out_signal_width_count            :  std_logic_vector(4 downto 0);
signal prev_time_clear_flag              :  STD_LOGIC;
signal signal_width                      :  std_logic_vector(8 downto 0);
signal One_Hz_clk,PLL_CLK_t              :  STD_LOGIC;
signal one_second_precounter             :  std_logic_vector(22 downto 0);
signal seconds_counter                   :  std_logic_vector(3 downto 0);
signal pre_counter1                      :  std_logic_vector(22 downto 0);
signal pre_counter2                      :  std_logic_vector(26 downto 0);
signal one_second_counter, PLL_CLK_in    :  STD_LOGIC;
type state_values is (reset_FSM, counter, flag, out_signal);
signal pres_state, next_state : state_values;


component clkip
 port
  (-- Clock in ports
   -- Clock out ports
   PLL_CLK          : out    std_logic;
   clk_in1          : in     std_logic
  );
 end component;

begin
IP_clock : clkip
  port map (
 -- Clock out ports
  PLL_CLK => PLL_CLK_t,
  -- Clock in ports
  clk_in1 => clk
);



Noise_reduction: process( pres_state, next_state, clk, input  )
    begin



      case pres_state is
        when reset_FSM =>
        pre_count  <= (others=>'0');
        next_state <= counter;


        when counter =>

        if  rising_edge(clk) and pre_count < x"65"  then
      		 pre_count <= pre_count + "1";
      	end if;

        if input = '1' then
        next_state <= reset_FSM;
        end if;

        if pre_count = x"64" and prev_time_clear_flag = '0' then
          next_state <= flag;
            elsif  pre_count = x"64" and prev_time_clear_flag = '1' then
              next_state <= out_signal;
        end if;


        when flag =>
        prev_time_clear_flag  <= '1';
        next_state <= reset_FSM;

        when out_signal =>
        if out_signal_width_count >= x"1F" then
--          output <= '0';
          next_state <= reset_FSM;
        elsif out_signal_width_count < x"1F" and rising_edge(clk) then
          out_signal_width_count <= out_signal_width_count + "1";
          --output <= '1';
        end if;

      next_state <= reset_FSM;
      end case;
   end process Noise_reduction;

Sec_counter: process (clk, enable)
 begin
  if (enable = '1' and rising_edge(PLL_CLK_t)) then
     one_second_precounter <= one_second_precounter + '1';
  --   output <= one_second_precounter(22);
  end if;

  -- if one_second_precounter >= x"4C4B41" then
  -- --  one_second_counter <= one_second_precounter(22);
  --   one_second_precounter <= (others=>'0');
  --
  -- end if;
end process Sec_counter;

CLK_1Hz: process(PLL_CLK_t, clk, enable, reset)
begin
  if reset = '1'then -- or pre_counter1 > x"4C4B40" then
     pre_counter1 <= (others=>'0');
   elsif (PLL_CLK_t='1' and PLL_CLK_t'event) then
     if enable = '1' then
       pre_counter1 <= pre_counter1 + "1";
       if pre_counter1 = x"4C4B40" then
        output1 <= not output1;
        pre_counter1 <= (others=>'0');
        seconds_counter <= seconds_counter + "1" ;
      end if;
    end if;
   end if;
 end process;

 CLK_1H : process(PLL_CLK_t, clk, enable, reset)
 begin
   if reset = '1' then --or pre_counter2 > x"5F5E100"then
      pre_counter2 <= (others=>'0');
    elsif (clk='1' and clk'event) then
      if enable = '1' then
        pre_counter2 <= pre_counter2 + "1";
        if pre_counter2 = x"5F5E100" then
         output2 <= not output2;
         pre_counter2 <= (others=>'0');
       end if;
     end if;
    end if;

  end process;

statereg: process (clk, enable)
  begin
    if (enable = '0') then
      pres_state <= reset_FSM;
        elsif (clk'event and clk ='1') then
          pres_state <= next_state;
     end if;
end process statereg;
end Behavioral;



-- count: process (clk, input, enable, reset, pre_count, signal_width)
--  begin
--
--
-- 	if  rising_edge(clk) and enable = '1'  then --and pre_count<x"5F5E100"
-- 		 pre_count <= pre_count + "1";
-- 	end if;
--
--   if  pre_count > x"64"  then
-- 			flag <= '1';
-- 	   else
--
-- 			output <= '0';
-- 	end if;
--
--   if flag = '1' and pre_count > x"64" then
--     for і іn 1 to 30 loop
--
--       output <= '1';
--     end loop;
--   end if;
--
--   if  input = '1' then
-- 		pre_count <= (others=>'0'); -- обнуляем все разряды логического вектора count
-- 	end if;
--
--
-- 				-- elsif input = '1' then
-- 					-- pre_count <= (others=>'0');
-- 					-- output <= '0';
--
-- 					-- elsif  pre_count=x"5F5E100" then
-- 						-- output <= '1';
-- 						-- pre_count <= (others=>'0');
--
-- 			--end if;
--
--
--
--          end process count;
