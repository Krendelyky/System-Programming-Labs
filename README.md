# System-Programming-Labs

Лабораторні роботи з дисципліни «Системне програмування».

**Платформа:** STM32F411RET6 / NUCLEO-F411RE  
**Група:** ІО-34

## Лабораторна робота №1 — налаштування середовища та bring-up STM32

Результат роботи — технічна основа для наступних лабораторних: збірка прошивки в Docker, проєкт STM32CubeMX, тестова прошивка з виводом у UART, скануванням I²C1 і зчитуванням JEDEC ID SPI-флешу.

**[Звіт](docs/report.md)** · **[Скриншоти](docs/screenshots/README.md)**

## Структура репозиторію

| Шлях | Призначення |
|---|---|
| `Docker/Dockerfile` | Образ `ubuntu:22.04` з `gcc-arm-none-eabi`, newlib і srecord |
| `Makefile` | Кореневий Makefile: збірка в контейнері, прошивання, UART-монітор |
| `firmware/` | Проєкт, згенерований STM32CubeMX (`firmware.ioc`, `Core/`, `Drivers/`, `firmware/Makefile`, лінкер-скрипт) |
| `docs/` | Звіт і скриншоти |
| `docx-result/` | Звіт у форматі DOCX |

## Збірка та прошивання

Образ збирається один раз:

```bash
docker build -t stm32-build Docker/
```

Цілі кореневого Makefile:

| Команда | Дія |
|---|---|
| `make build` | Збирає `firmware/build/firmware.bin` у контейнері |
| `make clean` | Очищає артефакти збірки в контейнері |
| `make probe` | Перевіряє, чи видно плату (`st-info --probe`) |
| `make flash` | Збирає та прошиває плату (`st-flash`, адреса `0x08000000`) |
| `make monitor` | Відкриває UART-монітор (`picocom`, 115200 бод) |

Змінні `IMAGE`, `BIN_PATH`, `SERIAL_PORT` (за замовчуванням `/dev/ttyACM0`) і `BAUD` можна перевизначити:

```bash
make monitor SERIAL_PORT=/dev/ttyACM1
```

Для `flash`, `probe` і `monitor` потрібні `stlink-tools` та `picocom`.

## Конфігурація периферії

| Периферія | Піни | Параметри |
|---|---|---|
| USART2 | PA2 (TX), PA3 (RX) | 115200, 8N1; `printf` через `_write()` |
| I2C1 | PB8 (SCL), PB9 (SDA) | 100 кГц, 7-бітна адресація |
| SPI1 | PA5 (SCK), PA6 (MISO), PA7 (MOSI) | Master, 8 біт, програмний NSS |
| GPIO | PB6 | CS SPI-флешу |
| MCO1 | PA8 | Вихід тактового сигналу |

Тактування: HSI 16 МГц → PLL (M = 8, N = 84, P = 2) → SYSCLK = 84 МГц.

## Команда

| Учасник | Напрям |
|---|---|
| Колєснік В. | Репозиторій, Docker, build-система |
| Токарюк С. | CubeMX, прошивка bring-up, flash/monitor |
| Рибачок М. | Організація роботи, планування, звіт, README |
