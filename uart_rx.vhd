library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Port (
        clk   : in std_logic;
        rx    : in std_logic;
        data  : out std_logic_vector(7 downto 0);
        valid : out std_logic
    );
end;

architecture Behavioral of uart_rx is
signal cnt : integer := 0;
signal shift : std_logic_vector(9 downto 0);
signal busy : std_logic := '0';
begin

process(clk)
begin
if rising_edge(clk) then
    valid <= '0';

    if busy = '0' then
        if rx = '0' then
            busy <= '1';
            cnt <= 0;
        end if;
    else
        cnt <= cnt + 1;

        if cnt = 10416 then -- 100MHz / 9600
            shift <= rx & shift(9 downto 1);

            if cnt = 10416*9 then
                data <= shift(8 downto 1);
                valid <= '1';
                busy <= '0';
            end if;
        end if;
    end if;
end if;
end process;

end Behavioral;
