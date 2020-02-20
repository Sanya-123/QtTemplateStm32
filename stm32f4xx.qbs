import qbs
import qbs.FileInfo

Product {
    type: ["application", "bin", "hex", "size"/*, "disassembly"*/]
    Depends { name:"cpp" }
    cpp.positionIndependentCode: false
    cpp.enableExceptions: false
    cpp.executableSuffix: ".elf"

    cpp.defines: [
        "%{TypeDef}",
    ]

    files: [
        "CMSIS/Source/Templates/gcc/startup_%{TypeDef}.s",
        "CMSIS/Source/Templates/system_stm32f4xx.c",
        "*.c",
    ]

    cpp.includePaths: [
        "CMSIS/Include/",
        "Driver/",
        "./",
    ]

    cpp.driverFlags: [
        "-mthumb",
        "-mcpu=cortex-m4",
        "-mfloat-abi=hard",
        //"-msoft-float",
        "-mfpu=fpv4-sp-d16",
        "-fno-strict-aliasing",
        "-fdata-sections",
        "-ffunction-sections",
        "-fshort-enums",
        //"-flto",
        "-finput-charset=UTF-8",
        "-fexec-charset=cp1251",
        "-std=gnu11",
        "-Wall",
        "-Wpedantic",
        "-Wno-main",
        "-Wno-unused-function",
        "-Wno-old-style-declaration",
        "-specs=nano.specs",
    ]

    cpp.commonCompilerFlags: [

    ]

    cpp.linkerFlags :  [
        "-print-memory-usage",
        "-start-group",
        "-gc-sections",
        "-lnosys",
        "-nostdlib",
        "-T" + path + "/%{TypeDef}_FLASH.ld",
    ]

    Properties {
        condition: qbs.buildVariant === "debug"
        cpp.driverFlags: outer.concat(["-Og", "-ggdb", "-DDEBUG=1"])
    }

    Properties {
        condition: qbs.buildVariant === "release"
        cpp.driverFlags: outer.concat(["-Og", "-g0", "-s", "-DDEBUG=0"])
    }

    Rule {
        id: bin
        inputs: "application"
        Artifact {
            fileTags: ["bin"]
           filePath: FileInfo.baseName(input.filePath) + ".bin"
        }
        prepare: {
                var args = ["-O", "binary", input.filePath, output.filePath];
                var cmd = new Command("arm-none-eabi-objcopy", args);
                cmd.description = "converting to bin: "+FileInfo.fileName(input.filePath);
                cmd.highlight = "linker";
                return cmd;
        }
    }

    Rule {
        id: hex
        inputs: "application"
        Artifact {
            fileTags: ["hex"]
            filePath: FileInfo.baseName(input.filePath) + ".hex"
        }
        prepare: {
            var args = ["-O", "ihex", input.filePath, output.filePath];
            var cmd = new Command("arm-none-eabi-objcopy", args);
            cmd.description = "converting to hex: "+FileInfo.fileName(input.filePath);
            cmd.highlight = "linker";
            return cmd;
        }
    }

    Rule {
        id: size
        inputs: ["application"]
        Artifact {
            fileTags: ["size"]
            filePath: "-"
        }
        prepare: {
            var args = [input.filePath];
            var cmd = new Command("arm-none-eabi-size", args);
            cmd.description = "File size: " + FileInfo.fileName(input.filePath);
            cmd.highlight = "linker";
            return cmd;
        }
    }
    Rule {
        id: disassmbly
        inputs: "application"
        Artifact {
            fileTags: ["disassembly"]
            filePath: FileInfo.baseName(input.filePath) + ".lst"
        }
        prepare: {
            var args = [input.filePath, "-D","-S"];
            var cmd = new Command("arm-none-eabi-objdump", args);
            cmd.stdoutFilePath = output.filePath;//TODO output file
            cmd.description = "Disassembly listing for " + FileInfo.fileName(input.filePath);
            cmd.highlight = "disassembler";

            return cmd;
        }
    }
}
