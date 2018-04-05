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
           output2   : out STD_LOGIC;
           output3   : out STD_LOGIC;
           output4   : out STD_LOGIC);
end proj_4;

architecture Behavioral of proj_4 is
signal pre_count                                                 :  std_logic_vector(7 downto 0);
  signal out_signal_width_count                                  :  std_logic_vector(2 downto 0);
signal presignal_time_clear_flag                                 :  STD_LOGIC;
signal postsignal_time_clear_flag                                :  STD_LOGIC;
signal signal_width                                              :  std_logic_vector(8 downto 0);
signal out_flag,PLL_CLK_t                                        :  STD_LOGIC;
signal one_second_precounter                                     :  std_logic_vector(22 downto 0);
signal seconds_counter_pre,seconds_counter_post, seconds_counter :  std_logic_vector(7 downto 0);
signal pre_counter                                               :  std_logic_vector(22 downto 0);
signal PLL_CLK_in, pre_count_flag                                :  STD_LOGIC;
signal output_allowed_flag,count_allowed_flag                    :  STD_LOGIC := '0';
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


Noise_reduction: process( pres_state, next_state, clk, input, output1, pre_count, presignal_time_clear_flag, output_allowed_flag, PLL_CLK_t  )

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
    --    output4  <= '0';
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



      --     if out_signal_width_count != x"3" then
      --       output2 <= '0';
      --       next_state <= reset_counter;
      --     elsif out_signal_width_count = x"3" then
      -- --      out_signal_width_count <= out_signal_width_count + "1";
      --       output2 <= '1';
      --       next_state <= reset_counter;
      --     end if;
      --     next_state <= reset_counter;

        end case;
-- case pres_state is
--   when reset_FSM =>
--         presignal_time_clear_flag <= '0';
--         output2 <= '0';
--         output4  <= '0';
--     next_state <= reset_counter;
--
--   when reset_counter =>
--   output3  <= '0';
--         pre_count  <= (others=>'0');
--         seconds_counter <= (others=>'0');
--         output_allowed_flag <= '0';
--         count_allowed_flag  <= '1';
--     next_state <= counter;
--   when counter =>
-- output3  <= '1';
--
--         if input = '1' then
--     next_state <= reset_counter;
--         end if;
--         if count_allowed_flag = '1' then
--           if  rising_edge(output1) and pre_count < x"A"  then
--              pre_count <= pre_count + "1";
--           end if;
--           if pre_count = x"A" and presignal_time_clear_flag = '0' then
--     next_state <= flag;
--             elsif  pre_count = x"A" and presignal_time_clear_flag = '1' then
--     next_state <= out_signal_on;
--         else
--     next_state <= counter;
--           end if;
--         end if;
--   when flag =>
--         presignal_time_clear_flag  <= '1';
--     next_state <= reset_counter;
--   when out_signal_on =>
--
--
--
--
--         if rising_edge(output1) then
--           output2 <= '1';
--           count_allowed_flag <= '0';
--           output_allowed_flag <= '1';
--         end if;
--     next_state <= out_signal_off;
--   when out_signal_off =>
--         for I in 3 downto 0 loop
--           if rising_edge(output1) then
--             output2 <= not output2;
--           end if;
--         end loop;
--     next_state <= reset_FSM;
--
--
--
-- --     if out_signal_width_count != x"3" then
-- --       output2 <= '0';
-- --       next_state <= reset_counter;
-- --     elsif out_signal_width_count = x"3" then
-- -- --      out_signal_width_count <= out_signal_width_count + "1";
-- --       output2 <= '1';
-- --       next_state <= reset_counter;
-- --     end if;
-- --     next_state <= reset_counter;
--
--   end case;
end process Noise_reduction;



CLK_1Hz: process(PLL_CLK_t, clk, enable, reset)
begin
  if reset = '1'then -- or pre_counter1 > x"4C4B40" then
     pre_counter <= (others=>'0');
   elsif (PLL_CLK_t='1' and PLL_CLK_t'event) then
     if enable = '1' then
       pre_counter <= pre_counter + "1";
       if pre_counter = x"4C4B40" then
        output1 <= not output1;
        pre_counter <= (others=>'0');
        seconds_counter <= seconds_counter + "1" ;
      end if;
    end if;
   end if;
 end process;

statereg: process (clk, enable, output1)
  begin
    if (enable = '0') then
      pres_state <= reset_FSM;
    elsif (clk'event and clk ='1') then
          pres_state <= next_state;
     end if;
end process statereg;

-----------------parallel process realisation
-- presignal_counter: process(output1, enable, reset, input, pre_count_flag, presignal_time_clear_flag)
-- begin
-- if presignal_time_clear_flag = '0' then
--   if seconds_counter_pre > x"A" then
--     pre_count_flag <= '1';
--     seconds_counter_pre <= (others=>'0');
--     elsif  seconds_counter_pre <= x"A" and pre_count_flag = '0' and  input = '1' then
--       seconds_counter_pre <= (others=>'0');
--       presignal_time_clear_flag <='0';
--       pre_count_flag <= '0';
--   elsif rising_edge(output1) and seconds_counter_pre <= x"A" and pre_count_flag = '0' then
--   		  pre_count <= pre_count + "1";
--         presignal_time_clear_flag <= '0';
--
--       end if;
--  	end if;
--
-- if pre_count_flag = '1' then
--   if rising_edge(output1) and input = '1' then
--     presignal_time_clear_flag <= '1';
--     seconds_counter_pre <= (others=>'0');
--   end if;
-- end if;
-- end process;
--
-- postsignal_counter: process(output1, enable, reset, input)
-- begin
-- if presignal_time_clear_flag = '1' then
--   if seconds_counter_pre > x"A" then
--      postsignal_time_clear_flag <= '1';
--      seconds_counter_post <= (others=>'0');
--      out_flag <= '1';
--   elsif rising_edge(output1) and seconds_counter_post <= x"A"  then
--   		  pre_count <= pre_count + "1";
--         if input = '1' then
--           seconds_counter_post <= (others=>'0');
--           presignal_time_clear_flag <='0';
--           postsignal_time_clear_flag <='0';
--           pre_count_flag <= '0';
--           out_flag <= '0';
--
--       	end if;
--  	end if;
-- end if;
--
--   if rising_edge(output1) and input = '1' then
--     postsignal_time_clear_flag <= '0';
--     seconds_counter_post <= (others=>'0');
--     pre_count_flag <= '0';
--   end if;
-- end process;
--
-- output_write: process (out_flag, output1)
-- begin
--   if rising_edge(output1) and out_flag = '1' then
--     output2 <= '1';
--   end if;
-- end process;
--
-------------------------------------------------------------------------------
--count: process (clk, input, enable, reset, pre_count, signal_width, output1)
-- begin
--
-- 	if  rising_edge(clk) and enable = '1'  then --and pre_count<x"5F5E100"
-- 		 pre_count <= pre_count + "1";
-- 	end if;
--
--   if  pre_count > x"64"  then
-- 			flag <= '1';
-- 	   else
--
-- 			output2 <= '0';
-- 	end if;
-- --
-- if flag = '1' and pre_count > x"64" then
--   for і іn 1 to 30 loop
--
--     output <= '1';
--   end loop;
-- end if;
--
  -- if  input = '1' then
	-- 	pre_count <= (others=>'0'); -- обнуляем все разряды логического вектора count
	-- end if;
--
--
			-- elsif input = '1' then
					-- pre_count <= (others=>'0');
					-- output <= '0';
--
					-- elsif  pre_count=x"5F5E100" then
						-- output <= '1';
						-- pre_count <= (others=>'0');
--
			--end if;
--end process count;
end Behavioral;
