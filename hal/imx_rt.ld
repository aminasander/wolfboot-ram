/* Specify the memory areas */
MEMORY
{
  FLASH(rx)  : ORIGIN = @ARCH_FLASH_OFFSET@, LENGTH = @BOOTLOADER_PARTITION_SIZE@
  RAM(rwx)   : ORIGIN = 0x20000000, LENGTH = 0x0001FFF0
}

/* Define output sections */
SECTIONS
{
    .text :
    {
        _start_text = .;
        KEEP(*(.flash_config))
        . = ORIGIN(FLASH) + 0x1000;
        KEEP(*(.image_vt))
        KEEP(*(.boot_data))
        __dcd_data_start = .;
        KEEP(*(.dcd_data))
        . = ORIGIN(FLASH) + 0x2000;
        KEEP(*(.isr_vector))
        . = ALIGN(0x8);

    *(EXCLUDE_FILE(
        /* Exclude flash operation functions. */
        */fsl_cache.o
        *libc.a:lib_a-memcpy.o
    ) .text)                 /* .text sections (code) */
    *(EXCLUDE_FILE(
        /* Exclude flash operation functions. */
        */fsl_cache.o
        *libc.a:lib_a-memcpy.o
    ) .text*)                /* .text* sections (code) */
    *(EXCLUDE_FILE(
        /* Exclude flash operation functions. */
        */fsl_cache.o
        *libc.a:lib_a-memcpy.o
    ) .rodata)               /* .rodata sections (constants, strings, etc.) */
    *(EXCLUDE_FILE(
        /* Exclude flash operation functions. */
        */fsl_cache.o
        *libc.a:lib_a-memcpy.o
    ) .rodata*)              /* .rodata* sections (constants, strings, etc.) */

        *(.glue_7)               /* glue arm to thumb code */
        *(.glue_7t)              /* glue thumb to arm code */
        *(.eh_frame)
        KEEP (*(.init))
        KEEP (*(.fini))
        . = ALIGN(4);
        _end_text = .;
    } > FLASH
    .ARM.extab :
    {
      *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > FLASH
    .ARM :
    {
      __exidx_start = .;
      *(.ARM.exidx*)
      __exidx_end = .;
    } > FLASH
    _stored_data = .;

    .data : AT (_stored_data)
    {
        _start_data = .;
        KEEP(*(.ramcode*))

      /* Explicitly place flash operation functions in RAM. */
      KEEP(*/fsl_cache.o(.text .text* .rodata .rodata*))
      
      /* Place memcpy in RAM as wolfboot uses memcpy in cojunction with BOOT ROM erase/write */
      KEEP(*libc.a:lib_a-memcpy.o (.text*))
      

        . = ALIGN(4);
        KEEP(*(.data*))
        . = ALIGN(4);
        _end_data = .;
    } > RAM

    .bss (NOLOAD) :
    {
        _start_bss = .;
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _end_bss = .;
        __bss_end__ = .;
        _end = .;
    } > RAM
    . = ALIGN(4);
}

END_STACK = ORIGIN(RAM) + LENGTH(RAM);
