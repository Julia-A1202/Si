library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    Port (
        clk   : in std_logic;
        data  : in std_logic_vector(7 downto 0);
        start : in std_logic;
        tx    : out std_logic;
        busy  : out std_logic
    );
end;

architecture Behavioral of uart_tx is
signal cnt : integer := 0;
signal shift : std_logic_vector(9 downto 0);
signal sending : std_logic := '0';
begin

process(clk)
begin
if rising_edge(clk) then

    if sending = '0' then
        if start = '1' then
            shift <= '1' & data & '0';
            sending <= '1';
            cnt <= 0;
        end if;
    else
        cnt <= cnt + 1;

        if cnt = 10416 then
            tx <= shift(0);
            shift <= '1' & shift(9 downto 1);

            if shift = "1111111111" then
                sending <= '0';
            end if;
        end if;
    end if;

    busy <= sending;

end if;
end process;

end Behavioral;
