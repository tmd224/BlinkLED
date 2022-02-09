library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity led is
    Port (
        refclk : in std_logic;
        sw : in std_logic_vector(1 downto 0);
        led : out std_logic
    );
end led;

architecture RTL of led is
    constant sys_clk : natural := 12E6;
    constant FREQ_1_HZ : natural := sys_clk / 2 / 1;
    constant FREQ_2_Hz : natural := sys_clk / 2 / 2;
    constant FREQ_4_Hz : natural := sys_clk / 4 / 2;
    constant FREQ_8_Hz : natural := sys_clk / 8 / 2;
    constant max_count : natural := FREQ_1_HZ;
    -- constant FREQ_4_Hz : natural := sys_clk / 4;
    
    signal count_val : natural := FREQ_1_HZ;
    signal Rst : std_logic;
    signal state : std_logic := '0';

begin
    
    Rst <= '0';

    -- modify counter value based on switch inputs
    process(refclk, sw)
    begin 
        if rising_edge(refclk) then
            if sw = "00" then
                count_val <= FREQ_1_HZ;
                Rst <= '0';
            elsif sw = "01" then   
                count_val <= FREQ_2_HZ;
                Rst <= '0'; 
            elsif sw = "11" then
                count_val <= FREQ_4_HZ;
                Rst <= '0';      
            elsif sw = "10" then
                count_val <= FREQ_8_HZ;
                Rst <= '0';                          
            end if;    
        end if;                
    end process;
    
    
    -- 0 to max_count counter
    process(refclk, count_val, Rst)
        variable count : natural range 0 to max_count;
    begin
        if Rst = '1' then
            count := 0;
            led <= '1';
            Rst <= '0';
            
        elsif rising_edge(refclk) then
            if count < count_val then
                count := count + 1;                
            else
                count := 0;
                if state = '0' then
                    led <= '1';
                    state <= '1';
                else
                    led <= '0';
                    state <= '0';
                end if;             
            end if;
        end if;
    end process; 
 end RTL;
    
    