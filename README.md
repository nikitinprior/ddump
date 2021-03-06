Recreating the program DUMP.C to view Hi-Tech C compiler object files for CP/M.

Among the available files of the Hi-Tech C v3.09 compiler for CP/M, there is no DUMP.COM file for displaying the contents of object files created by programs from this package.
To correct this fact, the C source code was RESTORED by disassembling the DUMP.COM executable file from the Hi-Tech v1.3 compiler package.

To create a version of this program compiled with the 3.09 compiler, run the following command:

    cc -v -o dump.c

this will result in a new executable binary.

If DUMP.COM is run without parameters, it will look for the "l.obj" file.

When used as a parameter, the name of an object file will display information about its contents to the console. Multiple parameters can be specified for processing more than one object file.

The file "Object Code Format_en" contains information found on the Internet about the content of the object file. The file "DUMP.ASM" contains the disassembled code from which the source code of the C program was restored.

The restored program processes object files of the first versions. The subsequent development of the compiler and its support for various processors forced Hi-Tech to expand the functionality of the object file. However, for the Hi-Tech v3.09 compiler for CP/M, they are not required and the restored version of the program is sufficient.

Mark Ogden made the following changes to the dump.c program:
1. Fixed inaccuracies and decompilation errors.
2. Added explanatory comments.
3. Assigned meaningful names to variables and functions.
4. In some functions, excluded labels and goto statements.
5. With the encouragement of conditional compilation, the program is built and run on modern 64-bit systems.

Thanks to these changes, the program code has acquired a cleaner and more complete look.

Thanks to Mark Ogden for correcting the program code.

The new version of the program has the name dump3.c.


Appreciation

    to an unknown person named Michael, who saved information about Hi-Tech object files.
    
    Tony Nicholson for maintaining the compiler information and providing the Hi-Tech C v1.3 compiler. 
    
Andrey Nikitin
    
